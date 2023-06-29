library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is port(
    clk        : in std_logic;
    CurrPC_out : in std_logic_vector(15 downto 0);

    Instruction: out std_logic_vector(15 downto 0)
);  
end IM;


architecture Behavioral of IM is 
    type mem_type is array (0 to 255) of std_logic_vector(15 downto 0);	--CurrPC is the address

    signal memory: mem_type := (
        "0000000000000000", -- nop (compensar offset PC-memoria)
        "0010001000001111", -- addi $1, $0, 10
        "0010010000000000", -- addi $2, $0, 0
        "0010011000000001", -- addi $3, $0, 1
        --loop:
        "1000100000001011", -- beq $1, $0, out (NewPC+9)
        "1111000000000000", -- dsp $2;
        "0001011100000000", -- add $2, $2, $3
        "0010101111111111", -- addi $1, $1, -1
        "1000001000000101", -- beq $0, $1, out (NewPC+5)
        "1111100000000000", -- dsp $3
        "0001011110000000", -- add $3, $2, $3
        "0010101111111111", -- addi $1, $1, -1
        "1000001000000000", -- beq $0, $1, out (NewPC+0)
        "1000000111110101", -- beq $0, $0, loop (NewPC-11)
        others => (others => '0')
    );	--initialize memory
    signal addr_intern : std_logic_vector(7 downto 0) := (others => '0');
begin 
    addr_intern <= CurrPC_out(7 downto 0);
    process(clk) is
    begin 
        if(rising_edge(clk)) then
            Instruction <= memory(to_integer(unsigned(addr_intern)));
        end if;
    end process;

end Behavioral;
