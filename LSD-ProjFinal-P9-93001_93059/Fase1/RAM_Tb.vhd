library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RAM_Tb is
end RAM_Tb;

architecture Stimulus of RAM_Tb is
	signal s_clk,s_writeEnable : std_logic;
	signal s_writeAddress, s_writeData : std_logic_vector(9 downto 0);
	signal s_readAddress, s_readData : std_logic_vector(9 downto 0);

	begin
		ram_ut : entity work.RAM(Behavioral)
			port map(Clk => s_clk,
					  writeEnable => s_writeEnable,
					  writeAddress => s_writeAddress,
					  writeData => s_writeData,
					  readAddress => s_readAddress,
					  readData => s_readData);
	
	Clk_process : process
		begin
		s_clk <= '0'; wait for 10 ns;
		s_clk <= '1'; wait for 10 ns;
	end process;
	
	stim_process : process
		begin
			wait for 5 ns;
			s_writeEnable <= '1';
			s_writeData    <= "0000001101";
			s_writeAddress <= "0000000000";
			wait for 20 ns;
			s_writeAddress <= "0000000001";
			s_writeData    <= "0101010101";
			wait for 20 ns;
			s_writeData    <= "0000000110";
			s_writeAddress <= "0000000100";
			wait for 20 ns;
			s_writeAddress <= "0000000111";
			wait for 20 ns;
			s_writeAddress <= "0000000000";
			wait for 20 ns;
			s_writeData <= "1001001001";
			wait for 20 ns;
			s_writeAddress <= "0000000011";
			wait for 20 ns;
			s_writeData <= "0100001110";
			wait for 20 ns;
			s_writeAddress <= "0000000111";
			wait for 20 ns;
			s_writeEnable <= '0';
			s_readAddress <= "0000000001";
			wait for 20 ns;
			s_readAddress <= "0000000000";
			wait for 20 ns;
			s_readAddress <= "0000000111";
			wait for 20 ns;
			s_readAddress <= "0000000100";
			wait for 50 ns;
		end process;
end Stimulus;
