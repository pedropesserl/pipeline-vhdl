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

        Instruction              : out std_logic_vector(15 downto 0)
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
        ALUOut, WriteData 			: in std_logic_vector(15 downto 0);
        clk, MemWrite, MemRead			: in std_logic;
        ReadData 				: out std_logic_vector(15 downto 0)
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
    -- PCsrc nn existe mais, eh só passar Branch e Zero que vem do MEM
    --NewPC eh PC+4

    -- ID Declarations
    -- coming from IF
    signal ID_Instruction, ID_NewPC : std_logic_vector(15 downto 0);
    -- created during ID
    signal ID_PCWrite, IF_ID_Write, ID_Flush, ID_MemRead, ID_MemWrite, ID_MemtoReg, ID_RegWrite, ID_RegDest, ID_Branch, ID_ALUSrc, ID_DisplayEnable : std_logic;
    signal ID_Rs, ID_Rt, ID_Rd	: std_logic_vector(1 downto 0);
    signal ID_OPCode, ID_Func, ID_ALUOp : std_logic_vector(2 downto 0);
	signal ID_Shamt : std_logic_vector(3 downto 0);
    signal ID_RegA, ID_RegB, ID_ExtendedImm : std_logic_vector(15 downto 0);

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
    signal MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Zero, MEM_DisplayEnable : std_logic;
    signal MEM_Rd, MEM_RegtoW : std_logic_vector(1 downto 0);
    signal MEM_BeqAddress, MEM_ALUOut, MEM_WriteData : std_logic_vector(15 downto 0);
    -- created during MEM
    signal MEM_ReadData : std_logic_vector(15 downto 0);

    -- WB Declarations
    -- coming from MEM
    signal WB_MemtoReg, WB_RegWrite, WB_DisplayEnable : std_logic;
    signal WB_Rd, WB_RegtoW : std_logic_vector(1 downto 0);
    signal WB_ALUOut, WB_ReadData : std_logic_vector(15 downto 0);
    -- created during WB
    signal WB_Data : std_logic_vector(15 downto 0);

begin
    
    Clk: Clk_Enlarger port map (
        GlobalClk => clk_in;
        LocalClk => clk_out;
    );

    -- IF
    IF_NewPC <= IF_CurrPC + 4;

    PC: PC port map (
        LocalClk => clk;
        MEM_Branch => MEM_Branch;
        MEM_Zero => MEM_Zero;
        ID_PCWrite => PCWrite;
        MEM_BeqAddress => MEM_BeqAddress;
        IF_NewPC => NewPC;
        IF_CurrPC => CurrPC;
    );

    InstMem: IM port map (
        LocalClk => clk;
        IF_CurrPC => CurrPC_out;
        IF_Instruction => Instruction;
    );
    
    Reg_IF_ID: process(LocalClk)
    begin 
        if (rising_edge(LocalClk) and IF_ID_Write = '1') then
            ID_Instruction <= IF_Instruction;
            ID_NewPC <= IF_NewPC;
        end if;
    end process;

    -- ID
    HazardUnit: HazardDetectionUnit port map (
        EX_MemRead => EX_MemRead;
        EX_Zero => zero;
        EX_Rd => EX_Rd;
        ID_Instruction => ID_Instruction;
        ID_PCWrite => PCWrite;
        IF_ID_Write => IF_ID_Write;
        ID_Flush => Flush;
    );
    
    ID_OPCode <= ID_Instruction(15 downto 13);
    ID_Rs <= ID_Instruction(12 downto 11);
    ID_Rt <= ID_Instruction(10 downto 9);
    ID_Rd <= ID_Instruction(8 downto 7);
    ID_Func <= ID_Instruction(2 downto 0);
	ID_Shamt <= ID_Instruction(6 downto 3);
    process(ID_Instruction)
    begin
        if (ID_Instruction(8 downto 8) = "0") then -- se imediato era positivo 
            ID_ExtendedImm <= ("0000000" & ID_Instruction(8 downto 0));
        else
            ID_ExtendedImm <= ("1111111" & ID_Instruction(8 downto 0));
        end if;
    end process;

    ControlUnit: ControlUnit port map (
        ID_OPCode => OPCode;
        ID_MemRead => MemRead;
        ID_MemWrite => MemWrite;
        ID_MemtoReg => MemtoReg;
        ID_RegWrite => RegWrite;
        ID_RegDest => RegDest;
        ID_Branch => Branch;
        ID_ALUSrc => ALUSrc;
        ID_DisplayEnable => DisplayEnable;
        ID_ALUOp => ALUOp;
    ):
    
    RegBank: RegisterBank port map (
        ID_Rs => Rs;
        ID_Rt => Rt;
        WB_Rd => Rd;
        WB_Data => Data;
        WB_RegWrite => RegWrite;
        LocalClk => clk;
        ID_RegA => DataA;
        ID_RegB => DataB;
    );

    Reg_ID_EX: process(LocalClk)
    begin 
        if (rising_edge(LocalClk) and ID_Flush = '0') then
            EX_MemRead <= ID_MemRead;
            EX_MemWrite <= ID_MemWrite;
            EX_MemtoReg <= ID_MemtoReg;
            EX_RegWrite <= ID_RegWrite;
            EX_RegDest <= ID_RegDest;
            EX_Branch <= ID_Branch;
            EX_ALUSrc <= ID_ALUSrc;
            EX_DisplayEnable <= ID_DisplayEnable;
            EX_Rs <= ID_Rs;
            EX_Rt <= ID_Rt;
            EX_Rd <= ID_Rd;
            EX_Func <= ID_Func;
            EX_Shamt <= ID_Shamt;
            EX_RegA <= ID_RegA;
            EX_RegB <= ID_RegB;
            EX_NewPC <= ID_NewPC;
            EX_ExtendedImm <= ID_ExtendedImm;
        elsif (rising_edge(LocalClk) and (ID_Flush = '1')) then
            EX_MemRead <= '0';
            EX_MemWrite <= '0';
            EX_MemtoReg <= '0';
            EX_RegWrite <= '0';
            EX_RegDest <= '0';
            EX_Branch <= '0';
            EX_ALUSrc <= '0';
            EX_DisplayEnable <= '0';
            EX_Rs <= ID_Rs;
            EX_Rt <= ID_Rt;
            EX_Rd <= ID_Rd;
            EX_Func <= ID_Func;
            EX_Shamt <= ID_Shamt;
            EX_RegA <= ID_RegA;
            EX_RegB <= ID_RegB;
            EX_NewPC <= ID_NewPC;
            EX_ExtendedImm <= ID_ExtendedImm;
        end if;
    end process;

    -- EX
	


    -- MEM
	data_mem: data_memory port map (
		LocalClk => clk;
		MEM_MemRead => MemRead;	--sinal para ler da mem
		EX_MemWrite => MemWrite;	--sinal para escrever na mem
		MEM_WriteData => WriteData;	--o dado a ser escrito
		MEM_ALUOut => ALUOut;	--endereco de memoria
		MEM_ReadData => ReadData;	--dado lido da memoria
	);

	Reg_MEM_WB: process(LocalClk)
	begin 
		if (rising_edge(LocalClk)) then
			WB_MemtoReg <= MEM_MemtoReg;
			WB_RegtoW <= MEM_RegtoW; ----------APAGAR???????
			WB_RegWrite <= MEM_RegWrite;
			WB_ReadData <= ReadData;
			wb_ALUOut <= MEM_ALUOut;
			WB_Rd <= MEM_Rd;
			WB_DisplayEnable <= MEM_DisplayEnable;
			WB_DisplayData <= MEM_DisplayData; ------------DECLARAAAAAAAAAAAAR -----------------
		end if;
	end process;
    -- WB
--sinal do display sai dessa fase 
	Display: display port map (
		LocalClk => clk;
		WB_DisplayEnable => DisplayEnable;
		WB_DisplayData => DisplayData;
		----FALTA COISAAAAAAAAAAAAA
	);

	--mux para escolher o dado a ser escrito no banco de registradores
	WB_Data <= WB_ReadData when WB_MemtoReg = '1' else WB_ALUOut;

	RegisterBank: register_bank port map (
		
	);

end Behavioral;
    -- exemplo de como pegar dado do registrador
    --R_EXE_MEM; EX_MEM port map (
    --     EX_BeqAddres => BeqAdress;
    ---    sinal fora do componente => sinal dentro do componente
    --);
