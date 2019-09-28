library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity bintoASCII is
	port(binInput : in std_logic_vector(3 downto 0);
		  ASCII_out : out std_logic_vector(7 downto 0));
end bintoASCII;

architecture Behavioral of bintoASCII is
begin
	
	ASCII_out <=x"31" when (binInput = "0001" ) else --1
					x"32" when (binInput = "0010") else --2 (0 liga 1 desliga)
					x"33" when (binInput = "0011" ) else --3
					x"34" when (binInput = "0100" ) else --4
					x"35" when (binInput = "0101") else --5
					x"36" when (binInput = "0110" ) else --6
					x"37" when (binInput = "0111") else --7
					x"38" when (binInput = "1000" ) else --8
					x"39" when (binInput = "1001") else --9
					x"30";
end Behavioral;