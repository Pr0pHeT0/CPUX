library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxpcsource is
    port(
      alu: in std_logic_vector(15 downto 0);
      aluout: in std_logic_vector(15 downto 0);
      mux_op_p: in std_logic;
      outsrc_p: out std_logic_vector(15 downto 0)
    );
  end muxpcsource;

  architecture Behavioral of muxpcsource is

    begin
        process(alu, aluout, mux_op_p)
        begin
        if (mux_op_p = '0') then
            outsrc_p <= alu;
        else
            outsrc_p <= aluout;
        end if;
        end process;
    
    end Behavioral;