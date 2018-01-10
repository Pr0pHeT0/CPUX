library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxsource is
    port(
      alu: in std_logic_vector(15 downto 0);
      aluout: in std_logic_vector(15 downto 0);
      mux_op: in std_logic;
      outsrc: out std_logic_vector(15 downto 0)
    );
  end muxsource;

  architecture Behavioral of muxsource is

    begin
        process(alu, aluout, mux_op)
        begin
        if (mux_op = '0') then
            outsrc <= alu;
        else
            outsrc <= aluout;
        end if;
        end process;
    
    `end Behavioral;