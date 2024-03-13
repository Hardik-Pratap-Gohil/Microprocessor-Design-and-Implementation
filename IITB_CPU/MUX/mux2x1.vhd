
library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
	port(I0,I1: in std_logic_vector(15 downto 0); S: in std_logic; O: out std_logic_vector(15 downto 0));
end entity mux2x1;

architecture Behavioral of mux2x1 is
begin
    process (S, I0, I1)
    begin
        if S = '0' then
            O <= I0;
        else
            O <= I1;
        end if;
    end process;
end Behavioral;