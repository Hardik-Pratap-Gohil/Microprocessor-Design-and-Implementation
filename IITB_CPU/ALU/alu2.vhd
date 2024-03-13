library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu2 is
port (
A: in std_logic_vector(15 downto 0);
B: in std_logic_vector(15 downto 0);
op: out std_logic_vector(15 downto 0)
) ;
end alu2;




architecture a1 of alu2 is

function add(A : in std_logic_vector(15 downto 0); B : in std_logic_vector(15 downto 0)) 
return std_logic_vector is
		variable C : std_logic_vector(16 downto 0) := (others => '0');
		variable S : std_logic_vector(15 downto 0);
	begin
		Loop1: for i in 0 to 15 loop
			S(i) := A(i) xor B(i) xor C(i);
			C(i+1) := ( A(i) and C(i) ) or ( ( A(i) xor C(i) ) and B(i) );
		end loop Loop1;
		return S;
	end function add;
begin
op<=add(A,B);
end a1;