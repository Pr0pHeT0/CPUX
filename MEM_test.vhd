library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Import necessary libraries, with STD_LOGIC and it's vector type suport

entity mem_read is
	port
	(
		clock50: in std_logic;
		-- clock50 is 50MHz crystal on board
		clk: in std_logic;
		-- clk is the clock button on board(per-step clock source)
		led: out std_logic_vector(0 to 15);
		-- led_debug is LED x16 on board for debugging
		mem1_en: out std_logic;
		-- mem1_en is the enable signal of memory #1 on board
		mem1_oe: out std_logic;
		-- mem1_oe is the output enable signal of memory #1 on board
		mem1_rw: out std_logic;
		-- mem1_rw is the read/write controller signal of memory #1 on board
		mem1_addr: out std_logic_vector(17 downto 0);
		-- mem1_addr is the address bus with little endian of memory #1 on board
		mem1_data: inout std_logic_vector(15 downto 0)
		-- mem1_data is the data bus with little endian and inout support of memory #1 on board
	);
end mem_read;

architecture Behavioral of mem_read is
	signal status: std_logic_vector(3 downto 0) := "0101";
	signal times: std_logic_vector(3 downto 0) := "0000";
	signal echo: std_logic_vector(15 downto 0) := "1111111100000000";
	signal process_clock50_scan_clk_button_pervious: std_logic := '1';
begin

process(clock50)
	variable address: std_logic_vector(17 downto 0);
	variable data: std_logic_vector(15 downto 0);
begin
	if (rising_edge(clock50)) then
		if (times <= "1010") then
			process_clock50_scan_clk_button_pervious <= clk;
			if (status = "0101" and process_clock50_scan_clk_button_pervious /= clk and clk = '0') then
				times <= times + '1';
				status <= "0000"; -- reinitialize the status
			end if;
			address := "000000000000000000" + times;
			data := "0000000000000000" + times;
			if (status = "0000") then -- Write memory, step #1
				led <= "1111111111111111"; -- Reset led, to make sure the data really comes from memory
				mem1_en <= '0';
				mem1_rw <= '1';
				mem1_oe <= '1';
				mem1_addr <= address;
				mem1_data <= data;
				status <= "0001";
			elsif (status = "0001") then -- Write memory, step #2
				mem1_rw <= '0';
				status <= "0010";
			elsif (status = "0010") then -- Write memory, step #3
				mem1_rw <= '1';
				status <= "0011";
				mem1_data <= "ZZZZZZZZZZZZZZZZ";
			elsif (status = "0011") then -- Read memory, step #1
				mem1_oe <= '0';
				mem1_addr <= address;
				status <= "0100";
			elsif (status = "0100") then -- Read memory, step #2
				led <= mem1_data;
				status <= "0101";
				mem1_oe <= '1';
			end if;
		end if;
	end if;
end process;

end Behavioral;