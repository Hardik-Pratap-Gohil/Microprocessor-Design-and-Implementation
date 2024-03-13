library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity DFlop is 
	port(CLOCK, En, D, PRE, R: in std_logic;
		  Q, Q_bar: out std_logic);
end entity;

architecture gundam of DFlop is

component jk_ff is
port(inclock,J,K,enable,preset,reset:in std_logic;
		Qbar:out std_logic;
		Q:buffer std_logic);
end component jk_ff;

signal soup: std_logic;
begin

	I1: INVERTER port map(D, soup);
	JK1: jk_ff port map(CLOCK, D, soup, '1', PRE, R, Q_bar, Q); 

end gundam;