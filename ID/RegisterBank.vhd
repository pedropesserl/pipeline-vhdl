library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterBank is port(
    Rs, Rt, Rd   : in std_logic_vector(1 downto 0);
    Data         : in std_logic_vector(15 downto 0);
    RegWrite, clk: in std_logic;
    DataA, DataB : out std_logic_vector(15 downto 0)
);
end RegisterBank;

architecture Behavioral of RegisterBank is
    component Register16 is port(
        Data_in          : in std_logic_vector(15 downto 0);
        Write_Enable, clk: in std_logic;
        Data_out         : out std_logic_vector(15 downto 0)
    );
    end component;

    type Reg_out_type is array (0 to 3) of std_logic_vector(15 downto 0);
    signal Reg_out: Reg_out_type := (others => (others => '0'));
    signal WE     : std_logic_vector(3 downto 0);
begin
    with Rd select WE <=
        "000" & RegWrite      when "00",
        "00" & RegWrite & "0" when "01",
        "0" & RegWrite & "00" when "10",
        RegWrite & "000"      when "11";

    gen_registers: for i in 0 to 3 generate
        r: Register16 port map (
            clk => clk,
            Data_in => Data,
            Write_Enable => WE(i),
            Data_out => Reg_out(i)
        );
    end generate;

    with Rs select DataA <=
        Reg_out(0) when "00",
        Reg_out(1) when "01",
        Reg_out(2) when "10",
        Reg_out(3) when "11";

    with Rt select DataB <=
        Reg_out(0) when "00",
        Reg_out(1) when "01",
        Reg_out(2) when "10",
        Reg_out(3) when "11";
end Behavioral;
