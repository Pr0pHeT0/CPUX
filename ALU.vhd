library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; --123

entity ALU is
    Port ( clk : in  STD_LOGIC;
           alu_srcA : in std_logic_vector(15 downto 0);
           alu_srcB : in std_logic_vector(15 downto 0);
           alu_out : out std_logic_vector(15 downto 0);
           alu_op : in std_logic_vector(2 downto 0));
end ALU;

architecture Behavioral of ALU is

    begin
        process (alu_srcA, alu_srcB, alu_op)
        variable res : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
      begin
        case alu_op is
          when "000" =>
            res := alu_srcA + alu_srcB;
          when "001" =>
            res := alu_srcA - alu_srcB;
          when "010" =>
            res := alu_srcA and alu_srcB;
          when "011" =>
            res := alu_srcA or alu_srcB;
          when "100" =>
            if(alu_srcA<alu_srcB) then 
              res := "0000000000000001";
              elsif(alu_srcA>=alu_srcB) then 
                res :="0000000000000000";
            end if;          
          when "101" =>
            res := not(alu_srcA);
          when "110" =>           
            res : = to_stdlogicvector(to_bitvector(alu_srcA) sll conv_integer(alu_srcB)); --sllv luojizuoyi
          when "111" =>            
            res := to_stdlogicvector(to_bitvector(alu_srcA) srl conv_integer(alu_srcB)); -- srlv luojiyouyi  
          when others =>
              NULL;
            end case;
          alu_out <= res;
      end process;
    end Behavioral;
