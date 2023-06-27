library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Clk_Enlarger is
generic(
        max_freq: integer := 26214400; -- 25MHz
        max_freq_bits: integer := 24  -- log2(25)
);
port(
    clk_in :        in std_logic;
    clk_out :       out std_logic
);
end entity Clk_Enlarger;

architecture Behavioral of Clk_Enlarger is
    signal clk_counter : std_logic_vector(max_freq_bits - 1 downto 0) := (others => '0');
    signal clk_inter   : std_logic := '0';
    constant max_freq_hex : std_logic_vector(max_freq_bits - 1 downto 0) := x"c80000";
begin 
    clk_enlagaer: process(clk_in) is
    begin
        if rising_edge(clk_in) then
            clk_counter <= clk_counter + x"000001";
            -- Mudar a frequencia do clock, o menor do basys 2 eh 25MHz
            -- logo diminur a frequencia para 2Hz e ter um clock time de 0,5 segundos
            if clk_counter = x"c80000" then
                clk_counter <= (others => '0');
                clk_inter <= not clk_inter;
            end if;

            clk_out <= clk_inter;
        end if;
    end process;
end Behavioral;
