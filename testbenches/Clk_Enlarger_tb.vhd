LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Clk_Enlarger_tb IS
    END Clk_Enlarger_tb;

ARCHITECTURE behavior OF Clk_Enlarger_tb IS 
    COMPONENT Clk_Enlarger
        PORT(
                clk_in : IN  std_logic;
                clk_out : OUT  std_logic
            );
    END COMPONENT;


   --Inputs
    signal clk_in : std_logic := '0';

   --Outputs
    signal clk_out : std_logic;

   -- Clock period definitions
    constant clk_in_period : time := 2 ps;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
    uut: Clk_Enlarger PORT MAP (
       clk_in => clk_in,
       clk_out => clk_out
    );

   -- Clock process definitions
    clk_in_process :process
    begin
        clk_in <= '0';
        wait for clk_in_period/2;
        clk_in <= '1';
        wait for clk_in_period/2;
    end process;

   -- Stimulus process
    stim_proc: process
    begin		
        wait;
    end process;

END;
