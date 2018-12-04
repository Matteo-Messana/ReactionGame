library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reactionGame_FSM is
	PORT (  	 clk		: in STD_LOGIC;
			     reset		: in STD_LOGIC;
			     start_game 	: in STD_LOGIC;
			
			     player1_input 	: in STD_LOGIC;
			     player2_input 	: in STD_LOGIC;
	      		 next_game_input : in STD_LOGIC;
	      		 
	      		 delayClockDivider_zero : in STD_LOGIC;
	      		 
                 player1_win_enable      : in STD_LOGIC;
                 player2_win_enable      : in STD_LOGIC;
                 			
                 pseudoRandomDelaygenerator_reset : out STD_LOGIC;
                 delayClockDivider_reset : out STD_LOGIC;
                 lapRegister_reset : out STD_LOGIC;
                 playClockDivider_reset : out STD_LOGIC;
                 sevenSegmentDigitSelector_reset : out STD_LOGIC;   
                 pseudoRandomDelayGenerator_enable : out STD_LOGIC; 
                 delayClockDivider_enable : out STD_LOGIC; 
 	             stimulus_enable : out STD_LOGIC; 
                 playClockDivider_enable : out STD_LOGIC;  
                 letterDigitMUX_select : out STD_LOGIC;  
                 buzzer_enable : out STD_LOGIC;
                 
                 player1_score_enable : out STD_LOGIC;
                 player2_score_enable : out STD_LOGIC;
                 
                 lapRegister_load : out STD_LOGIC;
                 lapRegisterMUX_selector : out STD_LOGIC;
                 
                 winP1_LED3 : out STD_LOGIC;
                 winP2_LED7 : out STD_LOGIC
                 
		);
end reactionGame_FSM;

architecture Behavioural of reactionGame_FSM is

	type stateType is ( 
		idle, initializeScore, initializeSevenSegDisplay, initializeStimLEDS, initializeReset, delay_state, delay_state2,
		initializePseudoRandomDelay, initializeCountdown, countdown, visualSignal, play, flashP1Win, flashP2Win, checkWin,
		timeCapture, displayWinner, updatePlayer1Score, updatePlayer2Score, gameOver);
	signal currentState, nextState : stateType;
	
	

		
	BEGIN
	

		
	FSM_Combinational_Logic: process(currentState, player1_input, player2_input, clk)
	begin 
		case currentState is
		
		when idle => 
		    --buzzer_enable <= '1';
			if(start_game = '0') then
				nextState <= idle;
			else
				nextState <= initializeReset;
			end if;
		
		--set of states to initialize the system after a reset/new round of games
		when initializeReset =>
			nextState <= delay_state;
			
	    when delay_state => 
	       nextState <= initializePseudoRandomDelay;
			
		when initializePseudoRandomDelay =>
			nextState <= initializeCountdown;

		when initializeCountdown =>
			nextState <= delay_state2;
			
		when delay_state2 => 
             nextState <= countdown;
		
		--remember to reset the lap register load signal

		--end of initialization states
	
		when countdown =>
			if(delayClockDivider_zero = '1') then
				nextState <= play;
			else
				nextState <= countdown;
			end if;

		when play => 
	        if(player1_input = '1')then 
                nextState <= updatePlayer1Score;
            elsif(player2_input = '1') then
                nextState <= updatePlayer2Score;
		    else
		         nextState <= play;
			end if;
			
		when updatePlayer1Score =>
		  nextState <= checkWin;
		     
		when updatePlayer2Score  =>
		  nextState <= checkWin;
          
        when checkWin => 
        if(player1_win_enable = '1') then
          nextState <= flashP1Win;
        elsif(player2_win_enable = '1') then
            nextState <= flashP2Win;
        else   
          nextState <= displayWinner;
        end if;
        
			
		when displayWinner =>
			if(next_game_input = '0') then
				nextState <= displayWinner;
			else --elsif(next_game_input = '1') then
				nextState <= initializeReset;
			end if;
	
	    when flashP1Win =>
                nextState <= flashP1Win;
            
	    when flashP2Win =>
                 nextState <= flashP2Win;
			
	    when others =>
	       nextState <= idle;
	       
		end case;		
	end process;
		
						
	FSM_State_Register : process(reset, clk)
	begin
		if (reset = '1' or not(start_game) = '1') then
			currentState <= idle;
		elsif rising_edge(clk) then
			currentState <= nextState;
		end if;
	end process;
	
	
	INITIAL_DISPLAY : process(currentState,clk)
	begin
	   if(currentState = idle) then
	       letterDigitMUX_select <= '1';
	   else
	       letterDigitMUX_select <= '0';
	   end if;
	 end process;
	
	RESET_ALL: process(currentState)
	begin
	   if(currentState = initializeReset) then
	       --pseudoRandomDelaygenerator_reset <= '1';
	       delayClockDivider_reset <= '0';
	       lapRegister_reset <= '1';
	       playClockDivider_reset <= '1';
	       sevenSegmentDigitSelector_reset <= '1';
	   elsif(currentState = initializeCountdown)then --make sure that delayClockDivider_reset_i resets AFTER the delay for the round has been determined
	       --pseudoRandomDelaygenerator_reset <= '0';
           delayClockDivider_reset <= '1';
           lapRegister_reset <= '0';
           playClockDivider_reset <= '0';
           sevenSegmentDigitSelector_reset <= '0';
	   else
	       pseudoRandomDelaygenerator_reset <= '0';
           delayClockDivider_reset <= '0';
           lapRegister_reset <= '0';
           playClockDivider_reset <= '0';
           sevenSegmentDigitSelector_reset <= '0';
       end if;      
	end process;
	
	DELAY_GEN_EN: process(currentState)
	begin
	   if(currentState = initializePseudoRandomDelay) then
	       pseudoRandomDelayGenerator_enable <= '1';
	   else 
	       pseudoRandomDelayGenerator_enable <= '0';
	   end if;
    end process;
	
	CTDN_EN: process(currentState)
	begin
	   if(currentState = countdown) then
	       delayClockDivider_enable <= '1';
	   else 
	       delayClockDivider_enable <= '0';
	   end if;
	end process;
	
	PLAY_EN: process(currentState, clk)
	begin
	   if(currentState = play) then
	       stimulus_enable <= '1';
           playClockDivider_enable <= '1';
       else 
           stimulus_enable <= '0';
           playClockDivider_enable <= '0';
       end if;
	end process;
	
	P1_EN: process(currentState)
	begin
	   if(currentState = updatePlayer1Score) then
	       player1_score_enable <= '1';
	   else
	       player1_score_enable <= '0';
	   end if;
	end process;
	
	P2_EN: process(currentState)
    begin
       if(currentState = updatePlayer2Score) then
           player2_score_enable <= '1';
       else
           player2_score_enable <= '0';
       end if;
    end process;
	
	LAP_EN: process(currentState)
	begin
	   if(currentState = updatePlayer1Score) then
	       lapRegister_load <= '1';
	       lapRegisterMUX_selector <= '1';
	   elsif(currentState = updatePlayer2Score) then
	       lapRegister_load <= '1';
	       lapRegisterMUX_selector <= '1';
	   elsif(currentState = displayWinner) then
	       lapRegister_load <= '0';
	       lapRegisterMUX_selector <= '1';
	   else 
	       lapRegister_load <= '0';
	       lapRegisterMUX_selector <= '0';
	   end if;
	   	end process;
	   	
	  BUZZ: process(currentState, player1_win_enable, player2_win_enable)
	  begin    
	   if(currentState = flashP1Win)then
	       buzzer_enable <= '1';
	   elsif(currentState = flashP2Win) then
	       buzzer_enable <= '1';
	   else
	       buzzer_enable <= '0';
	   end if;
	   end process;
END;
	
