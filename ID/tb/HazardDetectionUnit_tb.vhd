--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:01:59 06/26/2023
-- Design Name:   
-- Module Name:   /home/luize/Pipiline/pipeline-vhdl/ID/tb/HazardDetectionUnit_tb.vhd
-- Project Name:  Pipiline
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HazardDetectionUnit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY HazardDetectionUnit_tb IS
END HazardDetectionUnit_tb;
 
ARCHITECTURE behavior OF HazardDetectionUnit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HazardDetectionUnit
    PORT(
         EX_MemRead : IN  std_logic;
         EX_Rd : IN  std_logic_vector(1 downto 0);
         ID_Instruction : IN  std_logic_vector(15 downto 0);
         PCWrite : OUT  std_logic;
         IF_ID_Write : OUT  std_logic;
         StallMux : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal EX_MemRead : std_logic := '0';
   signal EX_Rd : std_logic_vector(1 downto 0) := (others => '0');
   signal ID_Instruction : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal PCWrite : std_logic;
   signal IF_ID_Write : std_logic;
   signal StallMux : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HazardDetectionUnit PORT MAP (
          EX_MemRead => EX_MemRead,
          EX_Rd => EX_Rd,
          ID_Instruction => ID_Instruction,
          PCWrite => PCWrite,
          IF_ID_Write => IF_ID_Write,
          StallMux => StallMux
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
