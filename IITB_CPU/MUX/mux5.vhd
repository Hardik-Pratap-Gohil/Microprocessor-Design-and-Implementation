library ieee;
use ieee.std_logic_1164.all;

entity mux5 is
	port(I0,I1: in std_logic_vector(15 downto 0); p: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity mux5;

architecture Behavioral of mux5 is
begin
    process (p, I0, I1)
    begin
        if p = '0' then
            Y <= I0;
        else
            Y <= I1;
        end if;
    end process;
end Behavioral;