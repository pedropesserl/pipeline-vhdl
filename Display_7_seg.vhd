library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Display_7_seg is port(
    Data_in          : in std_logic_vector(3 downto 0);
    Write_Enable, clk: in std_logic;
    segments         : out std_logic_vector(6 downto 0);
);
end Display_7_seg;

architecture Behavioral of Display is
begin
    process(clk, Write_Enable) is
    begin
        if rising_edge(clk) and Write_Enable = '1' then
            case Data is
                -- presume que os segmentos são ativos em 0
                when "0000" => segments <= "0000001"; -- 0
                when "0001" => segments <= "1001111"; -- 1
                when "0010" => segments <= "0010010"; -- 2
                when "0011" => segments <= "0000110"; -- 3
                when "0100" => segments <= "1001100"; -- 4
                when "0101" => segments <= "0100100"; -- 5
                when "0110" => segments <= "0100000"; -- 6
                when "0111" => segments <= "0001111"; -- 7
                when "1000" => segments <= "0000000"; -- 8
                when "1001" => segments <= "0000100"; -- 9
                when "1010" => segments <= "0001000"; -- A
                when "1011" => segments <= "1100000"; -- b
                when "1100" => segments <= "1110010"; -- c
                when "1101" => segments <= "1000010"; -- d
                when "1110" => segments <= "0110000"; -- E
                when "1111" => segments <= "0111000"; -- F
            end case;
        end if;
    end process;
end Behavioral;