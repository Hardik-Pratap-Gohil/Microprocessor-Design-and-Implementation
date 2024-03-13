library ieee;
use ieee.std_logic_1164.all;

entity Register16bit is
    port (
        Clk, Reset, Wr: in std_logic;
        Data_In: in std_logic_vector(15 downto 0);
        Data_Out: out std_logic_vector(15 downto 0)
    );
end entity;

architecture Struct of Register16bit is
    signal Reg: std_logic_vector(15 downto 0) := (others => '0');

begin
    process (Clk, Reset)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                Reg <= (others => '0');
            elsif Wr = '1' then
                Reg <= Data_In;
            end if;

            -- Always assign Data_Out
            Data_Out <= Reg;
        end if;
    end process;

end Struct;

