library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterBank is port(
    RFonteA, RFonteB, RDest: in std_logic_vector(1 downto 0);
    Data                   : in std_logic_vector(15 downto 0);
    RegWrite, clk          : in std_logic;
    DataA, DataB           : out std_logic_vector(15 downto 0)
);
end RegisterBank;

architecture Behavioral of RegisterBank is
    type Regs_t is array (0 to 3) of std_logic_vector(15 downto 0);
    signal Regs: Regs_t := (others => (others => '0'));
begin
    DataA <= Regs(to_integer(unsigned(RFonteA)));
    DataB <= Regs(to_integer(unsigned(RFonteB)));
    process(clk) is
    begin
        if falling_edge(clk) and RegWrite = '1' and Rd /= "00" then
            Regs(to_integer(unsigned(RDest))) <= Data;
        end if;
    end process;
end Behavioral;
