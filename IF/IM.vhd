library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is port(
    clk                       : in std_logic;
    CurrPC_out                     : in std_logic_vector(15 downto 0);

    Instruction                : out std_logic_vector(15 downto 0)
);  
end IM;


architecture Behavioral of IM is 
    type mem_type is array (0 to 65536) of std_logic_vector(15 downto 0);	--CurrPC is the address

    signal memory: mem_type := (others => (others => '0'));	--initialize memory
begin 
    mem_init process
    begin
        -- carregar fibonacci.bin na memória
                                          -- main:
        memory(0)  <= "0010001000001010"; -- addi $1, $0, 10
        memory(1)  <= "0010010000000000"; -- addi $2, $0, 0
        memory(2)  <= "0010011000000001"; -- addi $3, $0, 1
                                          -- loop:
        memory(3)  <= "1000100000001011"; -- beq $1, $0, out
        memory(4)  <= "1111000000000000"; -- dsp $2;
        memory(5)  <= "0001011100000000"; -- add $2, $2, $3
        memory(6)  <= "1000100000001011"; -- beq $1, $0, out
        memory(7)  <= "1111100000000000"; -- dsp $3
        memory(8)  <= "0001011110000000"; -- add $3, $2, $3
        memory(9)  <= "0001011110000000"; -- addi $1, $0, -1
        memory(10) <= "1000000000000011"; -- beq $0, $0, loop
                                          -- out:
        memory(11) <= "1000000000000000"; -- beq $0, $0, main
        wait;
    end process
    process(clk)
    begin 
        if(rising_edge(clk)) then
            Instruction <= memory(to_integer(unsigned(CurrPC_out)));
        end if;
    end process;

end Behavioral;
