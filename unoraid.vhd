library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.quadrado.all;
use work.quadrado2.all;
use work.grama.all;
use work.listra.all;
use work.numero.all;

entity unoraid is
	port (
		reset : in std_logic;
		clk_27: in std_logic;
		botao: in std_logic_vector(3 downto 0);
		VGA_CLK, -- Dot clock to DAC
		VGA_HS, -- Active-Low Horizontal Sync
		VGA_VS, -- Active-Low Vertical Sync
		VGA_BLANK, -- Active-Low DAC blanking control
		VGA_SYNC : out std_logic; -- Active-Low DAC Sync on Green
		VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0)
	);
end unoraid;

architecture rtl of unoraid is

	TYPE State_type is (e0, e1, e2, e3, e4);
	signal estado_atual: State_type;

	-------------------------
	-- Parametros de video --
	-------------------------

	--original do barth
	constant HTOTAL 			: integer := 1688;	
	constant HSYNC 			: integer := 112;	
	constant HBACK_PORCH		: integer := 248;	
	constant HACTIVE 			: integer := 1280;	
	constant HFRONT_PORCH 	: integer := 48;	
	constant HEND 				: integer := 1280;	

	constant VTOTAL 			: integer := 1066;	
	constant VSYNC 			: integer := 3;		
	constant VBACK_PORCH		: integer := 38;	
	constant VACTIVE			: integer := 1024;	
	constant VFRONT_PORCH 	: integer := 1;		
	constant VEND 				: integer := 1024;	

	--clock do vídeo 108MHz para 1280x1024@60Hz
	signal countclk: STD_LOGIC;
	-- Horizontal position (0-1687)
	signal HCount : integer range 0 to 1688 := 0;
	-- Vertical position (0-1065)
	signal VCount : integer range 0 to 1066 := 0;
	--Flags de sincronizacao do VGA
	signal vga_hsync, vga_vsync : std_logic;
	signal HPixel, VPixel: integer range 0 to 1280:=0;

	--Component
	component altclk
		PORT (
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC 
		);
	END component;
	---------------------------------

	------------------------------
	-- Parametros dos Objetos   --
	------------------------------
	signal personagem_x: integer range 0 to 1280 := 568;
	signal personagem_y: integer range 0 to 1024 := 704;
	signal quadrado1_x: integer range 0 to 1280 := 296;
	signal quadrado2_x: integer range 0 to 1280 := 568;
	signal quadrado3_x: integer range 0 to 1280 := 840;
	signal quadrado1_y: integer range -256 to 1920 := -256;
	signal quadrado2_y: integer range -256 to 1920 := 384;
	signal quadrado3_y: integer range -256 to 1920 := 1024;
	signal bateu: integer range 0 to 1 := 0;
	signal numero2_x: integer range 0 to 10 := 4;
	signal numero1_x: integer range 0 to 64 := 60;
	signal numero_y: integer range 0 to 10 := 4;
	signal quadrado1_a: integer range 0 to 2 := 0;
	signal quadrado2_a: integer range 0 to 2 := 1;
	signal quadrado3_a: integer range 0 to 2 := 2;
	signal quadrado1_b: integer range 0 to 1920 := 0;
	signal quadrado2_b: integer range 0 to 1920 := 640;
	signal quadrado3_b: integer range 0 to 1920 := 1280;
	signal score, auxscore, auxscore2: integer range 0 to 100 := 0;
	signal cores_personagem, cores1, cores2, cores3: integer range 0 to 7;
	signal grama_y, listra_y: integer range 0 to 255:= 0;
	signal desenha_personagem, desenha_quadrado1, desenha_quadrado2, desenha_grama, desenha_listra, desenha_quadrado3, desenha_numero, desenha_numero2: std_logic;

	begin

	-- Posição dos objetos --
	desenho_quadrado2(HPixel, VPixel, personagem_x, personagem_y, desenha_personagem, cores_personagem);
	desenho_quadrado(HPixel, VPixel, quadrado1_x, quadrado1_y, desenha_quadrado1, cores1);
	desenho_quadrado(HPixel, VPixel, quadrado2_x, quadrado2_y, desenha_quadrado2, cores2);
	desenho_quadrado(HPixel, VPixel, quadrado3_x, quadrado3_y, desenha_quadrado3, cores3);
	desenho_grama(HPixel, VPixel, grama_y, desenha_grama);
	desenho_listra(HPixel, VPixel, listra_y, desenha_listra);
	desenho_numero(HPixel, VPixel, numero2_x, numero_y, auxscore2, desenha_numero2);
	desenho_numero(HPixel, VPixel, numero1_x, numero_y, auxscore, desenha_numero);

	CLKM_M: altclk port map(clk_27,countclk);

	HCounter: process (countclk, reset)
	begin
		if reset = '1' then
			Hcount <= 0;
			VCount <= 0;
			vga_hsync <= '1';
			vga_vsync <= '1';
		elsif countclk'event and countclk = '1' then
			if Hcount < HTOTAL-1 then
				Hcount <= Hcount+1;
			else
				Hcount <= 0;
				if VCount < Vtotal-1 then
					VCount <= VCount+1;		
				else
					case estado_atual is
						when e0 =>
							-- Move a pista
							grama_y <= grama_y + 4;
							listra_y <= listra_y + 4;
							
							VCount <= 0;
							
							-- Tira os outros carros da tela
							quadrado1_b <= 0;
							quadrado1_y <= -256;
							quadrado2_b <= 0;
							quadrado2_y <= -256;
							quadrado3_b <= 0;
							quadrado3_y <= -256;
							
							-- Centraliza o personagem
							personagem_x <= 568;
							personagem_y <= 704;
							
							-- Zera o score
							score <= 0;
							auxscore <= 0;
							auxscore2 <= 0;
							
							if(botao(3) = '0')then
								estado_atual <= e1;
							end if;
						
						when e1 =>
							-- Atualiza personagem
							if(botao(0) = '0')then
								if(personagem_x /= 840)then
									personagem_x <= personagem_x + 4;
								end if;
							end if;
							if(botao(1) = '0')then
								if(personagem_x /= 296)then
									personagem_x <= personagem_x - 4;
								end if;	
							end if;
							
							-- Faz o primeiro carro aparecer
							quadrado1_b <= quadrado1_b + 4;
							quadrado1_y <= (quadrado1_b-256);
							
							-- Move a pista
							grama_y <= grama_y + 8;
							listra_y <= listra_y + 8;
							
							VCount <= 0;
							
							if(quadrado1_y = 384)then
								estado_atual <= e2;
							end if;
						
						when  e2 =>
							if(bateu = 1)then
								estado_atual <= e4;
							elsif(quadrado2_y = 384)then
								estado_atual <= e3;
							end if;
							
							-- Atualiza personagem
							if(botao(0) = '0')then
								if(personagem_x /= 840)then
									personagem_x <= personagem_x + 4;
								end if;
							end if;
							if(botao(1) = '0')then
								if(personagem_x /= 296)then
									personagem_x <= personagem_x - 4;
								end if;	
							end if;
							
							-- Faz o segundo carro aparecer
							quadrado1_b <= quadrado1_b + 4;
							quadrado2_b <= quadrado2_b + 4;
							quadrado1_y <= (quadrado1_b-256);
							quadrado2_y <= (quadrado2_b-256);
							
							-- Move a pista
							grama_y <= grama_y + 8;
							listra_y <= listra_y + 8;
							
							VCount <= 0;
							
						when e3=>
						if(bateu = 1)then
							estado_atual <= e4;
						else
							-- Atualiza personagem
							if(botao(0) = '0')then
								if(personagem_x /= 840)then
									personagem_x <= personagem_x + 4;
								end if;
							end if;
							if(botao(1) = '0')then
								if(personagem_x /= 296)then
									personagem_x <= personagem_x - 4;
								end if;	
							end if;
							
							-- Atualiza carro 1 (Vermelho)
							if(quadrado1_b = 0) then
								score <= score + 1;
								auxscore <= auxscore + 1;
								if(auxscore = 9)then
									auxscore <= 0;
									auxscore2 <= auxscore2 +1;
								end if;
								quadrado1_a <= quadrado1_a + 1;
								if(quadrado1_a >= 2)then
									quadrado1_a <= 0;
								end if;
								quadrado1_x <= (296 + (quadrado1_a*272));
							end if;
							
							-- Atualiza carro 2 (Verde)
							if(quadrado2_b = 0) then
								score <= score + 1;
								auxscore <= auxscore + 1;
								if(auxscore = 9)then
									auxscore <= 0;
									auxscore2 <= auxscore2 +1;
								end if;
								quadrado2_a <= quadrado2_a + 1;
								if(quadrado2_a >= 2)then
									quadrado2_a <= 0;
								end if;
								quadrado2_x <= (296 + (quadrado2_a*272));
							end if;
							
							-- Atualiza carro 3 (Azul)
							if(quadrado3_b = 0) then
								score <= score + 1;
								auxscore <= auxscore + 1;
								if(auxscore = 9)then
								auxscore <= 0;
								auxscore2 <= auxscore2 +1;
								end if;
								quadrado3_a <= quadrado3_a + 1;
								if(quadrado3_a >= 2)then
									quadrado3_a <= 0;
								end if;
								quadrado3_x <= (296 + (quadrado3_a*272));
							end if;
							
							-- Velocidade dos carros
							if(score < 5)then
								quadrado1_b <= quadrado1_b + 4;
								quadrado2_b <= quadrado2_b + 4;
								quadrado3_b <= quadrado3_b + 4;
							elsif(score = 5)then
								quadrado1_b <= quadrado1_b + 6;
								quadrado2_b <= quadrado2_b + 6;
								quadrado3_b <= quadrado3_b + 6;
							elsif(score < 15)then
								quadrado1_b <= quadrado1_b + 8;
								quadrado2_b <= quadrado2_b + 8;
								quadrado3_b <= quadrado3_b + 8;
							elsif(score = 15)then
								quadrado1_b <= quadrado1_b + 10;
								quadrado2_b <= quadrado2_b + 10;
								quadrado3_b <= quadrado3_b + 10;
							elsif(score < 50)then
								quadrado1_b <= quadrado1_b + 12;
								quadrado2_b <= quadrado2_b + 12;
								quadrado3_b <= quadrado3_b + 12;
							elsif(score = 50)then
								quadrado1_b <= quadrado1_b + 14;
								quadrado2_b <= quadrado2_b + 14;
								quadrado3_b <= quadrado3_b + 14;
							else
								quadrado1_b <= quadrado1_b + 16;
								quadrado2_b <= quadrado2_b + 16;
								quadrado3_b <= quadrado3_b + 16;
							end if;
						end if;
						
						-- Troca os carros de posição
						if(quadrado1_b >= 1920) then
							quadrado1_b <= 0;
							end if;
							
						if(quadrado2_b >= 1920) then
							quadrado2_b <= 0;
							end if;
							
						if(quadrado3_b >= 1920) then
							quadrado3_b <= 0;
							end if;
							
						quadrado1_y <= (quadrado1_b-256);
						quadrado2_y <= (quadrado2_b-256);
						quadrado3_y <= (quadrado3_b-256);
						
						--Velocidade da pista
						if(score <5)then
							grama_y <= grama_y + 8;
							listra_y <= listra_y + 8;
						elsif(score =5)then
							grama_y <= grama_y + 12;
							listra_y <= listra_y + 12;
						elsif(score < 15)then
							grama_y <= grama_y + 16;
							listra_y <= listra_y + 16;
						elsif(score =15)then
							grama_y <= grama_y + 20;
							listra_y <= listra_y + 20;
						elsif(score < 50)then
							grama_y <= grama_y + 24;
							listra_y <= listra_y + 24;
						elsif(score =50)then
							grama_y <= grama_y + 28;
							listra_y <= listra_y + 28;
						else
							grama_y <= grama_y + 32;
							listra_y <= listra_y + 32;
						end if;
							
						VCount <= 0;
						
						when e4 =>
						if(botao(2) = '0')then
							estado_atual <= e0;
						end if;
							
						VCount <=0;
						
					end case;				
				end if;
			end if;
			
			if (Hcount >= HSYNC + HBACK_PORCH) then
				Hpixel<=Hpixel+1;
			else
				Hpixel<=0;
			end if;
			
			if (VCount >= VSYNC + VBACK_PORCH) then
				VPixel <= VCount-(VSYNC+VBACK_PORCH);
			else
				Vpixel<=0;
			end if;
			
			if Hcount = HTOTAL - 1 then
				vga_hsync <= '1';
			elsif Hcount = HSYNC - 1 then
				vga_hsync <= '0';
			end if;
			
			if VCount = VTOTAL - 1 then
				vga_vsync <= '1';
			elsif VCount = VSYNC - 1 then
				vga_vsync <= '0';
			end if;
		end if;
	end process;

	VideoOut: process (countclk, reset)
	begin
		if reset = '1' then
			-- Reseta a tela, enviando branco para todo display
			VGA_R <= "1111111111";
			VGA_G <= "1111111111";
			VGA_B <= "1111111111";
		elsif botao(2) = '0' then
			-- Depois que bate o carro reseta
			bateu <=0;
		elsif countclk'event and countclk = '1' then
			if (Hcount >= HSYNC + HBACK_PORCH) and (Hcount < HSYNC + HBACK_PORCH + HACTIVE) and (VCount >= VSYNC + VBACK_PORCH) and (VCount < VSYNC + VBACK_PORCH + VACTIVE) then
				-- Testa se bateu
				if(desenha_personagem = '1' and (desenha_quadrado1 = '1' or desenha_quadrado2 = '1' or desenha_quadrado3 = '1'))then
					bateu <= 1;
				end if;
				
				--Desenha os objetos
				if(desenha_numero ='1')then
					VGA_R <= "1111111111";
					VGA_G <= "1111111111";
					VGA_B <= "0000000000";
				elsif(desenha_numero2 ='1')then
					VGA_R <= "1111111111";
					VGA_G <= "1111111111";
					VGA_B <= "0000000000";
				elsif (desenha_personagem = '1')then
					if(cores_personagem = 4)then
						VGA_R <= "1110110111";
						VGA_G <= "0110001011";
						VGA_B <= "0010000111";
					elsif(cores_personagem = 5)then
						VGA_R <= "0111011111";
						VGA_G <= "0111011111";
						VGA_B <= "0111011111";
					elsif(cores_personagem = 0)then
						VGA_R <= "0010100011";
						VGA_G <= "0010100011";
						VGA_B <= "0010100011";
					elsif(cores_personagem = 1)then
						VGA_R <= "1110101111";
						VGA_G <= "1010011011";
						VGA_B <= "0011111011";
					elsif(cores_personagem = 2)then
						VGA_R <= "1101101011";
						VGA_G <= "1110001111";
						VGA_B <= "1110101011";
					elsif(cores_personagem = 3)then
						VGA_R <= "1010001011";
						VGA_G <= "0001001011";
						VGA_B <= "0001100111";
					elsif(cores_personagem = 6)then
						VGA_R <= "1111111111";
						VGA_G <= "1111111111";
						VGA_B <= "1111111111";
					else
						VGA_R <= "1101111111";
						VGA_G <= "1101111111";
						VGA_B <= "1101111111";
					end if;
				elsif (desenha_quadrado1 = '1')then
					if(cores1 = 0)then
						VGA_R <= "0010100011";
						VGA_G <= "0010100011";
						VGA_B <= "0010100011";
					elsif(cores1 = 1)then
						VGA_R <= "1110101111";
						VGA_G <= "1010011011";
						VGA_B <= "0011111011";
					elsif(cores1 = 2)then
						VGA_R <= "1101101011";
						VGA_G <= "1110001111";
						VGA_B <= "1110101011";
					elsif(cores1 = 3)then
						VGA_R <= "1010001011";
						VGA_G <= "0001001011";
						VGA_B <= "0001100111";
					elsif(cores1 = 6)then
						VGA_R <= "1111111111";
						VGA_G <= "0010000011";
						VGA_B <= "0010000011";
					else
						VGA_R <= "1101111111";
						VGA_G <= "0000000000";
						VGA_B <= "0000000000";
					end if;
				elsif (desenha_quadrado2 = '1')then
					if(cores2 = 0)then
						VGA_R <= "0010100011";
						VGA_G <= "0010100011";
						VGA_B <= "0010100011";
					elsif(cores2 = 1)then
						VGA_R <= "1110101111";
						VGA_G <= "1010011011";
						VGA_B <= "0011111011";
					elsif(cores2 = 2)then
						VGA_R <= "1101101011";
						VGA_G <= "1110001111";
						VGA_B <= "1110101011";
					elsif(cores2 = 3)then
						VGA_R <= "1010001011";
						VGA_G <= "0001001011";
						VGA_B <= "0001100111";
					elsif(cores2 = 6)then
						VGA_R <= "1010011011";
						VGA_G <= "1100111111";
						VGA_B <= "0011011111";
					else
						VGA_R <= "1000011011";
						VGA_G <= "1010111111";
						VGA_B <= "0001011111";
					end if;
				elsif (desenha_quadrado3 = '1')then
					if(cores3 = 0)then
						VGA_R <= "0010100011";
						VGA_G <= "0010100011";
						VGA_B <= "0010100011";
					elsif(cores3 = 1)then
						VGA_R <= "1110101111";
						VGA_G <= "1010011011";
						VGA_B <= "0011111011";
					elsif(cores3 = 2)then
						VGA_R <= "1101101011";
						VGA_G <= "1110001111";
						VGA_B <= "1110101011";
					elsif(cores3 = 3)then
						VGA_R <= "1010001011";
						VGA_G <= "0001001011";
						VGA_B <= "0001100111";
					elsif(cores3 = 6)then
						VGA_R <= "0000000000";
						VGA_G <= "1101001111";
						VGA_B <= "1110000011";
					else
						VGA_R <= "0000000000";
						VGA_G <= "1011001111";
						VGA_B <= "1100000011";
					end if;
				elsif (desenha_grama = '1') then --desenha grama escura
					VGA_R <= "0001101011";
					VGA_G <= "1001110011";
					VGA_B <= "0011010011";
				elsif (desenha_listra = '1') then --desenha listras tela
					VGA_R <= "1011010011";
					VGA_G <= "1011010011";
					VGA_B <= "1011010011";
				elsif (((HPixel >= 224) and (HPixel < 240))or((HPixel >= 1040) and (HPixel < 1056)))then --listra amarela
					VGA_R <= "1111111111";
					VGA_G <= "1101110111";
					VGA_B <= "0000000000";
				elsif (((HPixel >= 160) and (HPixel < 200))or((HPixel >= 1080) and (HPixel < 1120)))then --listra marrom
					VGA_R <= "1001101011";
					VGA_G <= "0110001111";
					VGA_B <= "0100001011";
				elsif ((HPixel >= 200) and (HPixel < 1080))then --estrada
					VGA_R <= "0011110011";
					VGA_G <= "0011000011";
					VGA_B <= "0011011011";
				else 
					-- Desenha o fundo verde claro
					VGA_R <= "0001101011";
					VGA_G <= "1100001111";
					VGA_B <= "0011010011";
				end if;		
				-----------------------
				--end if;
			else
				VGA_R <= "0000000000";
				VGA_G <= "0000000000";
				VGA_B <= "0000000000";
			end if;
		end if;
	end process VideoOut;

	VGA_CLK <= countclk;
	VGA_HS <= not vga_hsync;
	VGA_VS <= vga_vsync;
	VGA_SYNC <= '0';
	VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;