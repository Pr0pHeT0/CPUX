library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux2 is
    port(
      input1: in std_logic_vector(15 downto 0);
      input2: in std_logic_vector(15 downto 0);
      input3: in std_logic_vector(15 downto 0);
      input4: in std_logic_vector(15 downto 0);
      mux_op: in std_logic_vector(1 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
end mux2;

architecture Behavioral of mux2 is

    begin
        process(input1, input2, input3, input4,mux_op)
        begin
            case mux_op is
                when "00" => outsrc <= input1;
                when "01" => outsrc <= input2;
                when "10" => outsrc <= input3;
                when "11" => outsrc <= input4;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
			end process;
    end Behavioral;