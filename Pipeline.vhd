library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity Pipeline is 
    port (
        GlobalClk: in std_logic;
        dsp0, dsp1, dsp2, dsp3 : out std_logic_vector(6 downto 0)
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
        EX_MemRead, MEM_Zero, MEM_Branch	: in std_logic;
        EX_Rd								: in std_logic_vector(1 downto 0);
        ID_Instruction						: in std_logic_vector(15 downto 0);
        PCWrite, IF_ID_Write, Flush 		: out std_logic
    );
    end component;

    component forwarding_unit is port(
        MEM_RegWrite, WB_RegWrite               : in std_logic;
        EX_Rs, EX_Rt, MEM_Rd, WB_Rd             : in std_logic_vector(1 downto 0);

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
        RFonteA, RFonteB, RDest              : in std_logic_vector(1 downto 0);
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
        Char2, Char3            : out std_logic_vector(6 downto 0)
    );
    end component;

    component calc_BeqAddress is port(
        EX_NewPC, EX_extended_imm		: in std_logic_vector(15 downto 0);
        BeqAddress				: out std_logic_vector(15 downto 0)
    );
    end component;
    
    signal LocalClk : std_logic;
    
    -- IF Declarations
    signal IF_CurrPC, IF_NewPC, IF_Instruction : std_logic_vector(15 downto 0) := (others => '0');
    -- PCsrc nn existe mais, eh s passar Branch e Zero que vem do MEM
    --NewPC eh PC+1

    -- ID Declarations
    -- coming from IF
    signal ID_Instruction, ID_NewPC : std_logic_vector(15 downto 0) := (others => '0');
    -- created during ID
    signal ID_Flush, ID_MemRead, ID_MemWrite, ID_MemtoReg, ID_RegWrite, ID_RegDest, ID_Branch, ID_ALUSrc, ID_DisplayEnable : std_logic := '0';
    signal ID_PCWrite, IF_ID_Write : std_logic := '1';
    signal ID_Rs, ID_Rt, ID_Rd	: std_logic_vector(1 downto 0) := (others => '0');
    signal ID_OPCode, ID_Func, ID_ALUOp : std_logic_vector(2 downto 0) := (others => '0');
	signal ID_Shamt : std_logic_vector(3 downto 0) := (others => '0');
    signal ID_RegA, ID_RegB, ID_ExtendedImm : std_logic_vector(15 downto 0) := (others => '0');

    -- EX Declarations
    -- coming from ID
    signal EX_MemRead, EX_MemWrite, EX_MemtoReg, EX_RegWrite, EX_RegDest, EX_Branch, EX_ALUSrc, EX_DisplayEnable : std_logic := '0';
    signal EX_Rs, EX_Rt, EX_Rd	: std_logic_vector(1 downto 0) := (others => '0');
    signal EX_Func, EX_ALUOp : std_logic_vector(2 downto 0) := (others => '0');
	signal EX_Shamt : std_logic_vector(3 downto 0) := (others => '0');
    signal EX_RegA, EX_RegB, EX_NewPC, EX_ExtendedImm : std_logic_vector(15 downto 0) := (others => '0');
    -- created during EX
    signal EX_Zero : std_logic := '0';
    signal EX_ForwardA, EX_ForwardB, EX_RegtoW: std_logic_vector(1 downto 0) := (others => '0');
    signal EX_ALUControlOut : std_logic_vector(2 downto 0) := (others => '0');  
    signal EX_ALUOut, EX_BeqAddress, EX_Data_a, EX_Data_b, EX_WriteData : std_logic_vector(15 downto 0) := (others => '0');

    -- MEM Declarations
    -- coming from EX  --WriteData eh DadoB
    signal MEM_MemRead, MEM_MemWrite, MEM_MemtoReg, MEM_RegWrite, MEM_Branch, MEM_Zero, MEM_DisplayEnable : std_logic := '0';
    signal MEM_RegtoW: std_logic_vector(1 downto 0) := (others => '0');
    signal MEM_BeqAddress, MEM_ALUOut, MEM_WriteData : std_logic_vector(15 downto 0) := (others => '0');
    -- created during MEM
    signal MEM_ReadData : std_logic_vector(15 downto 0) := (others => '0');

    -- WB Declarations
    -- coming from MEM
    signal WB_MemtoReg, WB_RegWrite, WB_DisplayEnable : std_logic := '0';
    signal WB_RegtoW: std_logic_vector(1 downto 0) := (others => '0');
    signal WB_ALUOut, WB_ReadData : std_logic_vector(15 downto 0) := (others => '0');
    -- created during WB
    signal WB_Data, WB_DisplayData : std_logic_vector(15 downto 0) := (others => '0');
begin	
    -- Arrumando clk para o tamanho certo
    -- Clk: Clk_Enlarger port map (
    --     clk_in => GlobalClk,
    --     clk_out => LocalClk
    -- );
    -- Para simulacao dentro do ISE
    LocalClk <= GlobalClk;

-- #####################################################################
-- 				IF
-- #####################################################################
    -- como a memória é um array de 16 bits, acessamos diretamente a palavra
    IF_NewPC <= IF_CurrPC + x"0001";

    PC_label: PC port map (
        clk => LocalClk,
        MEM_Branch => MEM_Branch,
        MEM_Zero => MEM_Zero,
        PCWrite => ID_PCWrite,
        MEM_BeqAddress => MEM_BeqAddress,
        NewPC => IF_NewPC,
        CurrPC => IF_CurrPC
    );

    InstMem: IM port map (
        clk => LocalClk,
        CurrPC_out => IF_CurrPC,
        Instruction => IF_Instruction
    );
    
    Reg_IF_ID: process(LocalClk)
    begin 
        if (rising_edge(LocalClk)) then
            if ID_Flush = '1' then
                ID_Instruction <= x"0000";
            elsif IF_ID_Write = '1' then
                ID_Instruction <= IF_Instruction;
                ID_NewPC <= IF_NewPC;
            else
                ID_Instruction <= ID_Instruction;
                ID_NewPC <= ID_NewPC;
            end if;
        end if;
    end process;

-- #####################################################################
-- 				ID
-- #####################################################################
    HazardUnit: HazardDetectionUnit port map (
        EX_MemRead => EX_MemRead,
        MEM_Zero => MEM_Zero,
        MEM_Branch => MEM_Branch,
        EX_Rd => EX_Rd,
        ID_Instruction => ID_Instruction,
        PCWrite => ID_PCWrite,
        IF_ID_Write => IF_ID_Write,
        Flush => ID_Flush
    );
    
    ID_OPCode <= ID_Instruction(15 downto 13);
    ID_Rs <= ID_Instruction(12 downto 11);
    ID_Rt <= ID_Instruction(10 downto 9);
    ID_Rd <= ID_Instruction(8 downto 7);
	ID_Shamt <= ID_Instruction(6 downto 3);
    ID_Func <= ID_Instruction(2 downto 0);

    -- estender imediato
    with ID_Instruction(8) select ID_ExtendedImm <=
        "0000000" & ID_Instruction(8 downto 0) when '0',
        "1111111" & ID_Instruction(8 downto 0) when '1';
        
    ControlUnit_label: ControlUnit port map (
        OPCode => ID_OPCode,
        MemRead => ID_MemRead,
        MemWrite => ID_MemWrite,
        MemtoReg => ID_MemtoReg,
        RegWrite => ID_RegWrite,
        RegDest => ID_RegDest,
        Branch => ID_Branch,
        ALUSrc => ID_ALUSrc,
        DisplayEnable => ID_DisplayEnable,
        ALUOp => ID_ALUOp
    );
    
    RegBank: RegisterBank port map (
        RFonteA => ID_Rs,
        RFonteB => ID_Rt,
        RDest => WB_RegtoW,
        Data => WB_Data,
        RegWrite => WB_RegWrite,
        clk => LocalClk,
        DataA => ID_RegA,
        DataB => ID_RegB
    );

    Reg_ID_EX: process(LocalClk)
    begin 
        if (rising_edge(LocalClk)) then
            if ID_Flush = '1' then
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
                EX_ALUOp <= ID_ALUOp;
                EX_Func <= ID_Func;
                EX_Shamt <= ID_Shamt;
                EX_RegA <= ID_RegA;
                EX_RegB <= ID_RegB;
                EX_NewPC <= ID_NewPC;
                EX_ExtendedImm <= ID_ExtendedImm;
            else
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
                EX_ALUOp <= ID_ALUOp;
                EX_Func <= ID_Func;
                EX_Shamt <= ID_Shamt;
                EX_RegA <= ID_RegA;
                EX_RegB <= ID_RegB;
                EX_NewPC <= ID_NewPC;
                EX_ExtendedImm <= ID_ExtendedImm;
            end if;
        end if;
    end process;
-- #####################################################################
-- 				EX
-- #####################################################################
	forwarding_unit_label: forwarding_unit port map (
		EX_Rs => EX_Rs,
		EX_Rt => EX_Rt,
		MEM_RegWrite => MEM_RegWrite,
		MEM_Rd => MEM_RegtoW,
		WB_RegWrite => WB_RegWrite,
		WB_Rd => WB_RegtoW,
		forwardA => EX_ForwardA,
		forwardB => EX_ForwardB
	); 

	-- mux do registrador de escrita
	EX_RegtoW <= EX_Rt when EX_RegDest = '0' else EX_Rd;

	-- mux primeiro operando da ALU
	EX_Data_a <= EX_RegA    when EX_ForwardA = "00" else
		         MEM_ALUOut when EX_ForwardA = "01" else
		         WB_ALUOut  when EX_ForwardA = "10" else
		         x"0000";

	-- mux segundo operando da ALU
	EX_WriteData <= EX_RegB    when EX_ForwardB = "00" else
		            MEM_ALUOut when EX_ForwardB = "01" else
		            WB_ALUOut  when EX_ForwardB = "10" else
		            x"0000";

    -- outro mux do segundo operando da ALU
	EX_Data_b <= EX_WriteData when EX_ALUSrc = '0' else
		         EX_ExtendedImm;
	
	ALUControl_label: ALUControl port map (
		EX_Func => EX_Func,
		EX_ALUOp => EX_ALUOp,
		ALUControlOut => EX_ALUControlOut
	);

	ALU_label: ALU port map (
		Data_a => EX_Data_a,
		Data_b => EX_Data_b,
		ALUControlOut => EX_ALUControlOut,
		ALUOut => EX_ALUOut,
		Zero => EX_Zero,
		EX_Shamt => EX_Shamt
	);

	calc_BeqAddress_label: calc_BeqAddress port map (
		EX_NewPC => EX_NewPC,
		EX_extended_imm => EX_ExtendedImm,
		BeqAddress => EX_BeqAddress
	);

	Reg_EX_MEM: process(LocalClk)
	begin
		if (rising_edge(LocalClk)) then
            if ID_Flush = '1' then
                MEM_MemRead <= '0';
                MEM_MemWrite <= '0';
                MEM_MemtoReg <= '0';
                MEM_RegWrite <= '0';
                MEM_RegtoW <= "00";
                MEM_ALUOut <= x"0000";
                MEM_BeqAddress <= x"0000";
                MEM_Zero <= '0';
                MEM_DisplayEnable <= '0';
                MEM_Branch <= '0';
                MEM_WriteData <= x"0000";
            else
                MEM_MemRead <= EX_MemRead;
                MEM_MemWrite <= EX_MemWrite;
                MEM_MemtoReg <= EX_MemtoReg;
                MEM_RegWrite <= EX_RegWrite;
                MEM_RegtoW <= EX_RegtoW;
                MEM_ALUOut <= EX_ALUOut;
                MEM_BeqAddress <= EX_BeqAddress;
                MEM_Zero <= EX_Zero;
                MEM_DisplayEnable <= EX_DisplayEnable;
                MEM_Branch <= EX_Branch;
                MEM_WriteData <= EX_WriteData;
            end if;
		end if;
	end process;

-- #####################################################################
-- 				MEM
-- #####################################################################
	data_mem_label: data_mem port map (
		clk => LocalClk,
		MemWrite => EX_MemWrite,
		MemRead => MEM_MemRead,
		WriteData => MEM_WriteData,
		ALUOut => MEM_ALUOut,
		ReadData => MEM_ReadData
	);

	Reg_MEM_WB: process(LocalClk)
	begin 
		if (rising_edge(LocalClk)) then
			WB_MemtoReg <= MEM_MemtoReg;
			WB_RegWrite <= MEM_RegWrite;
			WB_ReadData <= MEM_ReadData;
			WB_ALUOut <= MEM_ALUOut;
			WB_RegtoW <= MEM_RegtoW;
			WB_DisplayEnable <= MEM_DisplayEnable;
		end if;
	end process;


-- #####################################################################
-- 				WB
-- #####################################################################
	--sinal do display sai dessa fase 

	--mux para escolher o dado a ser escrito no banco de registradores
	WB_Data <= WB_ReadData when WB_MemtoReg = '1' else WB_ALUOut;

	WB_DisplayData <= WB_AluOut;

	Display_label: Display port map (
		clk => LocalClk,
		DisplayEnable => WB_DisplayEnable,
		Data => WB_DisplayData,
        Char0 => dsp0,
        Char1 => dsp1,
        Char2 => dsp2,
        Char3 => dsp3
	);

end Behavioral;
    -- exemplo de como pegar dado do registrador
    --R_EXE_MEM; EX_MEM port map (
    --     EX_BeqAddres => BeqAdress;
    ---    sinal fora do componente => sinal dentro do componente
    --);
