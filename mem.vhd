library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Import necessary libraries, with STD_LOGIC and it's vector type suport

entity mem is
	port
	(
		clk: in std_logic;
		-- clock50 is 50MHz crystal on board sb
		--clk: in std_logic;
		-- clk is the clock button on board(per-step clock source)
		--led: out std_logic_vector(0 to 15);
		-- led_debug is LED x16 on board for debugging
		mem_en: out std_logic;
		-- mem_en is the enable signal of memory #1 on board
		mem_oe: out std_logic;
		-- mem_oe is the output enable signal of memory #1 on board
		mem_rw: out std_logic;
		-- mem_rw is the read/write controller signal of memory #1 on board
		mem_write: in std_logic;

		IR_Write : in std_logic;

		mem_read: in std_logic;
	
		mem_addr: out std_logic_vector(17 downto 0);
		-- mem_addr is the address bus with little endian of memory #1 on board
		mem_data: inout std_logic_vector(15 downto 0);
		-- mem_data is the data bus with little endian and inout support of memory #1 on board
		mem_write_data: in std_logic_vector(15 downto 0);

		mem_read_data: out std_logic_vector(15 downto 0);

		mem_addr_rw: in std_logic_vector(15 downto 0)
	);
end mem;

entity test is
    Port ( clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
			  clk0 : in STD_LOGIC;
           ram_data1 : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram_data2 : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram1_en : out  STD_LOGIC;
           ram1_oe : out  STD_LOGIC;
           ram1_rw : out  STD_LOGIC;
           ram2_en : out  STD_LOGIC;
           ram2_oe : out  STD_LOGIC;
           ram2_rw : out  STD_LOGIC;
           light : out  STD_LOGIC_VECTOR (15 downto 0);
			  showCtrl : in std_logic;
			  bZero_Ctrl : in std_logic;
           ram_addr1 : out  STD_LOGIC_VECTOR (15 downto 0);
           ram_addr2 : out  STD_LOGIC_VECTOR (17 downto 0);
           seg_l : out  STD_LOGIC_VECTOR (6 downto 0);
           seg_r : out  STD_LOGIC_VECTOR (6 downto 0);
			IR_in: in STD_LOGIC_VECTOR(15 downto 0);
			IR_out: out STD_LOGIC_VECTOR(15 downto 0);
			IRWrite : in std_logic;
			  SW:in STD_LOGIC_VECTOR(15 downto 0);
			inputA : in  STD_LOGIC_VECTOR (15 downto 0);
		--	inputB : in  STD_LOGIC_VECTOR (15 downto 0);
			ALUOp : in  STD_LOGIC_VECTOR (2 downto 0);
			Memory_in: in STD_LOGIC_VECTOR(15 downto 0);
			Memory_in_data: in STD_LOGIC_VECTOR(15 downto 0);
			Memory_out: out STD_LOGIC_VECTOR(15 downto 0);
			MemRead : in std_logic;
			MemWrite : in std_logic;
			result : out STD_LOGIC_VECTOR (15 downto 0)
);
end test;

architecture Behavioral of test is
signal cnt:std_logic_vector(4 downto 0):="00000";
signal ct :STD_LOGIC_VECTOR (15 downto 0);
signal ram_a :STD_LOGIC_VECTOR (15 downto 0);
begin
process(Memory_in_data,MemRead,MemWrite)
begin
ct<="0000000000000001";
	if(clk'event and clk='1') then
		if Memread='0' then
			cnt<=cnt+'1';
				if(cnt="00001")then
					ram_data1<="ZZZZZZZZZZZZZZZZ";
				elsif(cnt="00010")then                           -----------------??ALUout???
					ram1_oe<='0';
				elsif(cnt="00011")then
					ram_a<="0000000000000001";
					light<=ram_data1;
	--				Memory_out<=ram_data1;
					cnt<="00000";
				end if;			
		end if;
		if MemWrite='0' then
				cnt<=cnt+'1';			
				if(cnt="00001")then
					ram_a<=ct;
				elsif(cnt="00010")then
					ram_data1<=Memory_in_data; ---------------R ?ALU?��?????????????????SW???
				elsif(cnt="00011")then     
					ram1_oe<='1';
					ram1_rw<='0'; 
					ram1_en<='0';
				elsif(cnt="00100")then     
					ram1_oe<='1';
					ram1_rw<='1'; 
					ram1_en<='0'; 
					cnt<="00000";
				end if;
		end if;
	end  if;
ram_addr1(15 downto 0)<=ram_a;
end process;
end Behavioral;

