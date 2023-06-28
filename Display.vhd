library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display is port(
    Data              : in std_logic_vector(15 downto 0);
    DisplayEnable, clk: in std_logic;
    CPorts            : out std_logic_vector(7 downto 0);
    CharEnable        : out std_logic_vector(3 downto 0)
);
end Display;

architecture Behavioral of Display is
    component Display_cod is port(
        DataIn  : in std_logic_vector(3 downto 0);
        segments: out std_logic_vector(6 downto 0)
    );
    end component;
    signal segments: std_logic_vector(6 downto 0) := (others => '0');
    signal Data2Encode: std_logic_vector(3 downto 0) := (others => '0');
begin
    cod: Display_cod port map (
        DataIn => Data2Encode,
        segments => segments
    ); 

    Display: process is
    begin
        if DisplayEnable = '1' then
            for i in 0 to 3 loop
                case i is
                    when 0 => CharEnable <= "1110";
                              Data2Encode <= Data(3 downto 0);
                    when 1 => CharEnable <= "1101";
                              Data2Encode <= Data(7 downto 4);
                    when 2 => CharEnable <= "1011";
                              Data2Encode <= Data(11 downto 8);
                    when 3 => CharEnable <= "0111";
                              Data2Encode <= Data(15 downto 12);
                end case;
                CPors <= segments;
                wait for 20 ms;
            end loop;
        end if;
    end process;
end Behavioral;
