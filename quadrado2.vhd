library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package quadrado2 is
	procedure desenho_quadrado2(
		signal x_atual, y_atual, x_pos, y_pos: in integer;
		signal desenhar: out std_logic;
		signal cores: out integer range 0 to 7
	);
end quadrado2;

package body quadrado2 is
	procedure desenho_quadrado2(
		signal x_atual, y_atual, x_pos, y_pos: in integer;
		signal desenhar: out std_logic;
		signal cores: out integer range 0 to 7
	) is

begin
	if(x_atual >= x_pos and x_atual < (x_pos + 144) and y_atual >= y_pos and y_atual < (y_pos + 256)) then
		desenhar <= '1';
	else
		desenhar <= '0';
	end if;		
	
	
	if(x_atual >= x_pos + 52 and x_atual < (x_pos + 60) and y_atual >= y_pos  and y_atual < (y_pos + 256))then
		cores <= 4;
		
	elsif(x_atual >= x_pos + 84 and x_atual < (x_pos + 92) and y_atual >= y_pos  and y_atual < (y_pos + 256))then
		cores <= 4;
		
		
		---------
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +12 and y_atual < (y_pos + 20))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +44 and y_atual < (y_pos + 52))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +76 and y_atual < (y_pos + 84))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +108 and y_atual < (y_pos + 116))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +140 and y_atual < (y_pos + 148))then
		cores <= 5;
	
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +172 and y_atual < (y_pos + 180))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +204 and y_atual < (y_pos + 212))then
		cores <= 5;
		
	elsif(x_atual >= x_pos + 60 and x_atual < (x_pos + 84) and y_atual >= y_pos +236 and y_atual < (y_pos + 244))then
		cores <= 5;
	
	
	
	elsif(x_atual >= (x_pos + 24) and x_atual < (x_pos + 120) and y_atual >= (y_pos + 80) and y_atual < (y_pos + 84))then
		cores <= 0;
		
	elsif(x_atual >= x_pos + 8 and x_atual < (x_pos + 136) and y_atual >= y_pos + 84 and y_atual < (y_pos + 88))then
		cores <= 0;
	elsif(x_atual >= x_pos + 12 and x_atual < (x_pos + 132) and y_atual >= y_pos + 88 and y_atual < (y_pos + 92))then
		cores <= 0;
	elsif(x_atual >= x_pos + 16 and x_atual < (x_pos + 128) and y_atual >= y_pos + 92 and y_atual < (y_pos + 96))then
		cores <= 0;
	elsif(x_atual >= x_pos + 20 and x_atual < (x_pos + 124) and y_atual >= y_pos + 96 and y_atual < (y_pos + 100))then
		cores <= 0;
	elsif(x_atual >= x_pos + 24 and x_atual < (x_pos + 120) and y_atual >= y_pos + 100 and y_atual < (y_pos + 104))then
		cores <= 0;
		
	elsif(x_atual >= x_pos + 12 and x_atual < (x_pos + 16) and y_atual >= y_pos + 100 and y_atual < (y_pos + 160))then
		cores <= 0;
	elsif(x_atual >= x_pos + 16 and x_atual < (x_pos + 20) and y_atual >= y_pos + 104 and y_atual < (y_pos + 160))then
		cores <= 0;
	elsif(x_atual >= x_pos + 20 and x_atual < (x_pos + 24) and y_atual >= y_pos + 108 and y_atual < (y_pos + 160))then
		cores <= 0;
		
	elsif(x_atual >= x_pos + 128 and x_atual < (x_pos + 132) and y_atual >= y_pos + 100 and y_atual < (y_pos + 160))then
		cores <= 0;
	elsif(x_atual >= x_pos + 124 and x_atual < (x_pos + 128) and y_atual >= y_pos + 104 and y_atual < (y_pos + 160))then
		cores <= 0;
	elsif(x_atual >= x_pos + 120 and x_atual < (x_pos + 124) and y_atual >= y_pos + 108 and y_atual < (y_pos + 160))then
		cores <= 0;
		
	-----------------------
	elsif(x_atual >= x_pos + 12 and x_atual < (x_pos + 16) and y_atual >= y_pos + 168 and y_atual < (y_pos + 228))then
		cores <= 0;
	elsif(x_atual >= x_pos + 16 and x_atual < (x_pos + 20) and y_atual >= y_pos + 168 and y_atual < (y_pos + 224))then
		cores <= 0;
	elsif(x_atual >= x_pos + 20 and x_atual < (x_pos + 24) and y_atual >= y_pos + 168 and y_atual < (y_pos + 220))then
		cores <= 0;
		
	elsif(x_atual >= x_pos + 128 and x_atual < (x_pos + 132) and y_atual >= y_pos + 168 and y_atual < (y_pos + 228))then
		cores <= 0;
	elsif(x_atual >= x_pos + 124 and x_atual < (x_pos + 128) and y_atual >= y_pos + 168 and y_atual < (y_pos + 224))then
		cores <= 0;
	elsif(x_atual >= x_pos + 120 and x_atual < (x_pos + 124) and y_atual >= y_pos + 168 and y_atual < (y_pos + 220))then
		cores <= 0;
		
	------
	elsif(x_atual >= x_pos + 16 and x_atual < (x_pos + 128) and y_atual >= y_pos + 236 and y_atual < (y_pos + 240))then
		cores <= 0;
	elsif(x_atual >= x_pos + 20 and x_atual < (x_pos + 124) and y_atual >= y_pos + 232 and y_atual < (y_pos + 236))then
		cores <= 0;
	elsif(x_atual >= x_pos + 24 and x_atual < (x_pos + 120) and y_atual >= y_pos + 228 and y_atual < (y_pos + 232))then
		cores <= 0;
	
		
	
	elsif(x_atual >= x_pos + 132 and x_atual < (x_pos + 140) and y_atual >= y_pos +4 and y_atual < (y_pos + 8))then
		cores <= 1;
		
	elsif(x_atual >= x_pos + 4 and x_atual < (x_pos + 12) and y_atual >= y_pos +4 and y_atual < (y_pos + 8))then
		cores <= 1;
		
	elsif(x_atual >= x_pos + 116 and x_atual < (x_pos + 132) and y_atual >= y_pos +4 and y_atual < (y_pos + 8))then
		cores <= 2;
	
	elsif(x_atual >= x_pos + 12 and x_atual < (x_pos + 28) and y_atual >= y_pos +4 and y_atual < (y_pos + 8))then
		cores <= 2;
		
		
	elsif(x_atual >= x_pos + 124 and x_atual < (x_pos + 140) and y_atual >= y_pos +248 and y_atual < (y_pos + 252))then
		cores <= 3;
		
	elsif(x_atual >= x_pos + 4 and x_atual < (x_pos + 18) and y_atual >= y_pos +248 and y_atual < (y_pos + 252))then
		cores <= 3;
		
	
		
	elsif(x_atual >= x_pos + 4 and x_atual < (x_pos + 140) and y_atual >= y_pos +4 and y_atual < (y_pos + 252))then
		cores <= 6;
	
	 
	 else
	 cores <= 7;
	 end if;
	 
	end desenho_quadrado2;
end quadrado2;	
	
	