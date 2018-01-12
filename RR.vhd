library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RR is
    Port ( clk : in  STD_LOGIC;
           RR_in : in std_logic_vector(15 downto 0);
           RR_write : in std_logic;           
           RR_out : out std_logic_vector(15 downto 0));
end RR;

architecture Behavioral of RR is

    begin
    process(clk)
          begin                         
                RR_out <= RR_in;                       
        end process;
    
    end Behavioral;
