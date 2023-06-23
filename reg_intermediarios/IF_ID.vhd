library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID is port(
	--inputs
	clk 				: in std_logic;
	NewPC, Instruction		: in std_logic_vector(15 downto 0);

	--outputs
	ID_NewPC, ID_Instruction	: out std_logic_vector(15 downto 0)
); 
end IF_ID;

architecture Behavioral of IF_ID is
begin 

	process(clk)
	begin
		if(rising_edge(clk)) then
			ID_NewPC <= NewPC;
			ID_Instruction <= Instruction;
		end if;
	end process;

end Behavioral;