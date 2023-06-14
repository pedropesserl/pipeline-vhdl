library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ula is port(
	data_a, data_b			: in std_logic_vector(15 downto 0);
	ALUControlOut			: in std_logic_vector(1 downto 0);
	shamt				: in std_logic_vector(3 downto 0);
	ALUOut				: out std_logic_vector(15 downto 0);
	zero				: out std_logic
);
end ula;

architecture Behavioral of ula is
begin
	case ALUControlOut is
		when "000" => ALUOut <= data_a + data_b;
		when "001" => ALUOut <= data_a - data_b;
		when "010" => ALUOut <= data_a and data_b;
		when "011" => ALUOut <= data_a or data_b;
		when "100" => ALUOut <= data_a nor data_b;
		when "101" => ALUOut <= data_a < data_b;
		when "110" => ALUOut <= data_a sll to_integer(unsigned(shamt));
		when "111" => ALUOut <= data_a srl to_integer(unsigned(shamt));
		when others => ALUOut <= (others => '0');
	end case;

	zero <= '1' when ALUOut = "0" else 
		'0';
end Behavioral;
