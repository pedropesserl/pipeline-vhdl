LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE behavior OF alu_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT alu
        PORT(
                Data_a : IN  std_logic_vector(15 downto 0);
                Data_b : IN  std_logic_vector(15 downto 0);
                ALUControlOut : IN  std_logic_vector(2 downto 0);
                EX_Shamt : IN  std_logic_vector(3 downto 0);
                ALUOut : OUT  std_logic_vector(15 downto 0);
                Zero : OUT  std_logic
            );
    END COMPONENT;


   --Inputs
    signal Data_a : std_logic_vector(15 downto 0) := (others => '0');
    signal Data_b : std_logic_vector(15 downto 0) := (others => '0');
    signal ALUControlOut : std_logic_vector(2 downto 0) := (others => '0');
    signal EX_Shamt : std_logic_vector(3 downto 0) := (others => '0');

   --Outputs
    signal ALUOut : std_logic_vector(15 downto 0);
    signal Zero : std_logic;

   -- Test benchs
   type test_unit is record
       Data_a, Data_b : std_logic_vector(15 downto 0);
       ALUControlOut : std_logic_vector(2 downto 0);
       EX_Shamt : std_logic_vector(3 downto 0);
       ALUOut_e : std_logic_vector(15 downto 0);
       Zero_e : std_logic;
   end record;

   type test_vector_t is array(positive range<>) of test_unit;
   constant test_vector : test_vector_t := (
   -- Data_a Data_b ALUCOntrol EX_Shamt ALUOut_e Zero_e
       (x"53a4", x"1234", "000", "0000", x"65d8", '0'),
       (x"fb04", x"0007", "001", "0000", x"fafd", '0'),
       (x"0b07", x"0b07", "001", "0000", x"0000", '1'),
       (x"0056", x"0027", "010", "0000", x"0006", '0'),
       (x"0056", x"0027", "011", "0000", x"0077", '0'),
       (x"0056", x"0027", "100", "0000", x"ff88", '0'),
       (x"0dc6", x"0000", "101", "0011", x"6e30", '0'),
       (x"0dc6", x"0000", "110", "0011", x"01b8", '0')
    );

BEGIN

   -- Instantiate the Unit Under Test (UUT)
    uut: alu PORT MAP (
      Data_a => Data_a,
      Data_b => Data_b,
      ALUControlOut => ALUControlOut,
      EX_Shamt => EX_Shamt,
      ALUOut => ALUOut,
      Zero => Zero
    );

   -- Stimulus process
    stim_proc: process is
        variable t : test_unit;
    begin		
        for i in test_vector'range loop
            t := test_vector(i);
            Data_a <= t.Data_a;
            Data_b <= t.Data_b;
            ALUControlOut <= t.ALUControlOut;
            EX_Shamt <= t.EX_Shamt;
            wait for 10 ns;

            report "Valor resultado: " & integer'image(to_integer(unsigned(ALUOut)));
            report "Zero resultado: " & std_logic'image(Zero);
            report "Valor esperado: " & integer'image(to_integer(unsigned(t.ALUOut_e)));
            report "Zero esperado: " & std_logic'image(t.Zero_e);
        end loop;
        wait;
    end process;

END;
