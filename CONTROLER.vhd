              ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:42:17 12/22/2017 
-- Design Name: 
-- Module Name:    mem - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Controler is
	Port( 
		rst:in STD_LOGIC;
		clk:in STD_LOGIC;
		clk0:in STD_LOGIC;
		instructions:in STD_LOGIC_VECTOR(15 downto 0);
		light:out STD_LOGIC_VECTOR(15 downto 0);
		showCtrl:in STD_LOGIC;
		bZero_ctrl:in  STD_LOGIC;  
		signal state : controler_state;
		signal PCWrite:std_logic;
		signal PCWriteCond:std_logic;
		signal PCSource:std_logic;
		signal ALUop:std_logic_vector(2 downto 0);
		signal ALUSrcA:std_logic;
		signal ALUSrcB:std_logic_vector(1 downto 0);
		signal MemRead:std_logic;
		signal MemWrite:std_logic;
		signal IRWrite:std_logic;
		signal MemtoReg:std_logic_vector(1 downto 0);
		signal RegWrite:std_logic_vector(2 downto 0);
		signal RegDst:std_logic_vector(1 downto 0);
		signal IorD:std_logic;
		signal rx:std_logic_vector(2 downto 0);
		signal ry:std_logic_vector(2 downto 0);
		signal rz:std_logic_vector(2 downto 0);
		signal imme:std_logic_vector(15 downto 0);
		signal tmpb_zero:std_logic;
		signal tmp_light:std_logic_vector(15 downto 0)
		);
end Controler;

architecture Behavioral of Controler is

signal bzero:std_logic;
type shower_state is(PC,ALU,Mem,Reg);
signal shower : shower_state ;
type controler_state is(instruction_fetch,decode,execute,mem_control,write_reg);
signal state : controler_state;
signal PCWrite:std_logic;
signal PCWriteCond:std_logic;
signal PCSource:std_logic;
signal ALUop:std_logic_vector(2 downto 0);
signal ALUSrcA:std_logic;
signal ALUSrcB:std_logic_vector(1 downto 0);
signal MemRead:std_logic;
signal MemWrite:std_logic;
signal IRWrite:std_logic;
signal MemtoReg:std_logic_vector(1 downto 0);
signal RegWrite:std_logic_vector(2 downto 0);
signal RegDst:std_logic_vector(1 downto 0);
signal IorD:std_logic;

signal rx:std_logic_vector(2 downto 0);
signal ry:std_logic_vector(2 downto 0);
signal rz:std_logic_vector(2 downto 0);

signal imme:std_logic_vector(15 downto 0);

signal tmpb_zero:std_logic;
signal tmp_light:std_logic_vector(15 downto 0);
begin
	light<=tmp_light;
	process(clk,rst,showCtrl)
	begin
		if rst='0' then
			shower<=PC;
		elsif rising_edge(showCtrl) then
			case shower is
				when PC=>
					shower<=ALU;
				when ALU=>
					shower<=Mem;
				when Mem=>
					shower<=Reg;
				when Reg=>
					shower<=PC;
			end case;
		end if;
	end process;
	
	process(clk0,rst,state)
	begin
		if rst='0' then
			tmp_light<=x"0000";
		elsif rising_edge(clk0)then
			case shower is
				when PC=>
					tmp_light(15 downto 0)<=x"0000";
					tmp_light(15)<=PCWrite;
					tmp_light(11)<=PCSource;
					tmp_light(7)<=PCWriteCond;
				when ALU=>
					tmp_light(15 downto 0)<=x"0000";
					tmp_light(15 downto 13)<=ALUOp;
					tmp_light(11)<=ALUSrcA;
					tmp_light(7 downto 6)<=ALUSrcB;
				when Mem=>
					tmp_light(15 downto 0)<=x"0000";
					tmp_light(15)<=MemRead;
					tmp_light(11)<=MemWrite;
					tmp_light(7)<=IRWrite;
					tmp_light(3 downto 2)<=MemtoReg;
				when Reg=>
					tmp_light(15 downto 0)<=x"0000";
					tmp_light(15 downto 13)<=RegWrite;
					tmp_light(11 downto 10)<=RegDst;
					tmp_light(7)<=IorD;
			end case;
		end if;
	end process;
	
	process(rst,bZero_Ctrl)
	begin
		if rst='0' then
			bzero<='0';
		elsif rising_edge(bZero_Ctrl)then
			if bzero='0' then
				bzero<='1';
				tmpb_zero<='0';
			elsif bzero='1' then
				tmpb_zero<='1';
				bzero<='0';
			end if;
		end if;
	end process;
	
	process(bzero)
	begin
		if bzero='1' then
			PCWriteCond<='1';
		elsif bzero='0'then
			PCWriteCond<='0';
		end if;
	end process;
	
	process(rst,clk)
	begin
		if(rst='0')then                               -------复位
			state<=instruction_fetch;
			IorD<='0';
			IRWrite<='0';
			MemRead<='0';
			MemWrite<='0';
			MemtoReg<="00";
			ALUOp<="000";
			ALUSrcA<='0';
			ALUSrcB<="00";
			PCWrite<='0';
			PCSource<='0';
			RegDst<="00";
			RegWrite<="000";
		elsif rising_edge(clk)then                        -------五个周期
			case state is
				when instruction_fetch=>                  -------取指
					MemRead<='1';
					ALUSrcA<='0';
					IorD<='0';
					ALUSrcB<="01";
					ALUOp<="000";
					PCWrite<='1';
					PCSource<='0';
					IRWrite<='1';
					RegWrite<="000";
					state<=decode;
				when decode=>
					case instructions(15 downto 11)is
						when "00001"=>                       -------ADDU
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
							rz<=instructions(4 downto 2);						
						when "00010"=>                       -------SUB
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
							rz<=instructions(4 downto 2);
						when "00011"=>                       -------LI
							rx<=instructions(10 downto 8);
							imme<="00000000" & instructions(7 downto 0);
						when "00100"=>                       -------LW
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
							imme<="00000000000" & instructions(4 downto 0);
						when "00101"=>                       -------SW
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
							imme<="00000000000" & instructions(4 downto 0);
						when "00110"=>                       -------MV
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "00111"=>                       -------SLTU
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01000"=>                       -------B
							imme<="00000" & instructions(10 downto 0);
						when "01001"=>                       -------AND
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01010"=>                       -------OR
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01011"=>                       -------NOT
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01100"=>                       -------SLLV
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01101"=>                       -------SRAV
							rx<=instructions(10 downto 8);
							ry<=instructions(7 downto 5);
						when "01110"=>                       -------BEQZ
							rx<=instructions(10 downto 8);
							imme<="00000000" & instructions(7 downto 0);
						when others=>
							NULL;
													          -------译码					IRWrite<='0';
					MemRead<='0';
					PCWrite<='0';
					ALUSrcA<='0';
					ALUSrcB<="10";
					ALUOp<="000";
					state<=execute;
				when execute=>                                -------执行
					case instructions(15 downto 11)is
						when "00001"=>                       -------ADDU
							ALUSrcA<='1';
							ALUSrcB<="00";
							ALUOp<="000"; 
							state<=write_reg;
						when "00010"=>                       -------SUB
							ALUSrcA<='1';
							ALUSrcB<="00";
							ALUOp<="001"; 
							state<=write_reg;
						when "00011"=>                       -------LI
							ALUSrcA<='1';
							ALUSrcB<="11";
							ALUOp<="000"; 
							state<=write_reg;
						when "00100"=>                       -------LW
							ALUSrcA<='1';
							ALUSrcB<="10";
							ALUOp<="000"; 
							state<=mem_control;
						when "00101"=>                       -------SW
							ALUSrcA<='1';
							ALUSrcB<="10";
							ALUOp<="000"; 
							state<=mem_control;
						when "00110"=>                       -------MV
							ALUSrcA<='1';
							ALUSrcB<="11";
							ALUOp<="000"; 
							state<=write_reg;
						when "00111"=>                       -------SLTU
							ALUSrcA<='1';
							ALUSrcB<="00";
							ALUOp<="100"; 
							state<=write_reg;
						when "01000"=>                       -------B
							ALUSrcA<='0';
							ALUSrcB<="10";
							ALUOp<="000"; 
							state<=instruction_fetch;
						when "01001"=>                       -------AND
							ALUSrcA<='1';
							ALUSrcB<="00";
							ALUOp<="010"; 
							state<=write_reg;
						when "01010"=>                       -------OR
							ALUSrcA<='1';
							ALUSrcB<="00";
							ALUOp<="011"; 
							state<=write_reg;
						when "01011"=>                       -------NOT
							ALUSrcA<='1';
							ALUOp<="101"; 
							state<=write_reg;
						when "01100"=>                       -------SLLV
							ALUSrcA<='1';
							ALUOp<="110"; 
							state<=write_reg;
						when "01101"=>                       -------SRAV
							ALUSrcA<='1';
							ALUOp<="111"; 
							state<=write_reg;
						when "01110"=>                       -------BEQZ
							ALUSrcA<='1';
							ALUOp<="000"; 
							state<=instruction_fetch;
						when others=>
							NULL;
					end case;
				when mem_control=>                          -------访存
					PCWrite<='0';
					RegWrite<="000";
					case instructions(15 downto 11)is
						when "00100"=>                       -------LW
							MemRead<='1';
							IorD<='1';
							state<=write_reg;
						when "00101"=>                       -------SW
							MemWrite<='1';
							IorD<='1';
							state<=write_reg;
						when others=>
							NULL;
					end case;
				when write_reg=>                             -------写回
					MemRead<='0';
					MemWrite<='0';
					case instructions(15 downto 11)is
						when "00001"=>                       -------ADDU
							RegDst<="10";
							RegWrite<="001";
							MemtoReg<="00";
						when "00010"=>                       -------SUB
							RegDst<="10";
							RegWrite<="001";
							MemtoReg<="00";
						when "00011"=>                       -------LI
							RegDst<="10";
							RegWrite<="001";
							MemtoReg<="00";
						when "00100"=>                       -------LW
							RegDst<="10";
							RegWrite<="001";
							MemtoReg<="01";
						when "00101"=>                       -------SW
							IorD<='0';
						when "00110"=>                       -------MV
							RegDst<="01";
							RegWrite<="001";
							MemtoReg<="00";
						when "00111"=>                       -------SLTU							
							RegWrite<="011";
							MemtoReg<="00";
						when "01001"=>                       -------AND
							RegDst<="00";
							RegWrite<="001";
							MemtoReg<="00";
						when "01010"=>                       -------OR
							RegDst<="00";
							RegWrite<="001";
							MemtoReg<="00";
						when "01011"=>                       -------NOT
							RegDst<="00";
							RegWrite<="001";
							MemtoReg<="00";
						when "01100"=>                       -------SLLV
							RegDst<="00";
							RegWrite<="001";
							MemtoReg<="00";
						when "01101"=>                       -------SRAV
							RegDst<="00";
							RegWrite<="001";
							MemtoReg<="00";
						when others=>
							NULL;
					end case;
					state<=instruction_fetch;                 -------重新取指
			end case;
		end if;
	end process;
end Behavioral;
					
