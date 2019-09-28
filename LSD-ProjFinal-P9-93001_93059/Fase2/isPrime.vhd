library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity isPrime is

	port(clk	       			            :	in std_logic;
		  reset, start		        		   :  in std_logic;
		  Vmin, Vmax			     			:  in std_logic_vector(9 downto 0);
		  data_out, save_add       		:  out std_logic_vector(9 downto 0);
		  found_prime, save_enable, done :  out std_logic);
		  
end isPrime;

Architecture MealyArch of isPrime is
 type MyST is(s_init, s_receiveValue, s_checkNum, s_isnotPrime, s_isPrime, s_test, s_address);
 signal s_state : MyST := s_init;
 signal s_testfinal, s_valueMin, s_valueMax : integer := 0;
 signal s_testnum : integer;
 signal s_num : integer;
 signal s_outnext, s_svenable, s_done : std_logic;
 signal s_foundPrime : std_logic := '0';
 signal s_svadd : unsigned(9 downto 0) := to_unsigned(0, 10);
 
begin 
	
--###### Máquina de estados que identifica primos #######

	prime_controler:process(clk)
	begin
		if(rising_edge(clk)) then
					if (reset = '1') then 
						s_state <= s_init;
						s_done <= '0';
						s_svadd <= to_unsigned(0, 10);
						s_foundPrime <= '0';
					else 
					
						case s_state is
							
--###### ESTADO INICIAL #######
							when s_init =>
								if(start = '1') then
									s_svenable <= '0';
									s_num <= to_integer(unsigned(Vmin));
									s_valueMax <= to_integer(unsigned(Vmax));
									s_testnum <= 2;
									s_state <= s_receiveValue;
									s_done <= '0';
								else
									s_state <= s_init;
									s_done <= '0';
									--s_svadd <= to_unsigned(0, 10);
								end if;
								
--###### EXCLUI 0, 1, 2 E 3 #######							
								
							when s_receiveValue =>
								if (s_num = 2 or s_num = 3) then 
									s_state <= s_isPrime;
									s_done <= '0';
								elsif(s_num = 0 or s_num = 1) then
									s_state <= s_isnotPrime;
									s_done <= '0';
									s_foundPrime <= '0';
								else
									s_state <= s_checkNum;
									s_done <= '0';
								end if;
							
--###### REALIZA AS DIVISÕES PARA VERIFICAR O RESTO #######							
							
							when s_checkNum =>
							s_svenable <= '0';
							s_valueMax <= to_integer(unsigned(Vmax));
							s_testfinal <= ((s_num / 2) + 1);
							s_done <= '0';
							
							if((s_num rem 2) = 0) then --Se o número for par (o resto da divisão por 2 = 0) não é primo; 
								s_state <= s_isnotPrime;
							else
								if (s_num rem s_testnum = 0) then
									s_state <= s_isnotPrime;
								else
									s_state <= s_test;
								end if;
							end if;

--###### INCREMENTA POSSÍVEIS DIVISORES #######								
							
							when s_test =>
								s_testfinal <= ((s_num / 2) + 1);
								s_done <= '0';
								if(s_testnum <= s_testfinal) then
									s_testnum <= s_testnum + 1;
									s_state <= s_checkNum;
								else
									s_state <= s_isPrime;
								end if;
								
--###### DETETAÇÃO DE UM NÚMERO PRIMO #######									
								
							when s_isPrime =>
								s_foundPrime <= '1';
								--s_dataOut <= to_unsigned(s_num, 10);
								--s_done <= '0';
								
								if(s_num <= s_valueMax) then

									s_done <= '0';
									s_svenable <= '1';
									s_state <= s_address;
								
								else
									s_done <= '1';   --aqui era 1
									s_state <= s_isPrime;
									s_svenable <= '0';
								end if;

--###### DETEÇÃO DE UM NÚMERO NÃO PRIMO #######	
								
								
							when s_isnotPrime =>
								s_svenable <= '0';
								if(s_num <= s_valueMax) then
									s_num <= s_num + 1;
									s_testnum <= 2;
									s_done <= '0';
									s_state <= s_receiveValue;
								else
									s_done <= '1';  
									--s_foundPrime <= '0'; 
									s_state <= s_isnotPrime;
								end if;

--###### DEVOLVE UM ENDEREÇO PARA GUARDAR O NÚMERO PRIMO NA MEMÓRIA #######
								
							when s_address =>
								s_num <= s_num + 1;
								s_testnum <= 2;
								s_svadd <= s_svadd + 1;
								s_svenable <= '0';
								s_state <= s_receiveValue;
								s_done <= '0';
						end case;
				end if;
		end if;	
   end process;			
		
		data_out <= std_logic_vector(to_unsigned(s_num, 10));
		save_add <= std_logic_vector(s_svadd);
		found_prime <= std_logic(s_foundPrime);
		save_enable <= std_logic(s_svenable);
		done <= std_logic(s_done);	
		
end MealyArch;
