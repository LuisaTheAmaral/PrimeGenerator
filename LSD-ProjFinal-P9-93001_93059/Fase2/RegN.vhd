library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RegN is
	generic(size	 : positive := 10);
	port(clk			 : in  std_logic;
		 load	    : in  std_logic;
		 -- enable		 : in  std_logic;
		  reset		 : in  std_logic;
		  dataIn		 : in  std_logic_vector((size - 1) downto 0);
		  dataOut	 : out std_logic_vector((size - 1) downto 0));
end RegN;

architecture Behavioral of RegN is
	signal s_load : std_logic_vector((size - 1) downto 0);
begin
	reg_proc : process(clk)
	begin
		if (rising_edge(clk)) then
			if (load = '1') then
				s_load <= dataIn;
			else
				s_load <= s_load;
			end if;
		end if;
	end process;
	dataOut <= s_load;
end Behavioral;
