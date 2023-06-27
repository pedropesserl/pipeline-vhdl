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
         MEM_Rd, EX_Rs, WB_Rd, EX_Rt : IN  std_logic_vector(3 downto 0);
         forwardA : OUT  std_logic_vector(1 downto 0);
         forwardB : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal MEM_RegWrite : std_logic := '0';
   signal WB_RegWrite : std_logic := '0';
   signal MEM_Rd : std_logic_vector(3 downto 0) := (others => '0');
   signal EX_Rs : std_logic_vector(3 downto 0) := (others => '0');
   signal EX_Rt : std_logic_vector(3 downto 0) := (others => '0');
   signal WB_Rd : std_logic_vector(3 downto 0) := (others => '0');
   signal WB_Rt : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal forwardA : std_logic_vector(1 downto 0);
   signal forwardB : std_logic_vector(1 downto 0);
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: forwarding_unit PORT MAP (
          MEM_RegWrite => MEM_RegWrite,
          WB_RegWrite => WB_RegWrite,
          MEM_Rd => MEM_Rd,
          EX_Rs => EX_Rs,
          WB_Rd => WB_Rd,
          EX_Rt => EX_Rt,
          forwardA => forwardA,
          forwardB => forwardB
        );
   -- Stimulus process
   stim_proc: process
   begin		
       -- programa
       -- add $1, $2, $3
       -- add $4, $1, $3
       MEM_RegWrite <= '1';
       WB_RegWrite <= '0';
       MEM_Rd <= "0001";
       EX_Rs <= "0001";
       WB_Rd <= "0010";
       EX_Rt <= "0011";

       wait for 10 ns;

       report "Valores recebidos: FA = " &
            std_logic'image(forwardA(1)) & std_logic'image(forwardA(0)) &
            " FB = " &
            std_logic'image(forwardB(1)) & std_logic'image(forwardB(0));
       report "Valores esperados: FA = 10 FB = 00";


       -- add $5, $1, $4
       MEM_RegWrite <= '1';
       WB_RegWrite <= '1';
       MEM_Rd <= "0100";
       EX_Rs <= "0001";
       WB_Rd <= "0001";
       EX_Rt <= "0100";

       wait for 10 ns;

       report "Valores recebidos: FA = " &
            std_logic'image(forwardA(1)) & std_logic'image(forwardA(0)) &
            " FB = " &
            std_logic'image(forwardB(1)) & std_logic'image(forwardB(0));
       report "Valores esperados: FA = 01 FB = 10";

      wait;
   end process;

END;
