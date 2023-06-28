library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display is port(
    Data              : in std_logic_vector(15 downto 0);
    DisplayEnable, clk: in std_logic;
    A, B, C, D,
    E, F, G        : out std_logic_vector(3 downto 0)
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
    A <= DisplayOut(0)(6) & DisplayOut(1)(6) & DisplayOut(2)(6) & DisplayOut(3)(6);
    B <= DisplayOut(0)(5) & DisplayOut(1)(5) & DisplayOut(2)(5) & DisplayOut(3)(5);
    C <= DisplayOut(0)(4) & DisplayOut(1)(4) & DisplayOut(2)(4) & DisplayOut(3)(4);
    D <= DisplayOut(0)(3) & DisplayOut(1)(3) & DisplayOut(2)(3) & DisplayOut(3)(3);
    E <= DisplayOut(0)(2) & DisplayOut(1)(2) & DisplayOut(2)(2) & DisplayOut(3)(2);
    F <= DisplayOut(0)(1) & DisplayOut(1)(1) & DisplayOut(2)(1) & DisplayOut(3)(1);
    G <= DisplayOut(0)(0) & DisplayOut(1)(0) & DisplayOut(2)(0) & DisplayOut(3)(0);
end Behavioral;
