library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity IITB_CPU is
port(clk,rst:in std_logic;
     check_output1,check_output2:out std_logic_vector(15 downto 0));
end entity;



architecture struct of IITB_CPU is 



component rf is
port (rst,clk, RF_wr : in std_logic;
 RF_A1,RF_A2,RF_A3 : in std_logic_vector(2 downto 0);
 RF_D3: in std_logic_vector(15 downto 0);
  RF_D1,RF_D2 : out std_logic_vector(15 downto 0));
end component;

component ALU is
	port (ALU_A , ALU_B :  		 in std_logic_vector(15 downto 0); 
			SEL: 				  		 in std_logic_vector(3 downto 0); 
			ALU_C : 			 		 out std_logic_vector(15 downto 0); 
			Z_wr:in std_logic;
			CARRY, ZF : out std_logic);
end component ALU;


component Register16bit is
	port(	Clk, Reset,wr : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0));
end component;


component SE6 is
port( input : in std_logic_vector (5 downto 0);
     SE_out : out std_logic_vector ( 15 downto 0));
end component;


component SE9 is
port( input : in std_logic_vector (8 downto 0);
     SE_out : out std_logic_vector ( 15 downto 0));
end component;


component alu2 is
port (
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
op: out std_logic_vector(15 downto 0)
) ;
end component;

component memory is
    port(
	   WE,RE,clk: in std_logic;
		address,Din: in std_logic_vector(15 downto 0);
		Dout: out std_logic_vector(15 downto 0)
		);
end component;

component mux4x1 is
	port(A,B,C,D: in std_logic_vector(15 downto 0); S0,S1: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux4x1;


component mux2 is
	port(I0,I1: in std_logic_vector(15 downto 0); O: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux2;

component mux3 is
	port(I0,I1: in std_logic_vector(2 downto 0); Q: in std_logic; Y: out std_logic_vector(2 downto 0));
end component mux3;

component mux4 is
	port(I0,I1: in std_logic_vector(15 downto 0); O: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux4;

component mux5 is
	port(I0,I1: in std_logic_vector(15 downto 0); p: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux5;

component mux6 is
	port(I0, I1, I2, I3, I4, I5, I6, I7: in std_logic_vector(15 downto 0); s,t,u: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux6;



component mux7 is
	port(A,B,C,D: in std_logic_vector(15 downto 0); r,w: in std_logic; Y: out std_logic_vector(15 downto 0));
end component mux7;

component mux2x1 is
	port(I0,I1: in std_logic_vector(15 downto 0); S: in std_logic; O: out std_logic_vector(15 downto 0));
end component mux2x1;


signal ALU_B,ALU_C,ALU_A,T1in,T1out,T2in,T2out,T3in,T3out,SE_6,SE_9,PCin,PCout,RF_D3,RF_D1,RF_D2,IRin,IRout,mem_dout,mem_add,mem_din,ALU_out,mux0_out:std_logic_vector(15 downto 0);

signal ZF,CARRY:std_logic;

signal a,b,c,d,k,l,n,o,p,q,s,t,u,v,r,w,Z_wr,RF_wr,T1_wr,T2_wr,T3_wr,IR_wr,PC_wr,mem_wr,mem_rd:std_logic;    ---control signals

signal Rf_A1,Rf_A2,Rf_A3:std_logic_vector(2 downto 0);

type state is (s1,s2,s3,s4,s14,s17,s18,s19,s21);

signal curr_st,nx_st:state;


begin

check_output1<=T3out;
check_output2<=PCout;

alu1:ALU port map (ALU_A=>ALU_A,ALU_B=>ALU_B,ALU_C=>ALU_C,Z_WR=>Z_WR,ZF=>ZF,CARRY=>CARRY,sel(0)=>a,sel(1)=>b,sel(2)=>c,sel(3)=>d);

mux_6:mux6 port map (I0=>T3out, I1=>T2out, I2=>"0000000000000000", I3=>SE_6, I4=>"0000000000000010", I5=>"1111111111111111",
                     I6=>"1111111111111111", I7=>"1111111111111111", s=>s,t=>t,u=>u,Y=>ALU_B);


mux_7:mux7 port map (A=>SE_9,B=>SE_6,C=>T1out,D=>PCout,r=>r,w=>w,Y=>ALU_A);


registerfile:rf port map (rst=>rst,clk=>clk, RF_wr=>RF_wr,RF_A1=>Rf_A1,RF_A2=>Rf_A2,RF_A3=>Rf_A3, RF_D3=>RF_D3,RF_D1=>RF_D1,RF_D2=>RF_D2);

mux_3:mux3 port map (I0(2)=>IRout(3),I0(1)=>IRout(4),I0(0)=>IRout(5),I1(2)=>IRout(11),I1(1)=>IRout(10),I1(0)=>IRout(9), Q=>q, Y=>Rf_A2);

Rf_A1(0)<=IRout(8);
Rf_A1(1)<=IRout(7);
Rf_A1(2)<=IRout(6);

Rf_A3(0)<=IRout(11);
Rf_A3(1)<=IRout(10);
Rf_A3(2)<=IRout(9);

mux_5: mux5 port map(I0=>PCout, I1=>T3out, p=>p, Y=>Rf_D3);

T1: register16bit port map (Clk=>clk, Reset=>rst, data_in=>Rf_D1, data_out=>T1out,wr=>T1_wr);

T2: register16bit port map (Clk=>clk, Reset=>rst, data_in=>T2in, data_out=>T2out, wr=>T2_wr);



mux_4:mux2x1 port map(I0=>Rf_D2,I1=>SE_6, S=>v, O=>T2in);


IR: register16bit port map (Clk=>clk, Reset=>rst, data_in=>mem_dout, data_out=>IRout, wr=>IR_wr);

T3: register16bit port map (Clk=>clk, Reset=>rst, data_in=>T3in, data_out=>T3out, wr=>T3_wr);

mux_8:mux2 port map(I0=>mem_dout,I1=>ALU_c,O=>k,Y=>T3in);

SEx6:SE6 port map ( input(0)=>IRout(0),input(1)=>IRout(1),input(2)=>IRout(2),input(3)=>IRout(3)
                       ,input(4)=>IRout(4),input(5)=>IRout(5),SE_out=>SE_6);


SEx9:SE9 port map ( input(0)=>IRout(0),input(1)=>IRout(1),input(2)=>IRout(2),input(3)=>IRout(3),input(4)=>IRout(4)
                       ,input(5)=>IRout(5),input(6)=>IRout(6),input(7)=>IRout(7),input(8)=>IRout(8),SE_out=>SE_9);



PC:register16bit port map (Clk=>clk, Reset=>rst, data_in=>PCin, data_out=>PCout, wr=>PC_wr);

mux_1:mux4x1 port map(A=>ALU_out,B=>ALU_C,C=>RF_D1,D=>"0000000000000000", S0=>n,S1=>l,Y=>PCin);

mux_0:mux2 port map (I0=>"0000000000000010",I1=>T3out,O=>ZF,Y=>mux0_out);

mux_2:mux2 port map (I0=>PCout,I1=>T3out,O=>o,Y=>mem_add);



PcAlu:alu2 port map(A=>mux0_out,B=>PCout,op=>ALU_out);


mem:memory port map(WE=>mem_wr,RE=>mem_rd,clk=>clk,
		address=>mem_add,Din=>mem_din,
		Dout=>mem_dout
		);
		
		
		
statetransition:process(clk,rst,IRout)
begin
if(clk='1' and clk'event) then
if (rst='1') then 
curr_st<=s1;
else
case curr_st is

 when s1=>
   a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='1';PC_wr<='1';mem_wr<='0';mem_rd<='1';
	
   if((IRout(15) and ( IRout(14)) and (not IRout(13)) and IRout(12)) ='1' or (IRout(15) and ( IRout(14)) and IRout(13) and IRout(12))='1') then
	 nx_st<=s4;
	else
	 nx_st<=s2;
	end if;
	
 when s2=>
    if (((IRout(15)) and ( not IRout(14)) and ( IRout(13)) and (not IRout(12))) ='1' or ((not IRout(15)) and ( not IRout(14)) and (not IRout(13)) and IRout(12)) ='1') then
	  a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	  u<='0';v<='1';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='1';T2_wr<='1';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	elsif (((IRout(15)) and (not IRout(14)) and ( IRout(13)) and IRout(12)) ='1' ) then
	  a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='0';p<='0';q<='1';s<='0';t<='0';
	  u<='0';v<='1';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='1';T2_wr<='1';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	elsif ((( IRout(15)) and (  IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	 a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='0';p<='0';q<='1';s<='0';t<='0';
	 u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='1';T2_wr<='1';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	else
	 a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='1';T2_wr<='1';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	end if;
   nx_st<=s3;
	
	
 when s3=>
   if (((not IRout(15)) and (not IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif (((not IRout(15)) and ( IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	 
	 a<='1';b<='1';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif ((( IRout(15)) and ( IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='1';b<='0';c<='0';d<='1';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='0';w<='1';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	
	elsif ((( IRout(15)) and (not IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='1';b<='0';c<='1';d<='1';k<='0';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	
	elsif (((not IRout(15)) and (not IRout(14)) and ( IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='1';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	
	elsif ((( IRout(15)) and (not IRout(14)) and ( IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif (((not IRout(15)) and ( IRout(14)) and ( IRout(13)) and (not IRout(12))) ='1' ) then
	
	 a<='1';b<='0';c<='1';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif (((not IRout(15)) and (not IRout(14)) and (not IRout(13)) and ( IRout(12))) ='1' ) then
	
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif ((( IRout(15)) and (not IRout(14)) and (not IRout(13)) and ( IRout(12))) ='1' ) then
	
	 a<='0';b<='1';c<='1';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='1';
	 u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif (((not IRout(15)) and ( IRout(14)) and (not IRout(13)) and ( IRout(12))) ='1' ) then
	
	 a<='0';b<='1';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif ((( IRout(15)) and (not IRout(14)) and ( IRout(13)) and ( IRout(12))) ='1' ) then
	
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='1';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	elsif (((not IRout(15)) and (not IRout(14)) and ( IRout(13)) and ( IRout(12))) ='1' ) then
	
	 a<='0';b<='0';c<='1';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='0';w<='1';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	end if;
  
   if ((( IRout(15)) and ( not IRout(14)) and ( IRout(13)) and (not IRout(12))) ='1' ) then
	 nx_st<=s14;
	elsif (((IRout(15)) and (not IRout(14)) and ( IRout(13)) and IRout(12)) ='1' ) then
	 nx_st<=s17;
	elsif ((( IRout(15)) and (  IRout(14)) and (not IRout(13)) and (not IRout(12))) ='1' ) then
	 nx_st<=s18;
	else
	nx_st<=s4;
	end if;
	

 when s17=>
    a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='1';p<='0';q<='0';s<='0';t<='0';
	 u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='1';mem_rd<='0';
	 nx_st<=s1;
	
	
 when s14=>
    a<='0';b<='0';c<='0';d<='0';k<='0';l<='0';n<='0';o<='1';p<='0';q<='0';s<='1';t<='0';
	 u<='0';v<='0';r<='0';w<='1';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='1';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='1';
   nx_st<=s4;
	
	
	
	
 when s18=>
    a<='1';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='1';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='1';mem_wr<='0';mem_rd<='0';
   nx_st<=s1;
	
	
 when s4=>
    if (((( IRout(15)) and ( IRout(14)) and (not IRout(13)) and IRout(12)) ='1') or ((( IRout(15)) and ( IRout(14)) and ( IRout(13)) and IRout(12)) ='1')) then
	 
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='0';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='1';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	else
	 
	 a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='0';o<='0';p<='1';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='1';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='0';mem_wr<='0';mem_rd<='0';
	 
	end if;
 
   if ((( IRout(15)) and ( IRout(14)) and (not IRout(13)) and IRout(12)) ='1' ) then
	 nx_st<=s19;
	elsif ((IRout(15) and ( IRout(14)) and IRout(13) and IRout(12))='1') then
	 nx_st<=s21;
	else
	 nx_st<=s1;
	end if;
	
	
 when s19=>
    a<='0';b<='0';c<='0';d<='0';k<='1';l<='0';n<='1';o<='0';p<='1';q<='0';s<='1';t<='0';
	 u<='0';v<='0';r<='0';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='1';mem_wr<='0';mem_rd<='0';
   nx_st<=s1;
	
	
 when s21=>
    a<='0';b<='0';c<='0';d<='0';k<='1';l<='1';n<='0';o<='0';p<='1';q<='0';s<='0';t<='0';
	 u<='1';v<='0';r<='1';w<='0';Z_wr<='0';RF_wr<='0';T1_wr<='0';T2_wr<='0';T3_wr<='0';IR_wr<='0';PC_wr<='1';mem_wr<='0';mem_rd<='0';
   nx_st<=s1;
	
	
end case;
curr_st<=nx_st;
end if;
end if;
end process;




end architecture;








