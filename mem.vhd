library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Import necessary libraries, with STD_LOGIC and it's vector type suport

entity mem is
	port
	(
		clk: in std_logic;
		-- clock50 is 50MHz crystal on board
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

		mem_read: in std_logic;
		
		sw: in std_logic_vector(15 downto 0);
		-- onboard switch
		mem_addr: out std_logic_vector(17 downto 0);
		-- mem_addr is the address bus with little endian of memory #1 on board
		mem_data: inout std_logic_vector(15 downto 0);
		-- mem_data is the data bus with little endian and inout support of memory #1 on board
		mem_write_data: in std_logic_vector(15 downto 0);

		mem_read_data: out std_logic_vector(15 downto 0);

		mem_addr_rw: in std_logic_vector(15 downto 0)
	);
end mem;

architecture Behavioral of mem is
	--signal status: std_logic_vector(3 downto 0) := "0000";
	-- signal times: std_logic_vector(3 downto 0) := "0000";
	--signal echo: std_logic_vector(15 downto 0) := "1111111100000000"
	-- signal process_clock50_scan_clk_button_pervious: std_logic := '1';
begin

process(clk)
	variable address: std_logic_vector(17 downto 0);
	variable data: std_logic_vector(15 downto 0);
	variable status: std_logic_vector(1 downto 0) := "00";
begin
	address (15 downto 0)<= mem_addr_rw;
	
	if (rising_edge(clk)) then		
			-- process_clock50_scan_clk_button_pervious <= clk;
			-- if (status = "0101" and process_clock50_scan_clk_button_pervious /= clk and clk = '0') then
				-- times <= times + '1';
				--status <= "0000"; -- reinitialize the status
			--end if;
			-- address := "000000000000000000" + times;
			-- data := "0000000000000000" + times;
			if (mem_read='0' and mem_write='1')
				if (status = "00") then -- Write memory, step #1
					-- led <= "1111111111111111"; -- Reset led, to make sure the data really comes from memory
					mem_en <= '0';
					mem_rw <= '1';
					mem_oe <= '1';
					mem_addr <= address;
					mem_data <= data;
					status <= "01";
				elsif (status = "01") then -- Write memory, step #2
					mem_rw <= '0';
					status <= "10";
				elsif (status = "10") then -- Write memory, step #3
					mem_rw <= '1';
					status <= "00";
					mem_data <= "ZZZZZZZZZZZZZZZZ";
				end if;
			elsif(mem_read='1' and mem_write='0')
				if (status = "00") then -- Read memory, step #1
					mem_oe <= '0';
					mem_addr <= address;
					status <= "01";
				elsif (status = "01") then -- Read memory, step #2
					mem_read_data <= mem_data;
					status <= "00";
					mem_oe <= '1';
				end if;
			end if;	
		
	end if;
end process;

end Behavioral;