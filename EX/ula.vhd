library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ula is port(
	dado_a, dado_b			: in std_logic_vector(15 downto 0);
	ALUControlOut			: in std_logic_vector(1 downto 0);
	shamt				: in std_logic_vector(3 downto 0);
	ALUOut				: out std_logic_vector(15 downto 0);
	zero				: out std_logic
);

architecture Behavioral of ula is
begin

	--ver clock

	--colocar os ifs para cada tipo de operacao

	zero <= '1' when ALUOut = "0" else 
		'0';
end Behavioral;