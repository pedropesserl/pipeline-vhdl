--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:58:13 06/19/2023
-- Design Name:   
-- Module Name:   /home/luize/Pipiline/pipeline-vhdl/EX/tb/calc_BeqAdress.vhd
-- Project Name:  Pipiline
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: calc_BeqAdress
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
use ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY calc_BeqAdress_tb IS
END calc_BeqAdress_tb;
 
ARCHITECTURE behavior OF calc_BeqAdress_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT calc_BeqAdress
    PORT(
         EX_NewPC : IN  std_logic_vector(15 downto 0);
         EX_extended_imm : IN  std_logic_vector(15 downto 0);
         BeqAddress : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal EX_NewPC : std_logic_vector(15 downto 0) := (others => '0');
   signal EX_extended_imm : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal BeqAddress : std_logic_vector(15 downto 0);

   -- Teste signals
   signal BeqAddress_e : std_logic_vector(15 downto 0);

   type test_unit is record
       newPC, Imm, BeqAddr: std_logic_vector(15 downto 0);
   end record;

   type test_vector_t is array(positive range<>) of test_unit;

   constant test_vector : test_vector_t := (
   -- newPc              Imm                 BeqAddr
   (x"0000", x"0068", x"01a0"),
   (x"7704", x"0564", x"8c94"),
   (x"3b40", x"000f", x"3b7c")
    );

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: calc_BeqAdress PORT MAP (
          EX_NewPC => EX_NewPC,
          EX_extended_imm => EX_extended_imm,
          BeqAddress => BeqAddress
        );

   Teste_proc : process
       variable t : test_unit;
   begin
      for i in test_vector'range loop
          t := test_vector(i);
          EX_NewPC <= t.newPc;
          EX_extended_imm <= t.Imm;
          BeqAddress_e <= t.BeqAddr;

          wait for 100 ns;
          report "Beq resultado: " & integer'image(to_integer(unsigned(BeqAddress)));
          report "Beq esperado: " & integer'image(to_integer(unsigned(BeqAddress_e)));
      end loop;
      wait;
   end process Teste_proc;

END;
