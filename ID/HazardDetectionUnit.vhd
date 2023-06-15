library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity HazardDetectionUnit is port(
	ID_EX_MemRead				:in std_logic;
	ID_EX_RD				:in std_logic_vector(1 downto 0);
	Instruction				: in std_logic_vector(15 downto 0);
	PCWrite, IF_ID_Write, Stall_Mux		: out std_logic
);

--stall se: 
	--anterior for lw e a atual for do tipo R, I e usar nos rs/rt o rd do lw anterior

architecture Behavioral of HazardDetectionUnit is
begin
	if((ID_EX_MemRead = '1') and (Instruction[15 downto 13] = "0") and ((Instruction[12 downto 11] = ID_EX_RD) or (Instruction[10 downto 9] = ID_EX_RD))) then
		Stall_Mux <= '1';
		PCWrite <= '0';
		IF_ID_Write <= '0';
	elsif ((ID_EX_MemRead = '1') and (Instruction[15 downto 13] = "1") and (Instruction[12 downto 11] = ID_EX_RD)) then
		Stall_Mux <= '1';
		PCWrite <= '0';
		IF_ID_Write <= '0';
	end if;
end Behavioral;
