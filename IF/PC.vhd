library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is port(
        clk, MEM_Branch, MEM_Zero, PCWrite  : in std_logic;
        MEM_BeqAddress, NewPC               : in std_logic_vector(15 downto 0);

        CurrPC                              : out std_logic_vector(15 downto 0)
);
end PC;

architecture Behavioral of PC is
    signal mux_out : std_logic_vector(15 downto 0) := (others => '0');
    signal internal_PC : std_logic_vector(15 downto 0) := (others => '0');
begin 
    --mux 
    mux_out <= MEM_BeqAddress when (MEM_Branch = '1' and MEM_Zero = '1') else NewPC;

    -- Add if in the rising edge
    CurrPC <= internal_PC;
    process(clk)
    begin
        if (rising_edge(clk) and (PCWrite = '1')) then
            internal_PC <= mux_out;
        else
            internal_PC <= internal_PC;
        end if;
    end process;

end Behavioral;
