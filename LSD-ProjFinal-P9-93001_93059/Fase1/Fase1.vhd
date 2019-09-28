library IEEE;
use IEEE.std_logic_1164.all;

entity Fase1 is
	port(SW : 		 in std_logic_vector(9 downto 0);
		  KEY: 		 in std_logic_vector(2 downto 0);
		  CLOCK_50:  in std_logic;
		  HEX0:		out std_logic_vector(6 downto 0);
		  HEX1:		out std_logic_vector(6 downto 0);
		  HEX2:		out std_logic_vector(6 downto 0);
		  HEX3:		out std_logic_vector(6 downto 0);
		  LEDG:     out std_logic_vector(2 downto 0);
		  LEDR:     out std_logic_vector(3 downto 0));
end Fase1;

Architecture Structural of Fase1 is
	signal s_clock, s_key0, s_key1, s_key2, s_loadmin, s_loadmax, s_enableprime, s_loadcounter, s_enable, s_clock1h, s_found, s_pulse2hz, s_endisplay, s_ledcontrol : std_logic;
	signal s_mino, s_maxo, s_count, s_displayBin, s_num : std_logic_vector(9 downto 0);
	signal s_m, s_d, s_c, s_u: std_logic_vector(3 downto 0);
	signal s_validOut, s_done, s_read_en, s_end : std_logic;
	signal s_writeadd : std_logic_vector(9 downto 0);
	signal s_readadd, s_readdata : std_logic_vector(9 downto 0);

begin

--######  Frequency ######

	clock: entity work.ClkDividerN(RTL)--Divide a frequência do clock 50 para um clock de 25 Mhz comum a todo o sistema
		generic map(k => 2)
		port map(clkIn => CLOCK_50,
					clkOut => s_clock);
		
	clock_enable_1Hz: entity work.ClkEnableGenerator(Behavioral)  --Clock Enable o
		generic map(count => 25000000) 
		port map(clk50MHz => s_clock,
					clkEnable => s_clock1h);
	
	clock_2: entity work.ClkDividerN(RTL)
		generic map(k => 12500000)
		port map(clkIn => s_clock,
					clkOut => s_pulse2hz);

--######  Debouncer ######
					
	debounce0: entity work.DebounceUnit(Behavioral)	
			generic map(kHzClkFreq => 50000,
						mSecMinInWidth => 50, 
						inPolarity  => '0',
						outPolarity => '1')
			port map (refClk => s_clock,
						 dirtyIn => KEY(0),
						 pulsedOut => s_key0);
				
	debounce1: entity work.DebounceUnit(Behavioral)	
	generic map(kHzClkFreq => 50000,
						mSecMinInWidth => 50, 
						inPolarity  => '0',
						outPolarity => '1')
			port map (refClk => s_clock,
						 dirtyIn => KEY(1),
						 pulsedOut => s_key1);
						 
	debounce2: entity work.DebounceUnit(Behavioral)	
	generic map(kHzClkFreq => 50000,
						mSecMinInWidth => 50, 
						inPolarity  => '0',
						outPolarity => '1')
			port map (refClk => s_clock,
						 dirtyIn => KEY(2),
						 pulsedOut => s_key2);
				
--###### Maquina de estados final que controla o sistema ######				
			
	control_unit: entity work.control_now(MealyArch)				
		  port map(clk => s_clock,
					  reset =>  s_key0,
		           save =>  s_key1,
					  start =>  s_key2,
					  min_value => s_mino,
					  max_value => s_maxo,
		           loadmin => s_loadmin,
		           loadmax => s_loadmax,
					  done    => s_done,
					  v1      => LEDG(0),
					  v2      => LEDG(1),
		           enablePrime => s_enableprime);

	
--######  Registers para salvar o valor mínimo e o maximo   ######					
	REG_unitmin: entity work.RegN(Behavioral)
		port map(clk => s_clock,
					load => s_loadmin,
					reset =>  s_key0,
					dataIn => SW(9 downto 0),
					dataOut => s_mino);
					
					
	REG_unitmax: entity work.RegN(Behavioral)
			port map(clk => s_clock,
						load => s_loadmax,
						reset =>  s_key0,
						dataIn => SW(9 downto 0),
						dataOut => s_maxo);

-- ###### Maquína de estados que varre o intervalo e grava para uma memória os valores primos ######
	FSM_primes: entity work.isPrime(MealyArch)
			port map(clk => s_clock,	
						reset => s_key0,
						start => s_enableprime,
						vmin => s_mino,
						vmax => s_maxo,
						data_out => s_count,
						save_add => s_writeadd,
						found_prime => S_found,
						save_enable => s_validOut,
						done => s_end);
-- ###### Memória ######						
	Memory: entity work.RAM(Behavioral)
		generic map(addrBusSize => 10,
					  dataBusSize => 10)
			port map(Clk => s_clock,
						writeEnable => s_validOut,
						writeAddress => s_writeadd,   --estes valores vêm do isPrime porque são os endereços
						writeData => s_count,         --estes valores vêm do isPrime porque são os números que vão ser guardados na memória
						readAddress => s_readadd,     --vem do CountertoRAM
						readData => s_readdata);      --vai para os displays	

-- ###### Contador ciclico que fornece addresses para a memória ######						
	Fetch_from_address_test : entity work.CountertoRAM(Behavioral)
			port map(clk => s_clock,
			         clk_pulse => s_clock1h,
						reset =>  s_key0,
						enable => s_end,
						count_cicle => s_writeadd,
						count => s_readadd);
						
	LEDG(2)<= s_end;
						
--é preciso um counter para o address que vá até ao número de palavras a serem introduzidas.
--depois adiciona-se a memória para guardar os números

--######    Unidade para fazer piscar o led ou não ######				
	Led_Blink : entity work.blink(Behav)
		port map(found_prime      => s_found,
					enable           => s_end,
					clk_pulse        => s_pulse2hz,
					display_enable   => s_endisplay,
					led_signal       => s_ledcontrol);
					
--###### Envia o sinal do LED ######	
	LEDR(0) <= s_ledcontrol;
	LEDR(1) <= s_ledcontrol;
	LEDR(2) <= s_ledcontrol;
	LEDR(3) <= s_ledcontrol;


--###### Bin to BCD #######	
	Bin_2_BCD: entity work.Bin2BCD(Behavioral)
		port map(BinIn => s_readdata,
					m => s_m,
				   c => s_c,
					d => s_d,
					u => s_u);

				
--###### Bin to 7 segments digits #######
		
	dm_c: entity work.Bin7SegDecoder(Behavioral)
		port map(enable => s_endisplay,
					binInput => s_m,
					decOut_n => HEX3(6 downto 0));
					
	dc_c: entity work.Bin7SegDecoder(Behavioral)
		port map(enable => s_endisplay,
					binInput => s_c,
					decOut_n => HEX2(6 downto 0));
					
	dd_c: entity work.Bin7SegDecoder(Behavioral)
		port map(enable => s_endisplay,
					binInput => s_d,
					decOut_n => HEX1(6 downto 0));
	
	du_c: entity work.Bin7SegDecoder(Behavioral)
		port map(enable => s_endisplay,
					binInput => s_u,
					decOut_n => HEX0(6 downto 0));
end Structural;
