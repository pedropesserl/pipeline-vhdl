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
    component DisplayCod is port(
        DataIn  : in std_logic_vector(3 downto 0);
        segments: out std_logic_vector(6 downto 0)
    );
    end component;

    signal curr_data: std_logic_vector(15 downto 0) := (others => '0');
    signal segments: std_logic_vector(6 downto 0) := (others => '0');
    signal Data2Encode: std_logic_vector(3 downto 0) := x"0";
    signal counter : natural range 0 to 100000 := 0;
    signal curr_dsp : natural range 0 to 3 := 0;

begin
    algo: DisplayCod port map (
        DataIn => Data2Encode,
        segments => segments
    ); 

    --registrador que guarda o dado a ser exibido
    process(clk) is
    begin
        if rising_edge(clk) and DisplayEnable = '1' then
                curr_data <= Data;
            else
                curr_data <= curr_data;
        end if;
    end process;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if counter = 10000 then
                curr_dsp <= curr_dsp + 1;
                if curr_dsp = 4 then
                    curr_dsp <= 0;
                end if;
                counter <= 0;
            end if;
            counter <= counter + 1;
        end if;
    end process;

    process(clk) is
    begin
        if rising_edge(clk) then
            case curr_dsp is
                when 0 => CharEnable <= "1110";
                          Data2Encode <= curr_data(3 downto 0);
                when 1 => CharEnable <= "1101";
                          Data2Encode <= curr_data(7 downto 4);
                when 2 => CharEnable <= "1011";
                          Data2Encode <= curr_data(11 downto 8);
                when 3 => CharEnable <= "0111";
                          Data2Encode <= curr_data(15 downto 12);
                when others => CharEnable <= "1111";
                            Data2Encode <= "1010";
            end case;
            CPorts <= segments & '1';
        end if;
    end process;
end Behavioral;
