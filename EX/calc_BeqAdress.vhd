library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity calc_BeqAdress is port(
	EX_NewPC, EX_extended_imm		: in std_logic_vector(15 downto 0);
	BeqAddress				: out std_logic_vector(15 downto 0)
);
end calc_BeqAdress;

architecture Behavioral of calc_BeqAdress is
begin
	--pc novo + imm shifted 2 bits
	BeqAddress <= EX_NewPC + (EX_extended_imm(13 downto 0) & "00");

end Behavioral;
