library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ClkEnableGenerator is
	generic (count : positive := 500000);
	port(clk50MHz	: in  std_logic;
		  clkEnable	: out std_logic);
end ClkEnableGenerator;

architecture Behavioral of ClkEnableGenerator is

	signal s_counter : integer:= 0;
	signal s_clk : std_logic:= '0';

begin
	process(clk50Mhz)
	begin
		if (rising_edge(clk50MHz)) then
			if (s_counter /= count) then
				s_counter <= s_counter + 1;
			else
				s_counter <= 0;
			end if;
		end if;
	end process;
	
	clkEnable <= '1' when (s_counter = count) else
					 '0';
end Behavioral;
