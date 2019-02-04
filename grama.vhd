library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package grama is
	procedure desenho_grama(
		signal x_atual, y_atual, y_pos: in integer;
		signal desenhar: out std_logic
	);
end grama;

package body grama is
	procedure desenho_grama(
		signal x_atual, y_atual, y_pos: in integer;
		signal desenhar: out std_logic
	) is

begin
	if(((x_atual >= 0 and x_atual <160) or (x_atual >= 1120 and x_atual <1280)) and y_atual >= (y_pos - 256) and y_atual < (y_pos - 128)) then
		desenhar <= '1';
	elsif(((x_atual >= 0 and x_atual <160) or (x_atual >= 1120 and x_atual <1280)) and y_atual >= y_pos and y_atual < (y_pos + 128)) then
		desenhar <= '1';
	elsif(((x_atual >= 0 and x_atual <160) or (x_atual >= 1120 and x_atual <1280)) and y_atual >= (y_pos + 256) and y_atual < (y_pos + 384)) then
		desenhar <= '1';
	elsif(((x_atual >= 0 and x_atual <160) or (x_atual >= 1120 and x_atual <1280)) and y_atual >= (y_pos + 512) and y_atual < (y_pos + 640)) then
		desenhar <= '1';
	elsif(((x_atual >= 0 and x_atual <160) or (x_atual >= 1120 and x_atual <1280)) and y_atual >= (y_pos + 768) and y_atual < (y_pos + 896)) then
		desenhar <= '1';
	else
		desenhar <= '0';
	end if;
	end desenho_grama;
end grama;	
	