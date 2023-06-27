library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Pipeline is 
    port (
        GlobalClk: in std_logic;
    );
end Pipeline;

architecture Behavioral of Pipeline is
    component ALUcontrol is port (
        EX_ALUOp, EX_Func           : in std_logic_vector(2 downto 0);
        ALUControlOut               : out std_logic_vector(2 downto 0)
    );
    end component;

    component ControlUnit is port(
        OPCode				        : in std_logic_vector(2 downto 0);
        MemRead, MemWrite, MemtoReg, RegWrite, 
        RegDest, Branch, ALUSrc, DisplayEnable 	: out std_logic;
        ALUOp 				        : out std_logic_vector(2 downto 0)
    );
    end component;
    
    component HazardDetectionUnit is port(
        EX_MemRead							:in std_logic;
        EX_Rd								:in std_logic_vector(1 downto 0);
        ID_Instruction						: in std_logic_vector(15 downto 0);
        PCWrite, IF_ID_Write, Flush 		: out std_logic
    );
    end component;

    component forwarding_unit is port(
        MEM_RegWrite, WB_RegWrite               : in std_logic;
        EX_Rs, EX_Rt, MEM_Rd, WB_Rd             : in std_logic_vector(3 downto 0);

        forwardA, forwardB                        : out std_logic_vector(1 downto 0)
    );
    end component;

    component PC is port(
            clk, MEM_Branch, MEM_Zero, PCWrite  : in std_logic;
            MEM_BeqAddress, NewPC               : in std_logic_vector(15 downto 0);

            CurrPC                              : out std_logic_vector(15 downto 0)
    );
    end component;

    component IM is port(
        clk                       : in std_logic;
        CurrPC_out                     : in std_logic_vector(15 downto 0);

        Instrution                : out std_logic_vector(15 downto 0)
    );  
    end component;

    component RegisterBank is port(
        Rs, Rt, Rd   : in std_logic_vector(1 downto 0);
        Data         : in std_logic_vector(15 downto 0);
        RegWrite, clk: in std_logic;
        DataA, DataB : out std_logic_vector(15 downto 0)
    );
    end component;

    component alu is port(
        Data_a, Data_b      : in std_logic_vector(15 downto 0);
        ALUControlOut       : in std_logic_vector(2 downto 0);
        EX_Shamt            : in std_logic_vector(3 downto 0);
        ALUOut              : out std_logic_vector(15 downto 0);
        Zero                : out std_logic
    );
    end component;

    component data_mem is port(
        MEM_ALUOut, MEM_WriteData 			: in std_logic_vector(15 downto 0);
        clk, MEM_MemWrite, MEM_MemRead			: in std_logic;
        ReadData 					: out std_logic_vector(15 downto 0)
    ); 
    end component;

    component Display is port(
        Data               : in std_logic_vector(15 downto 0);
        DisplayEnable, clk: in std_logic;
        Char0, Char1,
        Char2, Char3       : out std_logic_vector(6 downto 0);
    );
    end component;
    
    signal LocalClk : std_logic;
    --as declarações são correspondentes ao local onde são inicializadas e não ao primeiro uso
    -- IF Declarations
    signal CurrPC, NewPC, Instruction : std_logic_vector(15 downto 0);
    signal PCWrite, IF_ID_Write : std_logic;
    -- PCsrc nn existe mais, eh só passar Branch e Zero que vem do MEM

    -- ID Declarations
    signal StallMux, MemRead, MemWrite, MemtoReg, RegWrite, RegDest, Branch, ALUSrc, DisplayEnable : std_logic;
    signal ALUOp : std_logic_vector(2 downto 0);
    signal DataA, DataB : std_logic_vector(15 downto 0);
    -- opcode nn precisa de sinal, eh so passar a parte certa da instrucao

    -- EX Declarations
    signal Zero : std_logic;
    signal forwardA, forwardB : std_logic_vector(1 downto 0);
    signal ALUControlOut : std_logic_vector(2 downto 0); 
    signal ALUOut, BeqAddress : std_logic_vector(15 downto 0);

    -- MEM Declarations
    signal BeqAddress, WriteData, ReadData : std_logic_vector(15 downto 0);

begin
    --signal opcode : std_logic_vector(2 downto 0); 
    -- opcode  <= Instruction(15 downto 13);
    -- IF 
    PC: PC port map (
        LocalClk => clk;
        => 
    );
    
    -- ID
--flush eh pra limpar id_ex
    -- EX

    -- MEM

    -- WB
--sinal do display sai dessa fase 
end Behavioral;
    -- exemplo de como pegar dado do registrador
    --R_EXE_MEM; EX_MEM port map (
    --     EX_BeqAddres => BeqAdress;
    ---    sinal fora do componente => sinal dentro do componente
    --);
