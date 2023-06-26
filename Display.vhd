library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display is port(
    Data               : in std_logic_vector(15 downto 0);
    Display_Enable, clk: in std_logic;
    Char0, Char1,
    Char2, Char3       : out std_logic_vector(6 downto 0);
);
end Display;

architecture Behavioral of Display is
    component Display_7_seg is port(
        Data_in          : in std_logic_vector(3 downto 0);
        Write_Enable, clk: in std_logic;
        segments         : out std_logic_vector(6 downto 0);
    );
    end component;
begin
    c0: Display_7_seg port map (
        clk => clk,
        Data_in => Data(3 downto 0),
        Write_Enable => Display_Enable,
        segments => Char0
    );
    c1: Display_7_seg port map (
        clk => clk,
        Data_in => Data(7 downto 4),
        Write_Enable => Display_Enable,
        segments => Char1
    );
    c2: Display_7_seg port map (
        clk => clk,
        Data_in => Data(11 downto 8),
        Write_Enable => Display_Enable,
        segments => Char2
    );
    c3: Display_7_seg port map (
        clk => clk,
        Data_in => Data(15 downto 12),
        Write_Enable => Display_Enable,
        segments => Char3
    );
end Behavioral;
