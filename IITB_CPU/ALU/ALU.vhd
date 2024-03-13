library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port (ALU_A , ALU_B :  		 in std_logic_vector(15 downto 0); 
			SEL: 				  		 in std_logic_vector(3 downto 0); 
			ALU_C : 			 		 out std_logic_vector(15 downto 0); 
			Z_wr:in std_logic;
			CARRY, ZF : out std_logic);
end entity ALU;

architecture structural of ALU is

signal result : std_logic_vector(15 downto 0) := (others => '0');

signal A_e,B_e : std_logic_vector(15 downto 0);


component MULTIPLIER is
  port (A: in std_logic_vector(3 downto 0);
        B: in std_logic_vector(3 downto 0);
        Y : out std_logic_vector(7 downto 0)
        );
end component ;

--FULL ADDER FUNCTION
function full_adder(A, B, C: in std_logic) return std_logic_vector is
  variable s: std_logic_vector(1 downto 0);
begin
  s(1) := (A or B) and ((B or C) and (C or A));
  s(0) := C xor (A xor B);
  return s;
end full_adder;
---------------------------------------------------------------------------------------------------------------------------------

--AND FUNCTION
	function AND_16(A : in std_logic_vector(15 downto 0);
						 B : in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable result : std_logic_vector(15 downto 0) := (others => '0');
	begin
			L1 : for i in 0 to 15 loop
				result(i) := A(i) and B(i);
			end loop L1;
		return result;
	end function AND_16;
--------------------------------------------------------------------------------------------------------------------------------	
--ADD FUNCTION
	function ADD_16(A : in std_logic_vector(15 downto 0); 
						 B : in std_logic_vector(15 downto 0)) 
	return std_logic_vector is
		variable C : std_logic_vector(16 downto 0) := (others => '0');
		variable S : std_logic_vector(15 downto 0);
	begin
		L2: for i in 0 to 15 loop
			S(i) := A(i) xor B(i) xor C(i);
			C(i+1) := ( A(i) and C(i) ) or ( ( A(i) xor C(i) ) and B(i) );
		end loop L2;
		return S;
	end function ADD_16;
---------------------------------------------------------------------------------------------------------------------------------
--CARRY FUNCTION	
	function Carry_16(A : in std_logic_vector(15 downto 0); 
							B : in std_logic_vector(15 downto 0)) 
	return std_logic is
		variable C : std_logic_vector(16 downto 0) := (others => '0');
	begin
		L3: for i in 0 to 15 loop
			C(i+1) := ( A(i) and C(i) ) or ( ( A(i) xor C(i) ) and B(i) );
		end loop L3;
		return C(16);
	end function Carry_16;
---------------------------------------------------------------------------------------------------------------------------------
--OR FUNCTION
	function OR_16(A : in std_logic_vector(15 downto 0);
						B : in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable result : std_logic_vector(15 downto 0) := (others => '0');
	begin
			L4 : for i in 0 to 15 loop
				result(i) := A(i) or B(i);
			end loop L4;
		return result;
	end function OR_16;
---------------------------------------------------------------------------------------------------------------------------------
--IMP FUNCTION
	function IMP(A : in std_logic_vector(15 downto 0);
					 B : in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable result : std_logic_vector(15 downto 0) := (others => '0');
	begin
			L5 : for i in 0 to 15 loop
				result(i) := (not B(i)) or A(i);
			end loop L5;
		return result;
	end function IMP;
---------------------------------------------------------------------------------------------------------------------------------
--SUBTRACT FUNCTION
	function SUB_16(A: in std_logic_vector(15 downto 0);
					    B: in std_logic_vector(15 downto 0))
	return std_logic_vector is
	  variable diff : std_logic_vector(15 downto 0) := (others => '0');
	  variable carry : std_logic := '1';
	  variable temp_A,temp_A2: std_logic_vector(15 downto 0);
	  variable temp_B: std_logic_vector(15 downto 0);
	begin
	  ones_complement_loop: for i in 0 to 15 loop
		 temp_B(i) := ('1' xor B(i));
	  end loop ones_complement_loop;

	 temp_A2:=add_16("0000000000000001",temp_B);
	 
    diff:=add_16(temp_A2,A);
	 
	  return diff;
	end SUB_16;

---------------------------------------------------------------------------------------------------------------------------------
--A*2 FUNCTION
	function A2(A: in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable mout : std_logic_vector(15 downto 0):=(others =>'0');
			begin
				mout(0):='0';
				for i in 1 to 15 loop
					mout(i) := A(i-1);
				end loop;
	return mout;
	end A2;
---------------------------------------------------------------------------------------------------------------------------------
--LLI FUNCTION
	function lli(A: in std_logic_vector(15 downto 0); 
					 B: in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable ans : std_logic_vector(15 downto 0) := (others => '0');
	begin
		 for i in 0 to 7 loop
			  ans(i) := A(i);
		 end loop;

		 for j in 8 to 15 loop
			  ans(j) := '0';
		 end loop;

		 return ans;
	end lli;
---------------------------------------------------------------------------------------------------------------------------------
--LHI FUNCTION
	function lhi(A: in std_logic_vector(15 downto 0); 
					 B: in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable ans : std_logic_vector(15 downto 0) := (others => '0');
	begin
		 for i in 0 to 7 loop
			  ans(i) := '0';
		 end loop;

		 for i in 8 to 15 loop
			  ans(i) := A(i);
		 end loop;

		 return ans;
	end lhi;
---------------------------------------------------------------------------------------------------------------------------------

begin
			A_e <= ALU_A;
			B_e <= ALU_B;

	M1: MULTIPLIER
			 port map (
				A(3) => A_e(3),
				A(2) => A_e(2),
				A(1) => A_e(1),
				A(0) => A_e(0),
				B(3) => B_e(3),
				B(2) => B_e(2),
				B(1) => B_e(1),
				B(0) => B_e(0),
				Y(7) => result(7),
				Y(6) => result(6),
				Y(5) => result(5),
				Y(4) => result(4),
				Y(3) => result(3),
				Y(2) => result(2),
				Y(1) => result(1),
				Y(0) => result(0)
			 );
	ALU_Process : process(ALU_A, ALU_B, SEL,result,Z_wr)
		begin
		
		if(SEL="0000") then
		ALU_C<=ADD_16(ALU_A,ALU_B);

		elsif(SEL="0001") then
		ALU_C<=SUB_16(ALU_A,ALU_B);

		elsif(SEL="0010") then
		ALU_C<=OR_16(ALU_A,ALU_B);

		elsif(SEL="0011") then
		ALU_C<=AND_16(ALU_A,ALU_B);

		elsif(SEL="0100") then
			ALU_C <= result;

		elsif(SEL="0101") then
		ALU_C<=IMP(ALU_A,ALU_B);

		elsif(SEL="0110") then
		ALU_C<=LLI(ALU_A,ALU_B);

		elsif(SEL="0111") then
		ALU_C<=LHI(ALU_A,ALU_B);

		elsif(SEL="1001") then
		ALU_C<=A2(ALU_A);
		
		else
		ALU_C<="0000000000000000";
		
		end if;

		if(SUB_16(ALU_A,ALU_B)="0000000000000000" and Z_wr = '1') then
			ZF<='1';
		else
			ZF<='0';
		end if;
		if(CARRY_16(ALU_A,ALU_B)='1') then
			CARRY<='1';
		else
			CARRY<='0';
		end if;

	end process ALU_Process;
end architecture structural;