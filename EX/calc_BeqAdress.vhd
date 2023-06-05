library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity calc_BeqAdress is port(
	newPC, im_estendido			: in std_logic_vector(15 downto 0);
	BeqAddress				: out std_logic_vector(15 downto 0)
);

architecture Behavioral of calc_BeqAdress is
begin
	--pc novo + imediato shiftado 2 bits
	BeqAddress <= newPC + (im_estendido(13 downto 0) & "00");

end Behavioral;