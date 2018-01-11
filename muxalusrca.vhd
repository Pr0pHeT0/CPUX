library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxalusrca is
    port(
      pcout: in std_logic_vector(15 downto 0);
      A: in std_logic_vector(15 downto 0);
      mux_op_a: in std_logic;
      outsrc_a: out std_logic_vector(15 downto 0)
    );
  end muxalusrca;

  architecture Behavioral of muxalusrca is

    begin
        process(pcout, A, mux_op_a)
        begin
        if (mux_op_a = '0') then
            outsrc_a <= pcout;
        else
            outsrc_a <= A;
        end if;
    end process;
    
end Behavioral;