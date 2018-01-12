library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPU is 
    port
    (
        rst : STD_LOGIC;
        clk : STD_LOGIC;
        ram_oe : STD_LOGIC;
        ram_rw : STD_LOGIC;
        ram_en : STD_LOGIC;        
        ram_data : STD_LOGIC_VECTOR(15 downto 0);
        ram_addr : STD_LOGIC_VECTOR(17 downto 0)
        --sw : STD_LOGIC_VECTOR(15 downto 0);
        --led : STD_LOGIC_VECTOR(15 downto 0);     
    );
end CPU;

architecture Behavioral of CPU is


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

signal signal_alu_out : std_logic_vector(15 downto 0);

component CONTROLER
    Port 
    (   
        rst:in STD_LOGIC;
		clk:in STD_LOGIC;
		--clk0:in STD_LOGIC;
		instructions:in STD_LOGIC_VECTOR(15 downto 0);
		--light:out STD_LOGIC_VECTOR(15 downto 0);
		--showCtrl:in STD_LOGIC;
        --bZero_ctrl:in  STD_LOGIC;
        -- PCWriteCond:std_logic;
        PCWrite:out std_logic;		
		PCSource:out std_logic;
		ALUop:out std_logic_vector(2 downto 0);
		ALUSrcA:out std_logic;
		ALUSrcB:out std_logic_vector(1 downto 0);
		MemRead:out std_logic;
		MemWrite:out std_logic;
		IRWrite:out std_logic;
		MemtoReg:out std_logic_vector(1 downto 0);
		RegWrite:out std_logic_vector(2 downto 0);
		RegDst:out std_logic_vector(1 downto 0);
		IorD:out std_logic;
		rx:out std_logic_vector(2 downto 0);
		ry:out std_logic_vector(2 downto 0);
		rz:out std_logic_vector(2 downto 0);
		imme:out std_logic_vector(15 downto 0)
		--tmpb_zero:out std_logic;
		--tmp_light:out std_logic_vector(15 downto 0)
		
    );
end component;

signal signal_PCWrite : std_logic;
signal signal_IorD : std_logic;
signal signal_IRWrite : std_logic;
signal signal_MemRead : std_logic;
signal signal_MemWrite : std_logic;
signal signal_RegDst : std_logic_vector(1 downto 0);
signal signal_RegWrite : std_logic_vector(2 downto 0);
signal signal_rx : std_logic_vector(2 downto 0);
signal signal_ry : std_logic_vector(2 downto 0);
signal signal_rz : std_logic_vector(2 downto 0);
signal signal_ALUSrcA : std_logic;
signal signal_ALUSrcB : std_logic_vector(1 downto 0);
signal signal_imme : std_logic_vector(15 downto 0);
signal signal_ALUop : std_logic_vector(2 downto 0);
signal signal_PCSource : std_logic;
signal signal_MemtoReg : std_logic_vector(1 downto 0);



component PC
    Port 
    (   
        clk : in  STD_LOGIC;
        pc_in : in std_logic_vector(15 downto 0);
        pc_write : in std_logic;
        pc_out : out std_logic_vector(15 downto 0)
    );
end component;

-- signal signal_clk : STD_LOGIC;
-- signal signal_pc_in : std_logic_vector(15 downto 0);
-- signal signal_pc_write : std_logic;
signal signal_pc_out : std_logic_vector(15 downto 0);

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

signal signal_mem_read_data : std_logic_vector(15 downto 0);

component IR
    Port 
    (   
        clk : in  STD_LOGIC;
        IR_in : in std_logic_vector(15 downto 0);
        IR_write : in std_logic;           
        IR_out : out std_logic_vector(15 downto 0)
    );
end component;

signal signal_IR_out : std_logic_vector(15 downto 0);

component DR
    Port 
    (   
        clk : in  STD_LOGIC;
        DR_in : in std_logic_vector(15 downto 0);           
        DR_out : out std_logic_vector(15 downto 0)
    );
end component;

signal signal_DR_out : std_logic_vector(15 downto 0);

component RR
    Port 
    (   
        clk : in  STD_LOGIC;
        RR_in : in std_logic_vector(15 downto 0);          
        RR_out : out std_logic_vector(15 downto 0)
    );
end component;


signal signal_RR_out : std_logic_vector(15 downto 0);


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

signal signal_reg_data_1: std_logic_vector(15 downto 0);
signal signal_reg_data_2: std_logic_vector(15 downto 0);

component muxalusrca
    Port 
    (   
        pc_out_a: in std_logic_vector(15 downto 0);
        A: in std_logic_vector(15 downto 0);
        mux_op_a: in std_logic;
        outsrc_a: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_outsrc_a: std_logic_vector(15 downto 0);


component muxalusrcb
    Port 
    (   
        B: in std_logic_vector(15 downto 0);
        --con1: in std_logic_vector(15 downto 0):="0000000000000001";
        low: in std_logic_vector(15 downto 0);
        --con0: in std_logic_vector(15 downto 0):="0000000000000000";
        mux_op_b: in std_logic_vector(1 downto 0);
        outsrc_b: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_outsrc_b: std_logic_vector(15 downto 0);

component muxmemtoreg
    Port 
    (   
        aluout: in std_logic_vector(15 downto 0);
        mdr: in std_logic_vector(15 downto 0);
        mux_op_m: in std_logic_vector(1 downto 0);
        outsrc_m: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_outsrc_m : std_logic_vector(15 downto 0);

component muxpcsource
    Port 
    (   
        pc_out: in std_logic_vector(15 downto 0);
        aluout: in std_logic_vector(15 downto 0);
        mux_op_p: in std_logic;
        outsrc_p: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_outsrc_p: std_logic_vector(15 downto 0);

component muxregdst
    Port 
    (   
        rx: in std_logic_vector(15 downto 0);
        ry: in std_logic_vector(15 downto 0);
        rz: in std_logic_vector(15 downto 0);
        mux_op_r: in std_logic_vector(1 downto 0);
        outsrc_r: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_outsrc_r : std_logic_vector(15 downto 0);

component mux_IorD
    Port 
    (   
			pc_out_a: in std_logic_vector(15 downto 0);
			aluout: in std_logic_vector(15 downto 0);
			mux_op_i: in std_logic;
			outsrc_i: out std_logic_vector(15 downto 0)
    );
end component;

signal signal_aluout: std_logic_vector(15 downto 0);
signal outsrc_i: std_logic_vector(15 downto 0);
    

begin

module_PC : PC port map(
    clk => clk,
    pc_in => signal_outsrc_p,
    pc_write => signal_PCWrite,
    pc_out => signal_pc_out
);

module_mux_IorD : mux_IorD  port map(
    pc_out_a=>signal_pc_out,
    aluout=>signal_RR_out,
    mux_op_i=>signal_IorD,
    outsrc_i=>signal_outsrc_i
);

module_mem : mem port map(
    clk => clk,
    mem_en => ram_en,
    mem_oe => ram_oe,
    mem_rw => ram_rw,
    mem_addr => ram_addr,
    mem_data => ram_data,
    mem_write_data => signal_reg_data_2,
    mem_read_data => signal_mem_read_data,
    mem_addr_rw => signal_outsrc_i,
    --IR_Write => signal_IRWrite,
    mem_read => signal_MemRead,
    mem_write => signal_MemWrite
);

module_IR : IR  port map(
    clk=>clk,
    IR_in=>signal_mem_read_data,
    IR_write=>signal_IRWrite,
    IR_out=>signal_IR_out
);

module_muxregdst : muxregdst  port map(
    rx=>signal_rx,
    ry=>signal_ry,
    rz=>signal_rz,
    mux_op_r=>signal_RegDst,
    outsrc_r=>signal_outsrc_r
);

module_REG : REG  port map(
    clk=>clk,
    reg_num_1=>signal_rx,
    reg_num_2=>signal_ry,
    reg_write_num=>signal_outsrc_r,
    reg_write_data=>signal_outsrc_m,
    write_oe=>signal_RegWrite,
    reg_data_1=>signal_reg_data_1,
    reg_data_2=>signal_reg_data_2
);

module_muxalusrca : muxalusrca  port map(
    pc_out=>signal_pc_out,
    A=>signal_reg_data_1,
    mux_op_a=>signal_ALUSrcA,
    outsrc_a=>signal_outsrc_a
);


module_muxalusrcb : muxalusrcb  port map(
    B=>signal_reg_data_2,
    low=>signal_imme,
    mux_op_b=>signal_ALUSrcB,
    outsrc_b=>signal_outsrc_b
);

module_ALU : ALU port map(
    clk => clk,
    alu_srcA => signal_outsrc_a,
    alu_srcB => signal_outsrc_b,
    alu_out => signal_alu_out,
    alu_op => signal_ALUop
);

module_CONTROLER : CONTROLER port map(
    rst => rst,
    clk => clk,
    --clk0 => clk0,
    instructions => signal_IR_out,
    PCWrite => signal_PCWrite,
    PCSource => signal_PCSource,
    ALUop => signal_ALUop,
    ALUSrcA => signal_ALUSrcA,
    ALUSrcB => signal_ALUSrcB,
    MemRead => signal_MemRead,
    MemWrite => signal_MemWrite,
    IRWrite => signal_IRWrite,
    MemtoReg => signal_MemtoReg,
    RegWrite => signal_RegWrite,
    RegDst => signal_RegDst,
    IorD => signal_IorD,
    rx => signal_rx,
    ry => signal_ry,
    rz => signal_rz,
    imme => signal_imme
);

module_RR : RR  port map(
    clk => clk,
    RR_in => signal_alu_out,
    RR_out => signal_RR_out
);

module_muxpcsource : muxpcsource  port map(
    pc_out=>signal_alu_out,
    aluout=>signal_RR_out,
    mux_op_p=>signal_PCSource,
    outsrc_p=>signal_outsrc_p
);

module_muxmemtoreg : muxmemtoreg  port map(
    aluout=>signal_RR_out,
    mdr=>signal_DR_out,
    mux_op_m=>signal_MemtoReg,
    outsrc_m=>signal_outsrc_m
);


module_DR : DR  port map(
    clk=>clk,
    DR_in=>signal_outsrc_i,
    DR_out=>signal_DR_out
);



end Behavioral;