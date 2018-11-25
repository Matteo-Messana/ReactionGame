library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reactionGameFSM is
	PORT (  clk			: in STD_LOGIC;
			reset		: in STD_LOGIC;
			start_game 	: in STD_LOGIC;
			
			player1_input 	: in STD_LOGIC;
			player2_input 	: in STD_LOGIC;
			
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
			
			);
		
	SS_DECODER: seven_segment_decoder
		PORT MAP(
			
			);
		
	SS_SELECTOR: seven_segment_selector
		PORT MAP(
			
			);
	STIM: stimulus
		PORT MAP(
			
			);
		
	FSM_Combinational_Logic: process(currentState)
	begin 
		case currentState is
		
		when idle => 
			if(start_game = '0')
				nextState = idle;
			elsif(start_game = '1')
				nextState = initializeScore;
			end if;
		
		--set of states to initialize the system after a reset/new round of games
		when initializeScore =>
			--add functionality
			nextState <= initializeSevenSegDisplay;
		when initializeSevenSegDisplay =>
			--add functionality
			nextState <= initializeStimLEDS;
		
		when initializeStimLEDS =>
			--add functionality
			nextState <= initializeGameWatch;
			
		when initializeGameWatch => 
			--add functionality
			nextState <= initializePseudoRandomDelay;
			--add functionality
		when initializePseudoRandomDelay =>
			--add functionality
			nextState <= initializeCountdown;
		when initializeCountdown =
			--add functionality
			nextState <= countdown;
		
		--end of initialization states
	
		when countdown
			--check the zero output of the countdown module
			--move to next state once the countdown reaches zero
			--explicitly disable the countdown
			
		when stimulus
			--flash the stimulus LEDS -> pretty much set all to 1
			--enable the count-up feature
			
		when play
			--wait for inputs from the players
			--if(player1BTN) then 
				--sends a signal to the lap register
				--nextState <= updatePlayer1Score
			--elsif(player2BTN) then
				--sends a signal to the lap register
				--nextState <= updatePlayer2Score
				
		when updatePlayer1Score
			--Updates player 1 score
			--Updates round counter
			--Sends off to display winner
			--nextState <= displayWinner
		
		when updatePlayer2Score
			--Updates player 2 score
			--Updates round counter
			--Sends off to display winner
			--nextState <= displayWinner
			
		when displayWinner
			--Recieve lap register's time and display
			--transition into next round
			--nextState <= initializeSevenSegDIsplay
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
	
	--add functionality
	
	end process
		
	
	
