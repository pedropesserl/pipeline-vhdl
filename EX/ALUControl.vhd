library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ALUControl is port(
	ALUop 				: in std_logic_vector(2 downto 0);
	func 				: in std_logic_vector(2 downto 0);
	ALUControlOut		 	: out std_logic_vector(3 downto 0)
);
end ALUControl;

architecture Behavioral of ALUControl is
begin 
	with ALUop select ALUControlOut <= 
		"000" when "000",				--soma
		"001" when "001",				--subtracao
		"010" when "010" 				--add
		"011" when "011",				--or
		func when others;				--instrucao tipo R
end Behavioral;