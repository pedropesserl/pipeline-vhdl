LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY data_mem_tb IS
    END data_mem_tb;

ARCHITECTURE behavior OF data_mem_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT data_mem
        PORT(
                MEM_ALUOut : IN  std_logic_vector(15 downto 0);
                MEM_WriteData : IN  std_logic_vector(15 downto 0);
                clk : IN  std_logic;
                MEM_MemWrite : IN  std_logic;
                MEM_MemRead : IN  std_logic;
                ReadData : OUT  std_logic_vector(15 downto 0)
            );
    END COMPONENT;


   --Inputs
    signal MEM_ALUOut : std_logic_vector(15 downto 0) := (others => '0');
    signal MEM_WriteData : std_logic_vector(15 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal MEM_MemWrite : std_logic := '0';
    signal MEM_MemRead : std_logic := '0';

   --Outputs
    signal ReadData : std_logic_vector(15 downto 0);

   -- Clock period definitions
    constant clk_period : time := 10 ns;

BEGIN

   -- Instantiate the Unit Under Test (UUT)
    uut: data_mem PORT MAP (
       MEM_ALUOut => MEM_ALUOut,
       MEM_WriteData => MEM_WriteData,
       clk => clk,
       MEM_MemWrite => MEM_MemWrite,
       MEM_MemRead => MEM_MemRead,
       ReadData => ReadData
   );

   -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;


   -- Stimulus process
    stim_proc: process
    begin		
        MEM_ALUOut <= x"0000";
        MEM_WriteData <= x"cbbc";
        MEM_MemWrite <= '1';
        MEM_MemRead <= '0';

        wait for clk_period * 1.5;

        MEM_ALUOut <= x"0000";
        MEM_WriteData <= x"0000";
        MEM_MemWrite <= '0';
        MEM_MemRead <= '1';

        wait for clk_period*2.5;
        
        report "Valor resultado: " & integer'image(to_integer(unsigned(ReadData)));
        report "Valor esperado: 52156";
        wait;
    end process;

END;
