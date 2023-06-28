library ieee;
use ieee.std_logic_1164.all;
entity pipiline_tb is
end pipiline_tb;
 
architecture behavior of pipiline_tb is 
 
    -- component declaration for the unit under test (uut)
 
    component pipeline
    port(
         globalclk : in  std_logic;
         dsp0 : out  std_logic_vector(6 downto 0);
         dsp1 : out  std_logic_vector(6 downto 0);
         dsp2 : out  std_logic_vector(6 downto 0);
         dsp3 : out  std_logic_vector(6 downto 0)
        );
    end component;
    

   --inputs
   signal globalclk : std_logic := '0';

 	--outputs
   signal dsp0 : std_logic_vector(6 downto 0);
   signal dsp1 : std_logic_vector(6 downto 0);
   signal dsp2 : std_logic_vector(6 downto 0);
   signal dsp3 : std_logic_vector(6 downto 0);

   -- clock period definitions
   constant globalclk_period : time := 10 ns;
 
begin
 
	-- instantiate the unit under test (uut)
   uut: pipeline port map (
          globalclk => globalclk,
          dsp0 => dsp0,
          dsp1 => dsp1,
          dsp2 => dsp2,
          dsp3 => dsp3
        );

   -- clock process definitions
   globalclk_process :process
   begin
		globalclk <= '0';
		wait for globalclk_period/2;
		globalclk <= '1';
		wait for globalclk_period/2;
   end process;
 

   -- stimulus process
   stim_proc: process
   begin
      wait;
   end process;

end;
