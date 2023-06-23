library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity EX_MEM is port(
	-- new info
	BeqAddress, ALUOut 					: in std_logic_vector(15 downto 0);
	Zero, clk						: in std_logic;	
	RegtoW 							: in std_logic_vector(1 downto 0);

	-- info from ID/EX
	EX_MemRead, EX_MemWrite, EX_MemtoReg,
	EX_RegWrite, EX_Branch					: in std_logic;
	EX_WriteData 						: in std_logic_vector(15 downto 0);

	-- output
	MEM_BeqAddress, MEM_ALUOut, MEM_WriteData		: out std_logic_vector(15 downto 0);
	MEM_Zero 						: out std_logic;
	MEM_RegtoW 						: out std_logic_vector(1 downto 0);
	MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, 
	MEM_RegWrite, MEM_Branch 				: out std_logic
);
end EX_MEM;

architecture Behavioral of EX_MEM is 
begin 
	process(clk) is
	begin
		if rising_edge(clk) then 
			MEM_BeqAddress <= BeqAddress;
			MEM_ALUOut <= ALUOut;
			MEM_Zero <= Zero;
			MEM_RegtoW <= RegtoW;
			MEM_MemRead <= EX_MemRead;
			MEM_MemWrite <= EX_MemWrite;
			MEM_MemtoReg <= EX_MemtoReg;
			MEM_RegWrite <= EX_RegWrite;
			MEM_Branch <= EX_Branch;
			MEM_WriteData <= EX_WriteData;
		end if;
	end process;
end Behavioral;