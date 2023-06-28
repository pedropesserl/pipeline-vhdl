library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_mem is port(
	ALUOut, WriteData 			: in std_logic_vector(15 downto 0);
	clk, MemWrite, MemRead			: in std_logic;
	ReadData 					: out std_logic_vector(15 downto 0)
); 
end data_mem;

architecture Behavioral of data_mem is
	type mem_type is array (0 to 255) of std_logic_vector(15 downto 0);	--MEM_ALUOut is the address

	signal memory 				: mem_type := (others => (others => '0'));	--initialize memory
    signal addr_intern : std_logic_vector(7 downto 0) := (others => '0');
begin

    addr_intern <= ALUOut(7 downto 0);
	process(clk, MemWrite, WriteData, ALUOut)	--writes only on rising edge of clock
	begin 
		if ((rising_edge(clk)) and (MemWrite = '1')) then
			memory(to_integer(unsigned(addr_intern))) <= WriteData;
		end if;
	end process;

	ReadData <= memory(to_integer(unsigned(addr_intern))) when MemRead = '1' else 
		(others => 'Z'); 

end Behavioral;
