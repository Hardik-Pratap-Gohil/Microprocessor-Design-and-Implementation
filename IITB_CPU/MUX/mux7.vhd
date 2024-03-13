library ieee;
use ieee.std_logic_1164.all;

entity mux7 is
	port(A,B,C,D: in std_logic_vector(15 downto 0); r,w: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity mux7;

architecture Behavioral of mux7 is
begin
    process (A, B, C, D, r, w)
    begin
        if r = '0' and w = '0' then
            Y <= A;
        elsif r = '0' and w = '1' then
            Y <= B;
        elsif r = '1' and w = '0' then
            Y <= C;
        elsif r = '1' and w = '1' then
            Y <= D;
        else
            -- Optional: Handle other cases if needed
            Y <= (others => '0'); -- Default case
        end if;
    end process;
end Behavioral;