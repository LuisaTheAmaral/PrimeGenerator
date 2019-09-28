library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Fase1_Tb is
end Fase1_Tb;

architecture Stimulus of Fase1_Tb is
	signal s_clk,s_writeEnable : std_logic;
	signal s_sw : std_logic_vector(9 downto 0);
	signal s_ledg, s_key : std_logic_vector(2 downto 0);
	signal s_ledr: std_logic_vector(3 downto 0);
	signal s_hex0,s_hex1,s_hex2,s_hex3 : std_logic_vector(6 downto 0);


	begin
		fase_utt : entity work.Fase1(Structural)
			port map(SW => s_sw,
						KEY => s_key,
						CLOCK_50=> s_clk,
						HEX0 => s_hex0,
						HEX1 => s_hex1,
						HEX2 => s_hex2,
						HEX3 => s_hex3,
						LEDG => s_ledg,
						LEDR => s_ledr);
	
	Clk_process : process
		begin
		s_clk <= '0'; wait for 10 ns;
		s_clk <= '1'; wait for 10 ns;
	end process;
	
	stim : process
		begin
			wait for 2 ns;
			s_sw<="0000000001";
			s_key<="001";
			wait for 23 ns;
			s_sw<="0000001111";
			s_key<="010";
			wait for 23 ns;
						s_key <= "100";
			wait for 1000 ns;
	end process;
	
end Stimulus;