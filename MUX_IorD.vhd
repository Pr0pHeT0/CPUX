library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux_IorD is
    port(
      pcout: in std_logic_vector(15 downto 0);
      aluout: in std_logic_vector(15 downto 0);
      mux_op_i: in std_logic;
      outsrc_i: out std_logic_vector(15 downto 0)
    );
  end mux_IorD;

  architecture Behavioral of mux_IorD is

    begin
        process(pcout, aluout, mux_op_i)
        begin
        if (mux_op_i = '1') then
            outsrc_i <= pcout;
        else
            outsrc_i <= aluout;
        end if;
    end process;   
end Behavioral;