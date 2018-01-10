library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxalusrca is
    port(
      pcout: in std_logic_vector(15 downto 0);
      A: in std_logic_vector(15 downto 0);
      mux_op: in std_logic;
      outsrc: out std_logic_vector(15 downto 0)
    );
  end muxalusrca;

  architecture Behavioral of muxalusrca is

    begin
        process(pcout, A, mux_op)
        begin
        if (mux_op = '0') then
            outsrc <= pcout;
        else
            outsrc <= A;
        end if;
    end process;
    
end Behavioral;