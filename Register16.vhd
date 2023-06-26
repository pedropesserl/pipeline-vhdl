library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register16 is port(
    Data_in          : in std_logic_vector(15 downto 0);
    Write_Enable, clk: in std_logic;
    Data_out         : out std_logic_vector(15 downto 0)
);
end Register16;

architecture Behavioral of Register16 is
begin
    process(clk, Write_Enable) is
	begin
        if falling_edge(clk) and Write_Enable = "1" then
		    Data_out <= Data_in;
        end if;
    end process;
end Behavioral;
