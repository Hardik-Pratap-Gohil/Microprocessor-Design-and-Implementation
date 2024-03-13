library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;




entity rf is
port (rst,clk, RF_wr : in std_logic;
 RF_A1,RF_A2,RF_A3 : in std_logic_vector(2 downto 0);
 RF_D3: in std_logic_vector(15 downto 0);
  RF_D1,RF_D2 : out std_logic_vector(15 downto 0));
end entity;



architecture struct of rf is
type regnum is array (0 to 7 ) of std_logic_vector(15 downto 0);
signal regf:regnum;

begin




writeprocess:process(rst,clk,RF_wr,RF_D3,RF_A3)
begin

if(rst='1') then
m1:for j in 1 to 7 loop
		    regf(j)<="0000000000010011";
         end loop;
regf(0)<="0000000000000011";
elsif( clk='1' and clk'event) then
if(RF_wr='1' ) then
regf(to_integer(unsigned(RF_A3)))<=RF_D3;
end if;
end if;


end process;


readprocess:process(clk, RF_A1,RF_A2)
begin

if(clk='1' and clk'event ) then

RF_D1<= regf(to_integer(unsigned(RF_A1)));
RF_D2<= regf(to_integer(unsigned(RF_A2)));


end if;

end process;



end architecture; 