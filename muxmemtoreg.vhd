library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxmemtoreg is
    port(
      aluout: in std_logic_vector(15 downto 0);
      mdr: in std_logic_vector(15 downto 0);
      mux_op: in std_logic_vector(1 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
end muxmemtoreg;

architecture Behavioral of muxmemtoreg is

    begin
        process(aluout, mdr,mux_op)
        begin
            case mux_op is
                when "00" => outsrc <= aluout;
                when "01" => outsrc <= mdr;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
			end process;
    end Behavioral;