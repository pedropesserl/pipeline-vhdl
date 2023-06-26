library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ControlUnit is port(
	OPCode				: in std_logic_vector(2 downto 0);
	MemRead, MemWrite, MemtoReg,
	RegWrite, RegDest, Branch, ALUSrc, DisplayEnable	: out std_logic;
	ALUOp 				: out std_logic_vector(2 downto 0)
);
end ControlUnit;

architecture Behavioral of ControlUnit is
begin 
	process(OPCode)
	begin 
		case OPCode is 
			when "000" => 		-- R-type
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '1';
				RegDest <= '1';		--rd
				Branch <= '0';
				ALUOp <= "100";
				ALUSrc <= '0';
				DisplayEnable <= '0';

			when "001" =>		--addi
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '1';
				RegDest <= '0';		--rt
				Branch <= '0';
				ALUOp <= "000";
				ALUSrc <= '1';
				DisplayEnable <= '0';

			when "010" => 		--andi
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '1';
				RegDest <= '0';		--rt
				Branch <= '0';
				ALUOp <= "010";
				ALUSrc <= '1';
				DisplayEnable <= '0';
				
			when "011" => 		--ori
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '1';
				RegDest <= '0';		--rt
				Branch <= '0';
				ALUOp <= "011";
				ALUSrc <= '1';
				DisplayEnable <= '0';
				
			when "100" => 		--beq
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '0';
				RegDest <= '0';		--rt
				Branch <= '1';
				ALUOp <= "001";
				ALUSrc <= '1';
				DisplayEnable <= '0';
				
			when "101" => 		--lw
				memRead <= '1';
				memWrite <= '0';
				memtoReg <= '1';
				RegWrite <= '1';
				RegDest <= '0';		--rt
				Branch <= '0';
				ALUOp <= "000";
				ALUSrc <= '1';
				DisplayEnable <= '0';
				
			when "110" => 		--sw
				memRead <= '0';
				memWrite <= '1';
				memtoReg <= '0';
				RegWrite <= '0';
				RegDest <= '0';		--rt
				Branch <= '0';
				ALUOp <= "000";
				ALUSrc <= '1';
				DisplayEnable <= '0';
				
			when "110" => 		--sw
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '0';
				RegDest <= '0';		--dsp
				Branch <= '0';
				ALUOp <= "000";
				ALUSrc <= '0';
				DisplayEnable <= '1';
				
			when others =>
				memRead <= '0';
				memWrite <= '0';
				memtoReg <= '0';
				RegWrite <= '0';
				RegDest <= '0';		
				Branch <= '0';
				ALUOp <= "000";
				ALUSrc <= '0';
				DisplayEnable <= '0';
				end case;
	end process;
end Behavioral;