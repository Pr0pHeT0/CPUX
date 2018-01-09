library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux3 is
    port(
      input1: in std_logic_vector(15 downto 0);
      input2: in std_logic_vector(15 downto 0);
      input3: in std_logic_vector(15 downto 0);
      input4: in std_logic_vector(15 downto 0);
      input5: in std_logic_vector(15 downto 0);
      input6: in std_logic_vector(15 downto 0);
      input7: in std_logic_vector(15 downto 0);
      input8: in std_logic_vector(15 downto 0);
      mux_op: in std_logic_vector(2 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
  end mux3;

  architecture Behavioral of mux3 is

    begin
        process(input1, input2, input3, input4, input5, input6, input7, input8, mux_op)
        begin
            case mux_op is
                when "000" => outsrc <= input1;
                when "001" => outsrc <= input2;
                when "010" => outsrc <= input3;
                when "011" => outsrc <= input4;
                when "100" => outsrc <= input5;
                when "101" => outsrc <= input6;
                when "110" => outsrc <= input7;
                when "111" => outsrc <= input8;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
    
    end Behavioral;