library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is port(
    clk                       : in std_logic;
    CurrPC_out                     : in std_logic_vector(15 downto 0);

    Instrution                : out std_logic_vector(15 downto 0)
);  
end IM;


architecture Behavioral of IM is 
    type mem_type is array (0 to 65536) of std_logic_vector(15 downto 0);	--CurrPC is the address

    signal memory 				: mem_type := (others => (others => '0'));	--initialize memory
begin 

    process(clk)
    begin 
        if(rising_edge(clk)) then
            Instrution <= memory(to_integer(unsigned(CurrPC_out)));
        end if;
    end process;

end Behavioral;