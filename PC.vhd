library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port ( clk : in  STD_LOGIC;
           pc_in : in std_logic_vector(15 downto 0);
           pc_write : in std_logic;
           pc_out : out std_logic_vector(15 downto 0));
end PC;

architecture Behavioral of pc is

    begin
    process(clk)
          begin
            if(clk'event and clk='1') then
              if(pc_write = '1') then
                pc_out <= pc_in;
              end if;
            end if;
        end process;
    
    end Behavioral;
