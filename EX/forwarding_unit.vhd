library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity forwarding_unit is port(
    MEM_RegWrite, WB_RegWrite               : in std_logic;
    EX_Rs, EX_Rt, MEM_Rd, WB_Rd             : in std_logic_vector(3 downto 0);

    forwardA, forwardB                      : out std_logic_vector(1 downto 0)
);
end forwarding_unit;

architecture Behavioral of forwarding_unit is
begin 

    process(MEM_RegWrite, MEM_Rd, WB_RegWrite, WB_Rd, EX_Rs, EX_Rt)
    begin 

        -- RegA hazard
        if ((MEM_RegWrite = '1') and (MEM_Rd /= "0") and (MEM_Rd = EX_Rs)) then
            forwardA <= "10";
        elsif ((WB_RegWrite = '1') and (WB_Rd /= "0") and (WB_Rd = EX_Rs)) then
            forwardA <= "01";
        else
                forwardA <= "00";
        end if;
        
        -- RegB hazard
        if ((MEM_RegWrite = '1') and (MEM_Rd /= "0") and (MEM_Rd = EX_Rt)) then
            forwardB <= "10";
        elsif ((WB_RegWrite = '1') and (WB_Rd /= "0") and (WB_Rd = EX_Rt)) then
            forwardB <= "01";
        else
                forwardB <= "00";
        end if;

    end process;

end Behavioral;
