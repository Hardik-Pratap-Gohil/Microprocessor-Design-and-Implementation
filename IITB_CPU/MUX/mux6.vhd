library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity mux6 is
	port(I0, I1, I2, I3, I4, I5, I6, I7: in std_logic_vector(15 downto 0); s,t,u: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity mux6;

architecture struct of mux6 is
	component mux2x1 is
		port(I0,I1: in std_logic_vector(15 downto 0); S: in std_logic; O: out std_logic_vector(15 downto 0));
	end component mux2x1;
	
	signal S1,S2,S3,S4,S5,S6: std_logic_vector(15 downto 0);
begin
	M1: mux2x1 port map(I0 => I0, I1 => I1, S => U, O => S1);
	M2: mux2x1 port map(I0 => I2, I1 => I3, S => U, O => S2);
	M3: mux2x1 port map(I0 => I4, I1 => I5, S => U, O => S3);
	M4: mux2x1 port map(I0 => I6, I1 => I7, S => U, O => S4);
	M5: mux2x1 port map(I0 => S1, I1 => S2, S => T, O => S5);	
	M6: mux2x1 port map(I0 => S3, I1 => S4, S => T, O => S6);
	M7: mux2x1 port map(I0 => S5, I1 => S6, S => S, O => Y);
end architecture struct;