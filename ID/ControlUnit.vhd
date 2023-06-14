library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ControlUnit is port(
	OPCode 				: in std_logic_vector(2 downto 0);
	memRead, memWrite, memtoReg,
	RegWrite, RegDest, Branch 	: out std_logic;
	ALUOp 				: out std_logic_vector(2 downto 0)
);
end ControlUnit;

architecture Behavioral of ControlUnit is
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

		when "001" =>		--addi
			memRead <= '0';
			memWrite <= '0';
			memtoReg <= '0';
			RegWrite <= '1';
			RegDest <= '0';		--rt
			Branch <= '0';
			ALUOp <= "000";

		when "010" => 		--andi
			memRead <= '0';
			memWrite <= '0';
			memtoReg <= '0';
			RegWrite <= '1';
			RegDest <= '0';		--rt
			Branch <= '0';
			ALUOp <= "010";

		when "011" => 		--ori
			memRead <= '0';
			memWrite <= '0';
			memtoReg <= '0';
			RegWrite <= '1';
			RegDest <= '0';		--rt
			Branch <= '0';
			ALUOp <= "011";

		when "100" => 		--beq
			memRead <= '0';
			memWrite <= '0';
			memtoReg <= '0';
			RegWrite <= '0';
			RegDest <= '0';		--rt
			Branch <= '1';
			ALUOp <= "001";

		when "101" => 		--lw
			memRead <= '1';
			memWrite <= '0';
			memtoReg <= '1';
			RegWrite <= '1';
			RegDest <= '0';		--rt
			Branch <= '0';
			ALUOp <= "000";

		when "110" => 		--sw
			memRead <= '0';
			memWrite <= '1';
			memtoReg <= '0';
			RegWrite <= '0';
			RegDest <= '0';		--rt
			Branch <= '0';
			ALUOp <= "000";

		--jump???
end Behavioral;