library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ula is port(
	Data_a, Data_b			: in std_logic_vector(15 downto 0);
	ALUControlOut			: in std_logic_vector(1 downto 0);
	EX_Shamt			: in std_logic_vector(3 downto 0);
	ALUOut				: out std_logic_vector(15 downto 0);
	Zero				: out std_logic
);
end ula;

architecture Behavioral of ula is
begin
	case ALUControlOut is
		when "000" => ALUOut <= Data_a + Data_b;
		when "001" => ALUOut <= Data_a - Data_b;
		when "010" => ALUOut <= Data_a and Data_b;
		when "011" => ALUOut <= Data_a or Data_b;
		when "100" => ALUOut <= Data_a nor Data_b;
		when "101" => ALUOut <= Data_a < Data_b;
		when "110" => ALUOut <= Data_a sll to_integer(unsigned(EX_Shamt));
		when "111" => ALUOut <= Data_a srl to_integer(unsigned(EX_Shamt));
		when others => ALUOut <= (others => '0');
	end case;

	Zero <= '1' when ALUOut = "0" else 
		'0';
end Behavioral;
