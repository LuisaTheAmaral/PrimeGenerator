library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CountertoRAM is
	port(clk : in std_logic;
		  clk_pulse : in std_logic;
		  reset : in std_logic;
		  enable : in std_logic;
		  count_cicle : in std_logic_vector(9 downto 0);
		  count : out std_logic_vector(9 downto 0));
end CountertoRAM;

architecture Behavioral of CountertoRAM is
	signal s_cnt, s_cicle : unsigned(9 downto 0) := "0000000000";
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			s_cicle <= unsigned(count_cicle);  --Aqui é defenido no sinal o valor final da contagem
			if(reset = '1') then
				s_cnt <= "0000000000"; 
			end if;
			if(enable = '1' and reset = '0') then
				if (clk_pulse = '1') then --a cada pulso de 1 Hz o valor incremnta mais 1
					s_cnt <= s_cnt + 1;
				end if;
				if(s_cnt = s_cicle) then --Quando o valor de saida (endereço) 
					s_cnt <= "0000000000";
				end if;
			end if;
		end if;
	end process;
	count <= std_logic_vector(s_cnt);
end Behavioral;
