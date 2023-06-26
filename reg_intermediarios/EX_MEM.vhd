library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;


entity EX_MEM is
type EX_MEM_T is record 
    BeqAddress, ALUOut, WriteData := std_logic_vector(15 downto 0);
    Zero := std_logic;	
    RegtoW := in std_logic_vector(1 downto 0);
    MemRead, MemWrite, MemtoReg,
    RegWrite, Branch := std_logic;
end record EXE_MEM_T;

port(
    clk     : in std_logic;
    Reg_in  : in EX_MEM_T;
    Reg_out : out EX_MEM_T
);

end EX_MEM;

architecture Behavioral of EX_MEM is 
    signal Curr_data := EXE_MEM_T;
begin 
	process(clk) is
	begin
		if rising_edge(clk) then 
            Curr_data <= Reg_in;
		end if;
	end process;

    Reg_out <= Curr_data;
end Behavioral;
