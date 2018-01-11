library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxmemtoreg is
    port(
      aluout: in std_logic_vector(15 downto 0);
      mdr: in std_logic_vector(15 downto 0);
      mux_op_m: in std_logic_vector(1 downto 0);
      outsrc_m: out std_logic_vector(15 downto 0)
    );
end muxmemtoreg;

architecture Behavioral of muxmemtoreg is

    begin
        process(aluout, mdr,mux_op_m)
        begin
            case mux_op_m is
                when "00" => outsrc_m <= aluout;
                when "01" => outsrc_m <= mdr;
                when others => outsrc_m <= "ZZZZZZZZZZZZZZZZ";
            end case;
			end process;
    end Behavioral;