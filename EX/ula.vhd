library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity ula is port(
    Data_a, Data_b      : in std_logic_vector(15 downto 0);
    ALUControlOut       : in std_logic_vector(2 downto 0);
    EX_Shamt            : in std_logic_vector(3 downto 0);
    ALUOut              : out std_logic_vector(15 downto 0);
    Zero                : out std_logic
);
end ula;

architecture Behavioral of ula is
    signal iALUOut      : std_logic_vector(15 downto 0);
begin
    ALUOut <= iALUOut;
    with ALUControlOut select
        iALUOut <= Data_a + Data_b           when "000",
                   Data_a - Data_b           when "001",
                   Data_a and Data_b         when "010",
                   Data_a or Data_b          when "011",
                   Data_a nor Data_b         when "100",
                   shl(Data_a, EX_Shamt)     when "110",
                   shr(Data_a, EX_Shamt)     when "111",
                   (others => '0')           when others;
    Zero <= '1' when iALUOut = "0" else 
            '0';
end Behavioral;
