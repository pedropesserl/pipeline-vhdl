LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY fowarding_unit_tb IS
END fowarding_unit_tb;
 
ARCHITECTURE behavior OF fowarding_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT forwarding_unit
    PORT(
         MEM_RegWrite : IN  std_logic;
         WB_RegWrite : IN  std_logic;
         EX_Rs : IN  std_logic_vector(3 downto 0);
         EX_Rt : IN  std_logic_vector(3 downto 0);
         MEM_Rd : IN  std_logic_vector(3 downto 0);
         WB_Rd : IN  std_logic_vector(3 downto 0);
         forwardA : OUT  std_logic_vector(1 downto 0);
         forwardB : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MEM_RegWrite : std_logic := '0';
   signal WB_RegWrite : std_logic := '0';
   signal EX_Rs : std_logic_vector(3 downto 0) := (others => '0');
   signal EX_Rt : std_logic_vector(3 downto 0) := (others => '0');
   signal MEM_Rd : std_logic_vector(3 downto 0) := (others => '0');
   signal WB_Rd : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal forwardA : std_logic_vector(1 downto 0);
   signal forwardB : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: forwarding_unit PORT MAP (
          MEM_RegWrite => MEM_RegWrite,
          WB_RegWrite => WB_RegWrite,
          EX_Rs => EX_Rs,
          EX_Rt => EX_Rt,
          MEM_Rd => MEM_Rd,
          WB_Rd => WB_Rd,
          forwardA => forwardA,
          forwardB => forwardB
        );

   -- Clock process definitions
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
