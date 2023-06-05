library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity forwarding_unit is port(
	ex_mem_regwrite, ex_mem_rd			: in std_logic_vector(3 downto 0);
	mem_wb_regwrite, mem_wb_rd			: in std_logic_vector(3 downto 0);
	id_ex_rs, id_ex_rt				: in std_logic_vector(3 downto 0);

	forwardA, forwardB				: out std_logic_vector(1 downto 0)
);

architecture Behavioral of forwarding_unit is
begin 
	--EX hazard
	if (ex_mem_regwrite and (ex_mem_rd /= "0") and (ex_mem_rd = id_ex_rs)) then
		forwardA <= "10";
	elsif (mem_wb_regwrite and (mem_wb_rd /= "0") and (mem_wb_rd = id_ex_rs)) then
		forwardB <= "10";
	end if;
	
	--MEM hazard
	if (mem_wb_regwrite and (mem_wb_rd /= "0") and (mem_wb_rd = id_ex_rs)) then
		forwardA <= "01";
	elsif (mem_wb_regwrite and (mem_wb_rd /= "0") and (mem_wb_rd = id_ex_rt)) then
		forwardB <= "01";
	end if;

end Behavioral;

