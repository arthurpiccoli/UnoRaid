library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

package listra is
	procedure desenho_listra(
		signal x_atual, y_atual, y_pos: in integer;
		signal desenhar: out std_logic
	);
end listra;

package body listra is
	procedure desenho_listra(
		signal x_atual, y_atual, y_pos: in integer;
		signal desenhar: out std_logic
	) is

begin
	if(((x_atual >= 496 and x_atual <512) or (x_atual >= 768 and x_atual < 784)) and y_atual >= (y_pos - 256) and y_atual < (y_pos - 128)) then
		desenhar <= '1';
	elsif(((x_atual >= 496 and x_atual <512) or (x_atual >= 768 and x_atual < 784)) and y_atual >= y_pos and y_atual < (y_pos + 128)) then
		desenhar <= '1';
	elsif(((x_atual >= 496 and x_atual <512) or (x_atual >= 768 and x_atual < 784)) and y_atual >= (y_pos + 256) and y_atual < (y_pos + 384)) then
		desenhar <= '1';
	elsif(((x_atual >= 496 and x_atual <512) or (x_atual >= 768 and x_atual < 784)) and y_atual >= (y_pos + 512) and y_atual < (y_pos + 640)) then
		desenhar <= '1';
	elsif(((x_atual >= 496 and x_atual <512) or (x_atual >= 768 and x_atual < 784)) and y_atual >= (y_pos + 768) and y_atual < (y_pos + 896)) then
		desenhar <= '1';
	else
		desenhar <= '0';
	end if;
	end desenho_listra;
end listra;	
	