library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
	port(I0,I1: in std_logic_vector(15 downto 0); O: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity mux2;

architecture Behavioral of mux2 is
begin
    process (O, I0, I1)
    begin
        if O = '0' then
            Y <= I0;
        else
            Y <= I1;
        end if;
    end process;
end Behavioral;