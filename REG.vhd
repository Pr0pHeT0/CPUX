library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REG is
    port(
        clk: in std_logic;
        reg_num_1: in std_logic_vector(2 downto 0);
        reg_num_2: in std_logic_vector(2 downto 0);
        reg_write_num: in std_logic_vector(2 downto 0);  --:= "000";
        reg_write_data: in std_logic_vector(15 downto 0);
        write_oe: in std_logic := '0';
        reg_data_1: out std_logic_vector(15 downto 0);
        reg_data_2: out std_logic_vector(15 downto 0)
    );
    end REG;
    
    architecture Behavioral of REG is
        signal r0: std_logic_vector(15 downto 0) := "0000000000000000";
        signal r1: std_logic_vector(15 downto 0) := "0000000000000000";
        signal r2: std_logic_vector(15 downto 0) := "0000000000000000";
        signal r3: std_logic_vector(15 downto 0) := "0000000000000000";
        signal r4: std_logic_vector(15 downto 0) := "0000000000000000";
        signal r5:  std_logic_vector(15 downto 0) := "0000000000000000";
        signal r6: std_logic_vector(15 downto 0) := "0000000000000000";
        signal T: std_logic_vector(15 downto 0) := "0000000000000000";
    begin
    process(clk)
        begin
            if(clk'event and clk = '0') then
                if (write_oe = '1') then
                    case reg_write_num is
                        when "000" => r0 <= reg_write_data;
                        when "001" => r1 <= reg_write_data;
                        when "010" => r2 <= reg_write_data;
                        when "011" => r3 <= reg_write_data;
                        when "100" => r4 <= reg_write_data;
                        when "101" => r5 <= reg_write_data;
                        when "110" => r6 <= reg_write_data;
                        when "111" => T <= reg_write_data;
                        when others => null;
                    end case;
                end if;
            end if;
        end process;
    
        process(reg_num_1, r0, r1, r2, r3, r4, r5, r6, r7, T, SP, IH, RA)
        begin
            case reg_num_1 is
                when "000" => reg_data_1 <= r0;
                when "001" => reg_data_1 <= r1;
                when "010" => reg_data_1 <= r2;
                when "011" => reg_data_1 <= r3;
                when "100" => reg_data_1 <= r4;
                when "101" => reg_data_1 <= r5;
                when "110" => reg_data_1 <= r6;
                when "111" => reg_data_1 <= T;
                when others => null;
            end case;
        end process;
    
        process(reg_num_2, r0, r1, r2, r3, r4, r5, r6, r7, T, SP, IH, RA)
        begin
            case reg_num_2 is
                when "000" => reg_data_2 <= r0;
                when "001" => reg_data_2 <= r1;
                when "010" => reg_data_2 <= r2;
                when "011" => reg_data_2 <= r3;
                when "100" => reg_data_2 <= r4;
                when "101" => reg_data_2 <= r5;
                when "110" => reg_data_2 <= r6;
                when "111" => reg_data_2 <= T;
                when others => null;
            end case;
        end process;
    
    end Behavioral;