library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display is port(
    Data              : in std_logic_vector(15 downto 0);
    DisplayEnable, clk: in std_logic;
    Char0, Char1,
    Char2, Char3      : out std_logic_vector(6 downto 0)
);
end Display;

architecture Behavioral of Display is
    component Display_7_seg is port(
        DataIn          : in std_logic_vector(3 downto 0);
        WriteEnable, clk: in std_logic;
        segments        : out std_logic_vector(6 downto 0)
    );
    end component;
    type Display_type is array (0 to 3) of std_logic_vector(6 downto 0);
    signal DisplayOut: Display_type := (others => (others => '0'));
begin
    gen_chars: for i in 0 to 3 generate
        c: Display_7_seg port map(
            clk => clk,
            DataIn => Data(4*i+3 downto 4*i),
            WriteEnable => DisplayEnable,
            segments => DisplayOut(i)
        );
    end generate;
    Char0 <= DisplayOut(0);
    Char1 <= DisplayOut(1);
    Char2 <= DisplayOut(2);
    Char3 <= DisplayOut(3);
end Behavioral;
