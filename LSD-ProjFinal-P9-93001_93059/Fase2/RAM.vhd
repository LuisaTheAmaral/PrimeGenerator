library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity RAM is
	generic(addrBusSize : integer := 10;
			  dataBusSize : integer := 10);
	port(Clk 	            : in std_logic;
		  writeEnable        : in std_logic;
		  writeAddress 		: in std_logic_vector((addrBusSize - 1) downto 0);
		  writeData 			: in std_logic_vector((dataBusSize - 1) downto 0);
		  readAddress 			: in std_logic_vector((addrBusSize - 1) downto 0);
		  readData 				: out std_logic_vector((dataBusSize - 1) downto 0));
end RAM;

architecture Behavioral of RAM is
	constant NUM_WORDS : integer := (2 ** addrBusSize);
	subtype TDataWord is std_logic_vector((dataBusSize - 1) downto 0);
	type TMemory is array (0 to (NUM_WORDS - 1)) of TDataWord;
	signal s_memory : Tmemory;
begin

	process(Clk)
	begin
		if (rising_edge(Clk)) then
			if (writeEnable = '1') then
				s_memory(to_integer(unsigned(writeAddress))) <= writeData;
			end if;
				readData <= s_memory(to_integer(unsigned(readAddress)));
		end if;
	end process;
	
end Behavioral;