library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity muxregwrite is
    port(
      empty: in std_logic_vector(15 downto 0);
      general: in std_logic_vector(15 downto 0);
      sp: in std_logic_vector(15 downto 0);
      t: in std_logic_vector(15 downto 0);
      ra: in std_logic_vector(15 downto 0);
      ih: in std_logic_vector(15 downto 0);
      mux_op: in std_logic_vector(2 downto 0);
      outsrc: out std_logic_vector(15 downto 0)
    );
end muxregwrite;

architecture Behavioral of muxregwrite is

    begin
        process(empty, general, sp, t, ra, ih, mux_op)
        begin
            case mux_op is
                when "000" => outsrc <= empty;
                when "001" => outsrc <= general;
                when "010" => outsrc <= sp;
                when "011" => outsrc <= t;
                when "100" => outsrc <= ra;
                when "101" => outsrc <= ih;
                when others => outsrc <= "ZZZZZZZZZZZZZZZZ";
            end case;
		end process;
    end Behavioral;