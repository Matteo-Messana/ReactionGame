library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reactionGameFSM is
	PORT (  clk			: in STD_LOGIC;
			reset		: in STD_LOGIC;
			START_GAME 	: in STD_LOGIC;
			
			PLAYER1_INPUT : in STD_LOGIC;
			PLAYER2_INPUT : in STD_LOGIC;
			
			STIM_LED			: out STD_LOGIC_VECTOR(6 downto 0);
			SEVEN_SEG_SIGNALS 	: out STD_LOGIC_VECTOR(7 downto 0);
			AN_SIGNALS			: out STD_LOGIC_VECTOR(3 downto 0);
		);
end reactionGameFSM;

architecture Behavioural of reactionGameFSM is

	type stateType is ( 
		idle, initializeScore, initializeSevenSegDisplay, initializeStimLEDS, 
		initializePseudoRandomDelay, initializeCountdown, coutndown, stimulus, play, 
		timeCapture, displayWinner, updateScore, gameOver);
	signal currentState, nextState : stateType;
	
	--declare internal signals here
	
	--declare different components of FSM here
	
	FSM_Combinational_Logic: process( )
	begin 
		case currentState is
		
		when idle => 
			if(START_GAME = '0')
				nextState = idle;
			elsif(START_GAME = '1')
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
		
	
	
