library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity HazardDetectionUnit is port(
	EX_MemRead				:in std_logic;
	EX_Rd					:in std_logic_vector(1 downto 0);
	ID_Instruction				: in std_logic_vector(15 downto 0);
	PCWrite, IF_ID_Write, Stall_Mux		: out std_logic
);
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is
begin
	process (ID_Instruction, EX_MemRead, EX_Rd)
	begin 

		if((EX_MemRead = '1') and 
			(ID_Instruction(15 downto 13) = "0") and
			((ID_Instruction(12 downto 11) = EX_Rd) or 
			(ID_Instruction(10 downto 9) = EX_Rd))
		) then
			Stall_Mux <= '1';
			PCWrite <= '0';
			IF_ID_Write <= '0';
		elsif ((EX_MemRead = '1') and (ID_Instruction(15 downto 13) = "1") and (ID_Instruction(12 downto 11) = EX_Rd)) then
			Stall_Mux <= '1';
			PCWrite <= '0';
			IF_ID_Write <= '0';
		end if;

	end process;
end Behavioral;
