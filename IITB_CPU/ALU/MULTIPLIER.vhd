library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_textio.all;
   use IEEE.std_logic_unsigned.all;

--entity
entity MULTIPLIER is
  port (A: in std_logic_vector(3 downto 0);
        B: in std_logic_vector(3 downto 0);
        Y : out std_logic_vector(7 downto 0)
        );
end MULTIPLIER ;

-- architecture
architecture mono of MULTIPLIER is

component ADDER4 is
		port ( A : in STD_LOGIC_VECTOR (3 downto 0);
				 B : in STD_LOGIC_VECTOR (3 downto 0);
			  Cin : in STD_LOGIC;
				 S : out STD_LOGIC_VECTOR (3 downto 0);
			 Cout : out STD_LOGIC);
end component;

signal x,z,w,v,f,g : std_logic_vector(3 downto 0);

begin

	process(A,B)
	begin
---------------------------------------
		for i in 0 to 3 loop
				x(i) <= B(0) and A(i);
		end loop;

		for i in 0 to 3 loop
				v(i) <= B(1) and A(i);
		end loop;
		
		for i in 0 to 3 loop
				z(i) <= B(2) and A(i);
		end loop;
		
		for i in 0 to 3 loop
				w(i) <= B(3) and A(i);
		end loop;
----------------------------------------
	end process;
	ADD1: ADDER4 port map(	A(3) => v(3),
									A(2) => v(2),
									A(1) => v(1),
									A(0) => v(0),
									B(3) => '0',
									B(2) => x(3),
									B(1) => x(2),
									B(0) => x(1),
									Cin =>  '0',
									s(3) => f(3),
									S(2) => f(2),
									S(1) => f(1),
									S(0) => Y(1),
									Cout => f(0)
									);
	ADD2: ADDER4 port map(	A(3) => z(3),
									A(2) => z(2),
									A(1) => z(1),
									A(0) => z(0),
									B(3) => f(0),
									B(2) => f(3),
									B(1) => f(2),
									B(0) => f(1),
									Cin =>  '0',
									s(3) => g(3),
									S(2) => g(2),
									S(1) => g(1),
									S(0) => Y(2),
									Cout => g(0)
									);
	ADD3: ADDER4 port map(	A(3) => w(3),
									A(2) => w(2),
									A(1) => w(1),
									A(0) => w(0),
									B(3) => g(0),
									B(2) => g(3),
									B(1) => g(2),
									B(0) => g(1),
									Cin => '0',
									s(3) => Y(6),
									S(2) => Y(5),
									S(1) => Y(4),
									S(0) => Y(3),
									Cout => Y(7)
									);
	Y(0) <= x(0);
-----------------------------------------
end mono;