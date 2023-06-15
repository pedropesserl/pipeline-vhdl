library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is port(
	MEM_ALUOut, MEM_WriteData 			: in std_logic_vector(15 downto 0);
	clk, MEM_MemWrite, MEM_MemRead			: in std_logic;
	ReadData 					: out std_logic_vector(15 downto 0)
); 
end data_mem;

architecture Behavioral of data_mem is
	type mem_type is array (0 to 65536) of std_logic_vector(15 downto 0);	--MEM_ALUOut is the address

	signal memory 				: mem_type := (others => (others => '0'));	--initialize memory
begin

	process(clk, MEM_MemWrite, MEM_WriteData, MEM_ALUOut)	--writes only on rising edge of clock
	begin 
		if (rising_edge(clk)) and  (MEM_MemWrite = '1') then
			memory(to_integer(unsigned(MEM_ALUOut))) <= MEM_WriteData;
		end if;
	end process;

	ReadData <= memory(to_integer(unsigned(MEM_ALUOut))) when MEM_MemRead = '1' else 
		(others => '0'); 

end Behavioral;
