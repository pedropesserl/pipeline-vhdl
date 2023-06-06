library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ALUControl is port(
	ALUop 				: in std_logic_vector(1 downto 0);
	func 				: in std_logic_vector(3 downto 0);
	ALUControlOut		 	: out std_logic_vector(3 downto 0)
);
end ALUControl;

architecture Behavioral of ALUControl is
begin 
	with ALUop select ALUControlOut <= 
		"0000" when "00",				--soma
		"0001" when "01",				--subtracao
		??? when "10",					--set less than
		func when others;				--instrucao tipo R
end Behavioral;
