library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity Bin2BCD is
	port (BinIn : in std_logic_vector(9 downto 0);
			u, d, c, m : out std_logic_vector(3 downto 0));
end Bin2BCD;
architecture Behavioral of Bin2BCD is 
	signal s_entra, s_u, s_c, s_d, s_m, st_u, st_d, s_dez : unsigned (9 downto 0);
begin
	s_entra <= unsigned(BinIn);
	s_dez <= to_unsigned (10,10); -- cria o valor 10 em unsigned em 10 bits
	
	st_u <= s_entra / s_dez;
	s_u <= s_entra rem s_dez;

	st_d <= st_u / s_dez;
	s_d <= st_u rem s_dez;

	s_m <= st_d / s_dez;
	s_c <= st_d rem s_dez;
	
	
	u <= std_logic_vector(s_u(3 downto 0));
	d <= std_logic_vector(s_d(3 downto 0));
	c <= std_logic_vector(s_c(3 downto 0));
	m <= std_logic_vector(s_m(3 downto 0));
end Behavioral;