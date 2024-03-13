library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jk_ff is
port(inclock,J,K,enable,preset,reset:in std_logic;
		Qbar:out std_logic;
		Q:buffer std_logic);
end entity jk_ff;

architecture flip of jk_ff is
signal jk:std_logic_vector(1 downto 0);


begin 
Qbar<=not(Q);
jk(1)<=J;
jk(0)<=K;
flipping:process(inclock,jk,enable,preset,reset)
begin 
if(reset='1') then
	Q<='0';
elsif(preset='1') then
	Q<='1';
elsif(inclock='1' and inclock' event) then
if(enable='1') then
	case jk is
		when "00" =>
			
		when "10" =>
			Q<='1';
		when "01" =>
			Q<='0';
		when "11" =>
			Q<=not(Q);
		when others =>
	end case;
end if;
end if;
end process;
end architecture flip;