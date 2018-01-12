library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DR is
    Port ( clk : in  STD_LOGIC;
           DR_in : in std_logic_vector(15 downto 0);       
           DR_out : out std_logic_vector(15 downto 0));
end DR;

architecture Behavioral of DR is

    begin
    process(clk)
          begin           
                DR_out <= DR_in;      
        end process;
    
    end Behavioral;
