

library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
	port(I0,I1: in std_logic_vector(2 downto 0); Q: in std_logic; Y: out std_logic_vector(2 downto 0));
end entity mux3;

architecture Behavioral of mux3 is
begin
    process (Q, I0, I1)
    begin
        if Q = '0' then
            Y <= I0;
        else
            Y <= I1;
        end if;
    end process;
end Behavioral;