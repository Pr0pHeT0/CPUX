library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPU is 
    port
    (
        clk : STD_LOGIC;
        ram_oe : STD_LOGIC;
        ram_rw : STD_LOGIC;
        ram_en : STD_LOGIC;        
        ram_data : STD_LOGIC_VECTOR(15 downto 0);
        ram_addr : STD_LOGIC_VECTOR(17 downto 0);
        --sw : STD_LOGIC_VECTOR(15 downto 0);
        --led : STD_LOGIC_VECTOR(15 downto 0);     
    );
end CPU;

architecture Behavioral of CPU is
    signal clkl : in  STD_LOGIC;
    signal alu_srcAl : in std_logic_vector(15 downto 0);
    signal alu_srcBl : in std_logic_vector(15 downto 0);
    signal alu_outl : out std_logic_vector(15 downto 0);
    signal alu_opl : in std_logic_vector(2 downto 0);
    signal rstl:in STD_LOGIC;
    signal clkl:in STD_LOGIC;
    signal clk0l:in STD_LOGIC;
    signal instructionsl:in STD_LOGIC_VECTOR(15 downto 0);
    signal lightl:out STD_LOGIC_VECTOR(15 downto 0);
    signal showCtrll:in STD_LOGIC;
    signal bZero_ctrll:in  STD_LOGIC;
    signal clkl : in  STD_LOGIC;
    signal pc_inl : in std_logic_vector(15 downto 0);
    signal pc_writel : in std_logic;
    signal pc_outl : out std_logic_vector(15 downto 0);
    signal clkl : in  STD_LOGIC;		
    signal mem_enl : out  STD_LOGIC;
    signal mem_oel : out  STD_LOGIC;
    signal mem_rwl : out  STD_LOGIC;
    signal mem_addrl : out  STD_LOGIC_VECTOR (17 downto 0);
    signal mem_datal : inout  STD_LOGIC_VECTOR (15 downto 0);
    signal mem_write_datal: in std_logic_vector(15 downto 0);
    signal mem_read_datal: out std_logic_vector(15 downto 0);
    signal mem_addr_rwl: in std_logic_vector(15 downto 0);
    signal IR_Writel : in std_logic;		
    signal mem_readl : in std_logic;
    signal mem_writel : in std_logic;
    signal clkl : in  STD_LOGIC;
    signal IR_inl : in std_logic_vector(15 downto 0);
    signal IR_writel : in std_logic;           
    signal IR_outl : out std_logic_vector(15 downto 0);
    signal clkl : in  STD_LOGIC;
    signal DR_inl : in std_logic_vector(15 downto 0);
    signal DR_writel : in std_logic;           
    signal DR_outl : out std_logic_vector(15 downto 0)
    signal clkl: in std_logic;
    signal reg_num_1l: in std_logic_vector(3 downto 0);
    signal reg_num_2l: in std_logic_vector(3 downto 0);
    signal reg_write_numl: in std_logic_vector(3 downto 0) := "0000";
    signal reg_write_datal: in std_logic_vector(15 downto 0);
    signal write_oel: in std_logic := '0';
    signal reg_data_1l: out std_logic_vector(15 downto 0);
    signal reg_data_2l: out std_logic_vector(15 downto 0)
    signal pcoutl: in std_logic_vector(15 downto 0);
    signal Al: in std_logic_vector(15 downto 0);
    signal mux_op_al: in std_logic;
    signal outsrc_al: out std_logic_vector(15 downto 0);
    signal Bl: in std_logic_vector(15 downto 0);
    --con1: in std_logic_vector(15 downto 0):="0000000000000001";
    signal lowl: in std_logic_vector(15 downto 0);
    --con0: in std_logic_vector(15 downto 0):="0000000000000000";
    signal mux_op_bl: in std_logic_vector(1 downto 0);
    signal outsrc_bl: out std_logic_vector(15 downto 0)
    signal aluoutl: in std_logic_vector(15 downto 0);
    signal mdrl: in std_logic_vector(15 downto 0);
    signal mux_op_ml: in std_logic_vector(1 downto 0);
    signal outsrc_ml: out std_logic_vector(15 downto 0);
    signal alul: in std_logic_vector(15 downto 0);
    signal aluoutl: in std_logic_vector(15 downto 0);
    signal mux_op_pl: in std_logic;
    signal outsrcl_p: out std_logic_vector(15 downto 0)
    signal rxl: in std_logic_vector(15 downto 0);
    signal ryl: in std_logic_vector(15 downto 0);
    signal rzl: in std_logic_vector(15 downto 0);
    signal mux_op_rl: in std_logic_vector(1 downto 0);
    signal outsrc_rl: out std_logic_vector(15 downto 0)


component ALU
    Port 
    (   
        clk : in  STD_LOGIC;
        alu_srcA : in std_logic_vector(15 downto 0);
        alu_srcB : in std_logic_vector(15 downto 0);
        alu_out : out std_logic_vector(15 downto 0);
        alu_op : in std_logic_vector(2 downto 0)
    );
end component;

component CONTROLER
    Port 
    (   
        rst:in STD_LOGIC;
		clk:in STD_LOGIC;
		clk0:in STD_LOGIC;
		instructions:in STD_LOGIC_VECTOR(15 downto 0);
		light:out STD_LOGIC_VECTOR(15 downto 0);
		showCtrl:in STD_LOGIC;
		bZero_ctrl:in  STD_LOGIC
    );
end component;

component PC
    Port 
    (   
        clk : in  STD_LOGIC;
        pc_in : in std_logic_vector(15 downto 0);
        pc_write : in std_logic;
        pc_out : out std_logic_vector(15 downto 0)
    );
end component;


component mem
    Port 
    (   
		clk : in  STD_LOGIC;		
		mem_en : out  STD_LOGIC;
		mem_oe : out  STD_LOGIC;
		mem_rw : out  STD_LOGIC;
		mem_addr : out  STD_LOGIC_VECTOR (17 downto 0);
		mem_data : inout  STD_LOGIC_VECTOR (15 downto 0);
		mem_write_data: in std_logic_vector(15 downto 0);
		mem_read_data: out std_logic_vector(15 downto 0);
		mem_addr_rw: in std_logic_vector(15 downto 0);
		IR_Write : in std_logic;		
		mem_read : in std_logic;
		mem_write : in std_logic
    );
end component;


component IR
    Port 
    (   
        clk : in  STD_LOGIC;
        IR_in : in std_logic_vector(15 downto 0);
        IR_write : in std_logic;           
        IR_out : out std_logic_vector(15 downto 0)
    );
end component;


component DR
    Port 
    (   
        clk : in  STD_LOGIC;
        DR_in : in std_logic_vector(15 downto 0);
        DR_write : in std_logic;           
        DR_out : out std_logic_vector(15 downto 0)
    );
end component;


component REG
    Port 
    (   
        clk: in std_logic;
        reg_num_1: in std_logic_vector(3 downto 0);
        reg_num_2: in std_logic_vector(3 downto 0);
        reg_write_num: in std_logic_vector(3 downto 0) := "0000";
        reg_write_data: in std_logic_vector(15 downto 0);
        write_oe: in std_logic := '0';
        reg_data_1: out std_logic_vector(15 downto 0);
        reg_data_2: out std_logic_vector(15 downto 0)
    );
end component;


component muxalusrca
    Port 
    (   
        pcout: in std_logic_vector(15 downto 0);
        A: in std_logic_vector(15 downto 0);
        mux_op: in std_logic;
        outsrc: out std_logic_vector(15 downto 0)
    );
end component;


component muxalusrcb
    Port 
    (   
        B: in std_logic_vector(15 downto 0);
        --con1: in std_logic_vector(15 downto 0):="0000000000000001";
        low: in std_logic_vector(15 downto 0);
        --con0: in std_logic_vector(15 downto 0):="0000000000000000";
        mux_op: in std_logic_vector(1 downto 0);
        outsrc: out std_logic_vector(15 downto 0)
    );
end component;

component muxmemtoreg
    Port 
    (   
        aluout: in std_logic_vector(15 downto 0);
        mdr: in std_logic_vector(15 downto 0);
        mux_op: in std_logic_vector(1 downto 0);
        outsrc: out std_logic_vector(15 downto 0)
    );
end component;


component muxpcsource
    Port 
    (   
        alu: in std_logic_vector(15 downto 0);
        aluout: in std_logic_vector(15 downto 0);
        mux_op: in std_logic;
        outsrc: out std_logic_vector(15 downto 0)
    );
end component;


component muxregdst
    Port 
    (   
        rx: in std_logic_vector(15 downto 0);
        ry: in std_logic_vector(15 downto 0);
        rz: in std_logic_vector(15 downto 0);
        mux_op: in std_logic_vector(1 downto 0);
        outsrc: out std_logic_vector(15 downto 0)
    );
end component;


begin

module_PC : PC port map(
    clk => clkl;
    pc_in => pc_inl;
    pc_write => pc_writel;
    pc_out => pc_outl
);

module_ALU : ALU port map(
    clk => clkl;
    alu_srcA => alu_srcAl;
    alu_srcB => alu_srcBl;
    alu_out => alu_outl;
    alu_op => alu_opl
);

module_CONTROLER : CONTROLER port map(
    rst => rstl;
    clk => clkl;
    clk0 => clk0l;
    instructions => instructionsl;
    light => lightl;
    showCtrl => showCtrll;
    bZero_ctrl => bZero_ctrl
);
module_muxalusrca : muxalusrca  port map(
    pcout=>pcoutl;
    A=>Al;
    mux_op_a=>mux_op_al;
    outsrc_a=>outsrc_al
);

module_muxalusrcb : muxalusrcb  port map(
    B=>Bl;
    low=>lowl;
    mux_op_b=>mux_op_bl;
    outsrc_b=>outsrc_bl
);

module_muxmemtoreg : muxmemtoreg  port map(
    aluout=>aluoutl;
    mdr=>mdrl;
    mux_op_m=>mux_op_ml;
    outsrc_m=>outsrc_ml
);

module_muxpcsource : muxpcsource  port map(
    alu=>alul;
    aluout=>aluoutl;
    mux_op_p=>mux_op_pl;
    outsrc_p=>outsrc_pl
);

module_muxregdst : muxregdst  port map(
    rx=>rxl;
    ry=>ryl;
    rz=>rzl;
    mux_op_r=>mux_op_rl;
    outsrc_r=>outsrc_rl
);

module_REG : REG  port map(
    clk=>clkl;
    reg_num_1=>reg_num_1l;
    reg_num_2=>reg_num_2l;
    reg_write_num=>reg_write_numl;
    reg_write_data=>reg_write_datal;
    write_oe=>write_oel;
    reg_data_1=>reg_data_1l;
    reg_data_2=>reg_data_2l
);

module_IR : IR  port map(
    clk=>clkl;
    IR_in=>IR_inl;
    IR_write=>IR_writel;
    IR_out=>IR_outl
);

module_DR : DR  port map(
    clk=>clkl;
    DR_in=>DR_inl;
    DR_write=>DR_writel;
    DR_out=>DR_outl
);

module_mem : mem port map(
    clk => clkl;
    mem_en => mem_enl;
    mem_oe => mem_oel;
    mem_rw => mem_rwl;
    mem_addr => mem_addrl;
    mem_data => mem_datal;
    mem_write_data => mem_write_datal;
    mem_read_data => mem_read_datal;
    mem_addr_rw => mem_addr_rwl;
    IR_Write => IR_Writel;
    mem_read => mem_readl;
    mem_write => mem_writel
);

end Behavioral;