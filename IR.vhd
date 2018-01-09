library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IR is
    Port ( clk : in  STD_LOGIC;
           IR_in : in std_logic_vector(15 downto 0);
           IR_write : in std_logic;           
           IR_out : out std_logic_vector(15 downto 0));
end IR;

architecture Behavioral of IR is

    begin
    process(clk)
          begin           
              if(IR_write = '1') then
                IR_out <= IR_in;
              end if;            
        end process;
    
    end Behavioral;
