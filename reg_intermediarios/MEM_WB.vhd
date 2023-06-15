library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity MEM_WB is port(
	-- info from EX/MEM
	MEM_RegWrite, MEM_MemtoReg, clk		: in std_logic;
	MEM_ALUOut 				: in std_logic_vector(15 downto 0);
	MEM_RegtoW				: in std_logic_vector(1 downto 0);

	-- new info
	ReadData 				: in std_logic_vector(15 downto 0);

	-- outputs
	WB_RegWrite, WB_MemtoReg		: out std_logic;
	WB_ALUOut, WB_ReadData 			: out std_logic_vector(15 downto 0);
	WB_RegtoW				: out std_logic_vector(1 downto 0)
);
end MEM_WB;

architecture Behavioral of MEM_WB is
begin
	process(clk)
		if rising_edge(clk)
			WB_RegWrite <= MEM_RegWrite;
			WB_MemtoReg <= MEM_MemtoReg;
			WB_ALUOut <= MEM_ALUOut;
			WB_ReadData <= ReadData;
			WB_RegtoW <= MEM_RegtoW;
		end if;
	end process;
end Behavioral;