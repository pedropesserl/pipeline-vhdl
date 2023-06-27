library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Pipeline is 
    port (
        GlobalClk: in std_logic;
    );
end Pipeline;

architecture Behavioral of Pipeline is
    component Clk_Enlarger is port(
        clk_in :        in std_logic;
        clk_out :       out std_logic
    );
    end component;

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
        EX_MemRead, Zero					: in std_logic;
        EX_Rd								: in std_logic_vector(1 downto 0);
        ID_Instruction						: in std_logic_vector(15 downto 0);
        PCWrite, IF_ID_Write, Flush 		: out std_logic
    );
    end component;

    component forwarding_unit is port(
        MEM_RegWrite, WB_RegWrite               : in std_logic;
        EX_Rs, EX_Rt, MEM_Rd, WB_Rd             : in std_logic_vector(3 downto 0);

        forwardA, forwardB                      : out std_logic_vector(1 downto 0)
    );
    end component;

    component PC is port(
            clk, MEM_Branch, MEM_Zero, PCWrite  : in std_logic;
            MEM_BeqAddress, NewPC               : in std_logic_vector(15 downto 0);

            CurrPC                              : out std_logic_vector(15 downto 0)
    );
    end component;

    component IM is port(
        clk                     : in std_logic;
        CurrPC_out              : in std_logic_vector(15 downto 0);

        Instrution              : out std_logic_vector(15 downto 0)
    );  
    end component;

    component RegisterBank is port(
        Rs, Rt, Rd              : in std_logic_vector(1 downto 0);
        Data                    : in std_logic_vector(15 downto 0);
        RegWrite, clk           : in std_logic;
        DataA, DataB            : out std_logic_vector(15 downto 0)
    );
    end component;

    component alu is port(
        Data_a, Data_b          : in std_logic_vector(15 downto 0);
        ALUControlOut           : in std_logic_vector(2 downto 0);
        EX_Shamt                : in std_logic_vector(3 downto 0);
        ALUOut                  : out std_logic_vector(15 downto 0);
        Zero                    : out std_logic
    );
    end component;

    component data_mem is port(
        MEM_ALUOut, MEM_WriteData 			: in std_logic_vector(15 downto 0);
        clk, MEM_MemWrite, MEM_MemRead		: in std_logic;
        ReadData 					        : out std_logic_vector(15 downto 0)
    ); 
    end component;

    component Display is port(
        Data                    : in std_logic_vector(15 downto 0);
        DisplayEnable, clk      : in std_logic;
        Char0, Char1,
        Char2, Char3            : out std_logic_vector(6 downto 0);
    );
    end component;
    
    signal LocalClk : std_logic;
    
    -- IF Declarations
    signal IF_CurrPC, IF_NewPC, IF_Instruction : std_logic_vector(15 downto 0);
    signal IF_PCWrite, IF_ID_Write : std_logic;
    -- PCsrc nn existe mais, eh só passar Branch e Zero que vem do MEM
    --NewPC eh PC+4

    -- ID Declarations
    -- coming from IF
    signal ID_Instruction, ID_NewPC : std_logic_vector(15 downto 0);
    -- created during ID
    signal ID_PCWrite, IF_ID_Write, ID_Flush, ID_MemRead, ID_MemWrite, ID_MemtoReg, ID_RegWrite, ID_RegDest, ID_Branch, ID_ALUSrc, ID_DisplayEnable : std_logic;
    signal ID_ALUOp : std_logic_vector(2 downto 0);
    signal ID_RegA, ID_RegB : std_logic_vector(15 downto 0);

    -- EX Declarations
    -- coming from ID
    signal EX_MemRead, EX_MemWrite, EX_MemtoReg, EX_RegWrite, EX_RegDest, EX_Branch, EX_ALUSrc, EX_DisplayEnable : std_logic;
    signal EX_Rs, EX_Rt, EX_Rd	: std_logic_vector(1 downto 0);
    signal EX_Func : std_logic_vector(2 downto 0);
	signal EX_Shamt : std_logic_vector(3 downto 0);
    signal EX_RegA, EX_RegB, EX_NewPC, EX_ExtendedImm : std_logic_vector(15 downto 0);
    -- created during EX
    signal EX_Zero : std_logic;
    signal EX_forwardA, EX_forwardB, MEM_RegtoW : std_logic_vector(1 downto 0);
    signal EX_ALUControlOut : std_logic_vector(2 downto 0); 
    signal EX_ALUOut, EX_BeqAddress : std_logic_vector(15 downto 0);

    -- MEM Declarations
    -- coming from EX  --WriteData eh DadoB
    signal MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Zero : std_logic;
    signal MEM_RegtoW : std_logic_vector(1 downto 0);
    signal MEM_BeqAddress, MEM_ALUOut, MEM_WriteData : std_logic_vector(15 downto 0);
    -- created during MEM
    signal MEM_ReadData : std_logic_vector(15 downto 0);

    -- WB Declarations
    -- coming from MEM
    signal WB_MemtoReg, WB_RegWrite
    signal WB_RegtoW : std_logic_vector(1 downto 0);
    signal WB_ALUOut, WB_ReadData : std_logic_vector(15 downto 0);

begin
    --signal opcode : std_logic_vector(2 downto 0); 
    -- opcode  <= Instruction(15 downto 13);
    
    Clk: Clk_Enlarger port map (
        GlobalClk => clk_in;
        LocalClk => clk_out;
    );

    -- IF 
    PC: PC port map (
        LocalClk => clk;
        MEM_Branch => MEM_Branch;
        MEM_Zero => MEM_Zero;
        ID_PCWrite => PCWrite;
        MEM_BeqAddress => MEM_BeqAddress;
        NewPC;
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
