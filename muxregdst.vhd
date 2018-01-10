library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxregdst is
    port(
      rx: in std_logic_vector(15 downto 0);
      ry: in std_logic_vector(15 downto 0);
      rz: in std_logic_vector(15 downto 0);
      mux_op: in std_logic_vector(1 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
end muxregdst;

architecture Behavioral of muxregdst is

    begin
        process(rx, ry, rz,mux_op)
        begin
            case mux_op is
                when "00" => outsrc <= rx;
                when "01" => outsrc <= ry;
                when "10" => outsrc <= rz;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
		end process;
end Behavioral;