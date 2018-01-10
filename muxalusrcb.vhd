library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxalusrcb is
    port(
      B: in std_logic_vector(15 downto 0);
      --con1: in std_logic_vector(15 downto 0):="0000000000000001";
      low: in std_logic_vector(15 downto 0);
      --con0: in std_logic_vector(15 downto 0):="0000000000000000";
      mux_op: in std_logic_vector(1 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
end muxalusrcb;

architecture Behavioral of muxalusrcb is
  signal con1: in std_logic_vector(15 downto 0):="0000000000000001";
  signal con0: in std_logic_vector(15 downto 0):="0000000000000000";
    begin
        process(B, con1, low, con0,mux_op)
        begin
            case mux_op is
                when "00" => outsrc <= B;
                when "01" => outsrc <= con1;
                when "10" => outsrc <= low;
                when "11" => outsrc <= con0;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
		end process;
    end Behavioral;