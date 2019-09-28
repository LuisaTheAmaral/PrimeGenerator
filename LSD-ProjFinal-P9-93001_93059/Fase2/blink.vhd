library IEEE;
use IEEE.std_logic_1164.all;

entity blink is
	port(found_prime, enable,clk_pulse  : in std_logic;
		  display_enable, led_signal   : out std_logic);
end blink;

Architecture Behav of blink is
	signal s_displayen, s_ledsignal : std_logic;

begin
	process(enable, found_prime)
	begin
		if(enable = '1') then 
			if(found_prime = '1') then 
				s_displayen <= '1';
				s_ledsignal <= '0';
			else
				s_displayen <= '0';
				s_ledsignal <= clk_pulse;
			end if;
		else
			s_displayen <= '0';
			s_ledsignal <= '0';
		end if;
	end process;
	display_enable <= s_displayen;
	led_signal <= s_ledsignal;
end Behav;