library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ALUControl is port(
    EX_ALUOp, EX_Func         : in std_logic_vector(2 downto 0);
    ALUControlOut             : out std_logic_vector(2 downto 0)
);
end ALUControl;

architecture Behavioral of ALUControl is
begin 
    with EX_ALUOp select
        ALUControlOut <= 
            "000"   when "000",                --soma
            "001"   when "001",                --subtracao
            "010"   when "010",                 --and
            "011"   when "011",                --or
            EX_Func when others;                --instrucao tipo R
end Behavioral;
