library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity FA is
 Port ( A : in std_logic;
    B : in STD_LOGIC;
    Cin : in STD_LOGIC;
    S : out STD_LOGIC;
    Cout : out STD_LOGIC);
end FA;

architecture struct of FA is

begin

 S <= A XOR B XOR Cin ;
 Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;

end struct;