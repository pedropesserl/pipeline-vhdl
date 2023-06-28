library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity HazardDetectionUnit is port(
	EX_MemRead, zero					            : in std_logic;
	EX_Rd								            : in std_logic_vector(1 downto 0);
	ID_Instruction						            : in std_logic_vector(15 downto 0);
	PCWrite, IF_ID_Write, Flush		                : out std_logic
);
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is
    constant TIPO_R : std_logic_vector(2 downto 0) := "000";
    constant TIPO_BEQ : std_logic_vector(2 downto 0) := "100";
    signal opcode : std_logic_vector(2 downto 0);
    signal rs, rt : std_logic_vector(1 downto 0);
begin
    opcode <= ID_Instruction(15 downto 13);
    rs <= ID_Instruction(12 downto 11);
    rt <= ID_Instruction(10 downto 9);

	process (ID_Instruction, EX_MemRead, EX_Rd, rs, rt, opcode, zero)
	begin 

        -- Dependencia de lw, se tiver pegando dado de uma lw que esta no EX
        -- Exemplo
        -- lw $2, $3[4]
        -- sw $2, $2[5]
		if((EX_MemRead = '1') and 
            ((rs = EX_Rd) or (rt = EX_Rd)) and
            (EX_Rd /= "0")
		) then
            Flush <=        '1';
			PCWrite <=      '0';
			IF_ID_Write <=  '0';
        -- dependencia de beq, se tiver pegando coisa e der o salto
		elsif((opcode = TIPO_BEQ) and
            (zero = '1')
        ) then
            Flush <=        '1';
            PCWrite <=      '1';
            IF_ID_Write <=  '0';
        -- caso tudo certo
        else
            Flush <=        '0';
            PCWrite <=      '1';
            IF_ID_Write <=  '1';
		end if;
	end process;
end Behavioral;
