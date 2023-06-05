library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ALUControl is port(
	ALUop 				: in std_logic_vector(1 downto 0);
	func 				: in std_logic_vector(3 downto 0);
	ALUControlOut		 	: out std_logic_vector(3 downto 0)
);

architecture Behavioral of ALUControl is
begin 
	if (ALUop = "00") then
		ALUControlOut <= "0000"; 	--soma
	elsif (ALUop = "01") then
		ALUControlOut <= "0001"; 	--subtracao
	elsif (ALUop = "10") then
		ALUControlOut <= ???; 		--set less than
	else 
		ALUControlOut <= func; 		--instrucao tipo R
	end if;

end Behavioral;
