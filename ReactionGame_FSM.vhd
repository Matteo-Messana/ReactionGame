library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reactionGameFSM is
	PORT (  	clk		: in STD_LOGIC;
			reset		: in STD_LOGIC;
			start_game 	: in STD_LOGIC;
			
			player1_input 	: in STD_LOGIC;
			player2_input 	: in STD_LOGIC;
	      		next_game_input : in STD_LOGIC;
			
			stim_LEDs			: out STD_LOGIC_VECTOR(6 downto 0);
	      		player1_LEDs			: out STD_LOGIC_VECTOR(2 downto 0);
	      		player2_LEDs			: out STD_LOGIC_VECTOR(2 downto 0);
			seven_segment_signals	 	: out STD_LOGIC_VECTOR(7 downto 0);
			an_signals			: out STD_LOGIC_VECTOR(3 downto 0)
		);
end reactionGameFSM;

architecture Behavioural of reactionGameFSM is

	type stateType is ( 
		idle, initializeScore, initializeSevenSegDisplay, initializeStimLEDS, 
		initializePseudoRandomDelay, initializeCountdown, coutndown, stimulus, play, 
		timeCapture, displayWinner, updateScore, gameOver);
	signal currentState, nextState : stateType;
	
	--declare internal signals here
	signal pseudoRandomDelayGenerator_enable_i, pseudoRandomDelayGenerator_reset_i : STD_LOGIC;
	signal delay_i : STD_LOGIC_VECTOR(3 downto 0);
	signal delayClockDivider_reset_i, delayClockDivider_enable_i, delayClockDivider_zero_i : STD_LOGIC;
	signal playClockDivider_reset_i, playClockDivider_enable_i : STD_LOGIC;
	signal secs_i, tenths_secs_i, hundreths_secs_i, thousandths_secs_i : STD_LOGIC_VECTOR(3 downto 0);
	signal lapRegister_reset_i, lapRegister_load_i : STD_LOGIC;
	signal lap_thousandths_secs_i, lap_hundredths_secs_i, lap_tenths_secs_i, lap_secs_i: STD_LOGIC_VECTOR(3 downto 0);
	signal lapRegisterMUX_selector_i : STD_LOGIC;
	signal digit_mux_thousandths_secs_i, digit_mux_hundredths_secs_i, digit_mux_tenths_secs_i, digit_mux_secs_i: STD_LOGIC_VECTOR(3 downto 0);
	signal digit_mux_slector_i : STD_LOGIC;
	signal time_digit_i : STD_LOGIC_VECTOR (3 downto 0);
	signal seven_segment_signals_i : STD_LOGIC_VECTOR (7 downto 0);
	signal data_i : STD_LOGIC_VECTOR ( 3 downto 0);
	signal dp_in_i : STD_LOGIC;
	signal digit_select_i, an_outputs_i : STD_LOGIC_VECTOR (3 downto 0);
	signal stimulus_enable_i : STD_LOGIC;
	signal stim_LEDs_i: STD_LOGIC_VECTOR(6 downto 0);
	signal player1_score_i, player2_score_i : STD_LOGIC_VECTOR(1 downto 0);
	signal player1_LEDs_i, player2_LEDs_i: STD_LOGIC_VECTOR(2 downto 0);
	signal seven_segment_digit_selector_reset : STD_LOGIC;
	--declare different components of FSM here
	
	component delayClockDivider_FSM is 
		PORT ( 	clk      : in  STD_LOGIC;
           		reset    : in  STD_LOGIC;
           		enable   : in  STD_LOGIC;
           		FSM_enable : out STD_LOGIC;
			set_digit : in STD_LOGIC_VECTOR (3 downto 0)
		      );
	end component;
		
	component digitMux_FSM is
  		PORT ( 
          		thousandths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          		hundredths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          		tenths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          		secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          		selector   : in  STD_LOGIC_VECTOR(3 downto 0);
          		time_digit : out STD_LOGIC_VECTOR(3 downto 0)
        		);
	end component;
		
	component lapRegisterMux_FSM is
		    PORT ( selector:						in STD_LOGIC;
			   thousandths_secs:				in STD_LOGIC_VECTOR(3 downto 0);
			   hundredths_secs:					in STD_LOGIC_VECTOR(3 downto 0);
			   tenths_secs:						in STD_LOGIC_VECTOR(3 downto 0);
			   secs:              				in STD_LOGIC_VECTOR(3 downto 0);
			   lap_thousandths_secs:    		in STD_LOGIC_VECTOR(3 downto 0);
			   lap_hundredths_secs:     		in STD_LOGIC_VECTOR(3 downto 0);
			   lap_tenths_secs:         		in STD_LOGIC_VECTOR(3 downto 0);
			   lap_secs:          				in STD_LOGIC_VECTOR(3 downto 0);
			   digit_mux_thousandths_secs :     out STD_LOGIC_VECTOR(3 downto 0);
			   digit_mux_hundredths_secs :   	out STD_LOGIC_VECTOR(3 downto 0);
			   digit_mux_tenths_secs :   		out STD_LOGIC_VECTOR(3 downto 0);
			   digit_mux_secs :   				out std_logic_vector(3 downto 0)
		      );
	end component;
		

	component lapRegister_FSM is
		    PORT ( clk:						in STD_LOGIC;
			   reset:					in STD_LOGIC;
			   load:					in STD_LOGIC;
			   thousandths_secs:        in STD_LOGIC_VECTOR(3 downto 0);
			   hundredths_secs:			in STD_LOGIC_VECTOR(3 downto 0);
			   tenths_secs :			in STD_LOGIC_VECTOR(3 downto 0);
			   secs:					in STD_LOGIC_VECTOR(3 downto 0);
			   lap_thousandths_secs :	out STD_LOGIC_VECTOR(3 downto 0);
			   lap_hundredths_secs :	out STD_LOGIC_VECTOR(3 downto 0);
			   lap_tenths_secs :		out STD_LOGIC_VECTOR(3 downto 0);
			   lap_secs:				out STD_LOGIC_VECTOR(3 downto 0)
		       );
	end component;
		
	component playClockDivider_FSM is	
		    PORT ( clk      				: in  STD_LOGIC;
			   reset    				: in  STD_LOGIC;
			   enable   				: in STD_LOGIC;
			   secs 					: out STD_LOGIC_VECTOR(3 downto 0);
			   tenths_secs 				: out STD_LOGIC_VECTOR(3 downto 0);
			   hundredths_secs 			: out STD_LOGIC_VECTOR(3 downto 0);
			   thousandths_secs 		: out STD_LOGIC_VECTOR(3 downto 0)     
		     );
	end component;
		
	component psuedoRandomDelayGenerator_FSM is
		  PORT (
			clk     : in STD_LOGIC;
			reset   : in STD_LOGIC;
			enable  : in STD_LOGIC;
			delay   : out STD_LOGIC_VECTOR (3 downto 0)  
			);
	end component;
		
	component seven_segment_decoder is
		    PORT ( 
			   seven_segment_signals : out STD_LOGIC_VECTOR(7 downto 0);
			   dp_in : in  STD_LOGIC;
			   data  : in  STD_LOGIC_VECTOR (3 downto 0)
			 );
	end component;
	
	component seven_segment_digit_selector is
		    PORT ( clk          : in  STD_LOGIC;
			   digit_select : out STD_LOGIC_VECTOR (3 downto 0);
			   an_outputs   : out STD_LOGIC_VECTOR (3 downto 0);
			   reset        : in  STD_LOGIC
			 );
	end component;
		
	component stimulus is
		       PORT ( 
			      enable         :   in STD_LOGIC;
			      LED9to15       :   out STD_LOGIC_VECTOR(6 downto 0)
		       );
	end component;
		
	BEGIN
	
	DELAY_GEN: psuedoRandomDelayGenerator_FSM
		PORT MAP(
				clk     => clk,
				reset   => pseudoRandomDelayGenerator_reset_i,
				enable  => pseudoRandomDelayGenerator_enable_i,
				delay   => delay_i
			);	
		
	DELAY_CD: delayClockDivider_FSM
		PORT MAP(
				clk      => clk,
				reset    => delayClockDivider_reset_i,
				enable   => delayClockDivider_enable_i,
				FSM_enable => delayClockDivider_zero_i,
				set_digit => delay_i
			);
		
	PLAY_CD: playClockDivider_FSM
		PORT MAP(
				clk      		=> clk,
			   	reset    		=> playClockDivider_reset_i,
			   	enable   		=> playClockDivider_enable_i,
			   	secs 			=> secs_i,
			   	tenths_secs 		=> tenths_secs_i,
			  	hundredths_secs 	=> hundredths_secs_i,
			   	thousandths_secs 	=> thousandths_secs_i
			);
		
	LAP_REG: lapRegister_FSM
		PORT MAP(
				clk			=> clk,
			   	reset			=> lapRegister_reset_i,
			   	load			=> lapRegister_load_i,
			   	thousandths_secs	=> thousandths_secs_i,
			   	hundredths_secs		=> hundredths_secs_i,
			   	tenths_secs 		=> tenths_secs_i,
			   	secs			=> secs_i,
			   	lap_thousandths_secs 	=> lap_thousandths_secs_i,
			   	lap_hundredths_secs	=> lap_hundredths_secs_i,
			   	lap_tenths_secs 	=> lap_tenths_secs_i,
			   	lap_secs:		=> lap_secs_i
			);
	LAP_MUX: lapRegisterMUX_FSM
		PORT MAP(
				selector			=> lapRegisterMUX_selector_i,
			   	thousandths_secs		=> thousandths_secs_i,
			   	hundredths_secs			=> hundredths_secs_i,
			   	tenths_secs			=> tenths_secs_i,
			   	secs				=> secs_i,
			   	lap_thousandths_secs		=> lap_thousandths_secs_i,
			   	lap_hundredths_secs		=> lap_hundredths_secs_i,
			   	lap_tenths_secs			=> lap_tenths_secs_i,
			   	lap_secs			=> lap_secs_i
			   	digit_mux_thousandths_secs	=> digit_mux_thousandths_secs_i,
			   	digit_mux_hundredths_secs	=> digit_mux_hundredths_secs_i,
			   	digit_mux_tenths_secs		=> digit_mux_tenths_secs_i,
			   	digit_mux_secs			=> digit_mux_secs_i,
			);
		
	DIGIT_MUX: digitMux_FSM
		PORT MAP(
				thousandths_secs   		=> thousandths_secs_i,
				hundredths_secs   		=> hundredths_secs_i,
				tenths_secs   			=> tenths_secs_i,
			   	secs				=> secs_i,
				selector   			=> digit_mux_slector_i,
				time_digit 			=> time_digit_i
			);
		
	SS_DECODER: seven_segment_decoder
		PORT MAP(
				seven_segment_signals 		=> seven_segment_signals_i,
			   	dp_in 				=> dp_in_i,
			   	data  				=> data_i
			);
		
	SS_SELECTOR: seven_segment_selector
		PORT MAP(
				clk          			=> clk,
			   	digit_select 			=> digit_select_i,
			   	an_outputs   			=> an_outputs_i,
			   	reset       			=> reset
			);
	STIM: stimulus
		PORT MAP(
				enable       			=> stimulus_enable_i,
			      	LED9to15       			=> stim_LEDs_i
			);
		
	FSM_Combinational_Logic: process(currentState)
	begin 
		case currentState is
		
		when idle => 
			if(start_game = '0')
				nextState = idle;
			elsif(start_game = '1')
				nextState = initializeGeneral;
			end if;
		
		--set of states to initialize the system after a reset/new round of games

		when initializeGeneral =>
			seven_segment_digit_selector_reset <= '1';	--sent reset to the digit selector 
			pseudoRandomDelayGenerator_reset_i <= '1';	--send reset to the random delay generator
			playClockDivider_reset_i <= '1';		--reset game time counter to zero
		
			stimulus_enable_i <= '0';			--make sure the stimulus LEDs are OFF

			lapRegisterMUX_selector_i <= '0'; 		--display game time to start
			nextState <= initializePseudoRandomDelay;
			
		when initializePseudoRandomDelay =>
			seven_segment_digit_selector_reset <= '0';	
			pseudoRandomDelayGenerator_reset_i <= '0';
			playClockDivider_reset_i <= '0';

			pseudoRandomDelayGenerator_enable_i <= '1';

			delayClockDivider_reset_i <= '1';
			nextState <= initializeCountdown;

		when initializeCountdown =
			delayClockDivider_reset_i <= '0';
			nextState <= countdown;
		
		--remember to reset the lap register load signal

		--end of initialization states
	
		when countdown =>
			delayClockDivider_enable_i <= '1';
			if(delayClockDivider_zero_i = '0') then
				nextState <= countdown;
			elsif(delayClockDivider_zero_i = '1') then
				nextState <= stimulus;
				delayClockDivider_enable_i <= '0';
			end if;
		
		when stimulus =>
			nextState <= play;
			stimulus_enable_i <= '1';
			playClockDivider_enable_i <= '1';
			
		when play => 
			if(player1_input = '1')then 
				nextState <= updatePlayer1Score;
				lapRegisterMUX_selector_i <= '1';
				lapRegister_load_i <= '1';
			elsif(player2_input = '1') then
				nextState <= updatePlayer2Score;
				lapRegisterMUX_selector_i <= '1';
				lapRegister_load_i <= '1';
			end if;
				
		when updatePlayer1Score => 
			NextState <= displayWinner;
			player1_score_i <= player1_score_i + '1';
		
		when updatePlayer2Score
			NextState <= displayWinner;
			player2_score_i <= player2_score_i + '1';
			
		when displayWinner
			if(next_game_input = '0') then
				nextState <= displayWinner;
			elsif(next_game_input = '1') then
				nextState <= initializeSevenSegDisplay;
			end if;
		end case;
			
	end process;
		
						
	FSM_State_Register : process(reset, clk)
	begin
		if reset = '1' then
			currentState <= idle;
		elsif rising_edge(clk) then
			currentState <= nextState;
		end if;
	end process;
	
	displayPlayerScore : process(reset, clk)
	begin 
		if(reset = '1') then
			player1_score_i := (others => '0');
			player2_score_i := (others => '0');
		elsif(rising_edge(clk)) then
			if(player1_score = "00") then
				player1_LEDs_i <= "000";
			elsif(player1_score = "01") then
				player1_LEDs_i <= "001";
			elsif(player1_score = "10") then
				player1_LEDs_i <= "011";
			elsif(player1_LEDs_i <= "11") then
				player1_LEDs_i <= "111";
			end if;
			
			if(player2_score = "00") then
				player2_LEDs_i <= "000";
			elsif(player2_score = "01") then
				player2_LEDs_i <= "001";
			elsif(player2_score = "10") then
				player2_LEDs_i <= "011";
			elsif(player2_LEDs_i <= "11") then
				player2_LEDs_i <= "111";
			end if;
		end if;
	end process
	
	stim_LEDs			<= stim_LEDs_i;
	player1_LEDs			<= player1_LEDs_i;
	player2_LEDs			<= player2_LEDs_i;
	seven_segment_signals	 	<= seven_segment_signals_i;
	an_signals			<= an_signals_i;
	
	
