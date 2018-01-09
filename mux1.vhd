library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux1 is
    port(
      input1: in std_logic_vector(15 downto 0);
      input2: in std_logic_vector(15 downto 0);
      mux_op: in std_logic;
      outsrc: out std_logic_vector(15 downto 0)
    );
  end mux1;

  architecture Behavioral of mux1 is

    begin
        process(input1, input2, mux_op)
        begin
        if (mux_op = '0') then
            outsrc <= input1;
        else
            outsrc <= input2;
        end if;
        end process;
    
    end Behavioral;