library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Import necessary libraries, with STD_LOGIC and it's vector type support

entity mem is
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
end mem;

signal signal_mem_read_data : std_logic_vector(15 downto 0);

architecture Behavioral of mem is
	signal status:std_logic_vector(2 downto 0):="000";
	-- signal ct :STD_LOGIC_VECTOR (15 downto 0);
	-- signal ram_a :STD_LOGIC_VECTOR (15 downto 0);
begin
process(mem_write_data,mem_read,mem_write)
	-- variable status:std_logic_vector(2 downto 0):="000";
	variable data :STD_LOGIC_VECTOR (15 downto 0);
	variable address :STD_LOGIC_VECTOR (17 downto 0);
begin	
	data := mem_write_data;
	address(17 downto 0) := "00" & mem_addr_rw(15 downto 0);
	-- address(17 downto 0) :="000000000000000101";
	if(clk'event and clk='1') then
		if mem_read='0' then
			status<=status+'1';
				if(status="001")then
					mem_data<="ZZZZZZZZZZZZZZZZ";
				elsif(status="010")then                       
					mem_oe<='0';
				elsif(status="011")then
					mem_addr<=address;
					mem_read_data<=mem_data;
					status<="000";
				end if;			
		end if;
		if mem_write='0' then
				status<=status+'1';			
				if(status="001")then
					mem_addr<=address;
				elsif(status="010")then
					mem_data<=data; 
				elsif(status="011")then     
					mem_oe<='1';
					mem_rw<='0'; 
					mem_en<='0';
				elsif(status="100")then     
					mem_oe<='1';
					mem_rw<='1'; 
					mem_en<='0'; 
					status<="000";
				end if;
		end if;
	end if;
end process;
end Behavioral;

