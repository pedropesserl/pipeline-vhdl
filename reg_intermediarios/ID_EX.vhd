library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ID_EX is port(
	-- inputs
	RegA, DataB, ID_NewPC, extended_imm				: in std_logic_vector(15 downto 0);
	MemRead, MemWrite, MemtoReg, RegWrite,
	Branch, ALUSrc, RegDest, clk 					: in std_logic;
	ID_Rs, ID_Rt, ID_Rd						: in std_logic_vector(1 downto 0);
	Func 								: in std_logic_vector(2 downto 0);
	Shamt 								: in std_logic_vector(3 downto 0);

	-- outputs
	EX_RegA, EX_DataB, EX_NewPC, EX_extended_imm			: out std_logic_vector(15 downto 0);
	EX_MemRead, EX_MemWrite, EX_MemtoReg, EX_RegWrite,
	EX_Branch, EX_ALUSrc, EX_RegDest				: out std_logic;
	EX_Rs, EX_Rt, EX_Rd						: out std_logic_vector(1 downto 0);
	EX_Func								: out std_logic_vector(2 downto 0);
	EX_Shamt 							: out std_logic_vector(3 downto 0)
);
end ID_EX;

architecture Behavioral of ID_EX is
begin 
	process(clk) is 
	begin
		if rising_edge(clk) then
			EX_RegA <= RegA;
			EX_DataB <= DataB;
			EX_NewPC <= ID_NewPC;
			EX_extended_imm <= extended_imm;
			EX_MemRead <= MemRead;
			EX_MemWrite <= MemWrite;
			EX_MemtoReg <= MemtoReg;
			EX_RegWrite <= RegWrite;
			EX_Branch <= Branch;
			EX_ALUSrc <= ALUSrc;
			EX_RegDest <= RegDest;
			EX_Rs <= ID_Rs;
			EX_Rt <= ID_Rt;
			EX_Rd <= ID_Rd;
			EX_Func <= Func;
			EX_Shamt <= Shamt;
		end if;
	end process;
end Behavioral; 