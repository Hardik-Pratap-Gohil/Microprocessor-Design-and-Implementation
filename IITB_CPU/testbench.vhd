library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;

library work;

entity Testbench is
end entity;



architecture Behave of Testbench is

component IITB_CPU is
port(clk,rst:in std_logic;
     check_output1,check_output2:out std_logic_vector(15 downto 0));
end component;


  signal clk,rst: std_logic;
  signal check_output1,check_output2:std_logic_vector(15 downto 0);
  
begin

rst<='1','0' after 200ns;

CKP1: process
begin
clk <= '0';
wait for 2000 ns;
clk<= '1';
wait for  2000 ns;
assert (NOW < 900 ms)
report "Simulation completed successfully.";
end process CKP1; 



IITB_CPU1:IITB_CPU port map(clk=>clk,rst=>rst,check_output1=>check_output1,check_output2=>check_output2);


end architecture;