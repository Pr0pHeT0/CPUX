library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxregdst is
    port(
      rx: in std_logic_vector(15 downto 0);
      ry: in std_logic_vector(15 downto 0);
      rz: in std_logic_vector(15 downto 0);
      mux_op_r: in std_logic_vector(1 downto 0);
      outsrc_r: out std_logic_vector(15 downto 0)
    );
end muxregdst;

architecture Behavioral of muxregdst is

    begin
        process(rx, ry, rz,mux_op_r)
        begin
            case mux_op_r is
                when "00" => outsrc_r <= rx;
                when "01" => outsrc_r <= ry;
                when "10" => outsrc_r <= rz;
                when others => outsrc_r <= "ZZZZZZZZZZZZZZZZ";
            end case;
		end process;
end Behavioral;