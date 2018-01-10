library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CPU is 
    port
    (
        clk : STD_LOGIC
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

signal bzero:std_logic;
type shower_state is(PC,ALU,Mem,Reg);
signal shower : shower_state ;
type controcer_state is(instruction_fetch,decode,execute,mem_control,write_reg);
signal state : controcer_state;
signal PCWrite:std_logic;
signal PCWriteCond:std_logic;
signal PCSource:std_logic;
signal ALUop:std_logic_vector(2 downto 0);
signal ALUSrcA:std_logic;
signal ALUSrcB:std_logic_vector(1 downto 0);
signal MemRead:std_logic;
signal MemWrite:std_logic;
signal IRWrite:std_logic;
signal MemtoReg:std_logic_vector(1 downto 0);
signal RegWrite:std_logic_vector(2 downto 0);
signal RegDst:std_logic_vector(1 downto 0);
signal IorD:std_logic;
signal tmpb_zero:std_logic;
signal tmp_light:std_logic_vector(15 downto 0);
signal r0: std_logic_vector(15 downto 0) := "0000000000000000";
signal r1: std_logic_vector(15 downto 0) := "0000000000000000";
signal r2: std_logic_vector(15 downto 0) := "0000000000000000";
signal r3: std_logic_vector(15 downto 0) := "0000000000000000";
signal r4: std_logic_vector(15 downto 0) := "0000000000000000";
signal r5: std_logic_vector(15 downto 0) := "0000000000000000";
signal r6: std_logic_vector(15 downto 0) := "0000000000000000";
signal r7: std_logic_vector(15 downto 0) := "0000000000000000";
signal RA: std_logic_vector(15 downto 0) := "0000000000000000";
signal T: std_logic_vector(15 downto 0) := "0000000000000000";
signal SP: std_logic_vector(15 downto 0) := "0000000000000000";
signal IH: std_logic_vector(15 downto 0) := "0000000000000000";
signal con1: in std_logic_vector(15 downto 0):="0000000000000001";
signal con0: in std_logic_vector(15 downto 0):="0000000000000000";