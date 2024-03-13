library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
	port(A,B,C,D: in std_logic_vector(15 downto 0); S0,S1: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity mux4x1;

architecture Behavioral of mux4x1 is
begin
    process (A, B, C, D, S0, S1)
    begin
        if S0 = '0' and S1 = '0' then
            Y <= A;
        elsif S0 = '0' and S1 = '1' then
            Y <= B;
        elsif S0 = '1' and S1 = '0' then
            Y <= C;
        elsif S0 = '1' and S1 = '1' then
            Y <= D;
        else
            -- Optional: Handle other cases if needed
            Y <= (others => '0'); -- Default case
        end if;
    end process;
end Behavioral;