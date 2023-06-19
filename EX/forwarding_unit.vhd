library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity forwarding_unit is port(
    MEM_RegWrite, MEM_Rd        : in std_logic_vector(3 downto 0);
    WB_RegWrite, WB_Rd          : in std_logic_vector(3 downto 0);
    EX_Rs, EX_Rt                : in std_logic_vector(3 downto 0);

    forwardA, forwardB          : out std_logic_vector(1 downto 0)
);
end forwarding_unit;

architecture Behavioral of forwarding_unit is
begin 
    --EX hazard
    if (MEM_RegWrite and (MEM_Rd /= "0") and (MEM_Rd = EX_Rs)) then
        forwardA <= "10";
    elsif (WB_RegWrite and (WB_Rd /= "0") and (WB_Rd = EX_Rs)) then
        forwardB <= "10";
    end if;
    
    --MEM hazard
    if (WB_RegWrite and (WB_Rd /= "0") and (WB_Rd = EX_Rs)) then
        forwardA <= "01";
    elsif (WB_RegWrite and (WB_Rd /= "0") and (WB_Rd = EX_Rt)) then
        forwardB <= "01";
    end if;

end Behavioral;
