library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reactionGameTopLevel is
    PORT(
            clk		           : in STD_LOGIC; --On Board
            reset               : in STD_LOGIC; --SW0 (**********NEED TO CHANGE IN THE VGA MODULE MAPPING**********)
            start_game          : in STD_LOGIC; --SW1 (**********NEED TO LINK WITH THE START FUNCTIONALITY IN VGA MODULE**********)
            
            player1_input       : in STD_LOGIC; --Right Button
            player2_input       : in STD_LOGIC; --Left Button
            next_game_input     : in STD_LOGIC; --Centre Button
            
            stim_LED9               : out STD_LOGIC;
            stim_LED10              : out STD_LOGIC;
            stim_LED11              : out STD_LOGIC;
            stim_LED12              : out STD_LOGIC;
            stim_LED13              : out STD_LOGIC;
            stim_LED14              : out STD_LOGIC;
            stim_LED15              : out STD_LOGIC;
            
            player1_LED0            : out STD_LOGIC;
            player1_LED1            : out STD_LOGIC;
            player1_LED2            : out STD_LOGIC;
            
            player2_LED4            : out STD_LOGIC;
            player2_LED5            : out STD_LOGIC;
            player2_LED6            : out STD_LOGIC;
            
            P1Win_LED3               : out STD_LOGIC;
            P2Win_LED7               : out STD_LOGIC;
            
            CA                      : out STD_LOGIC;
            CB                      : out STD_LOGIC;
            CC                      : out STD_LOGIC;
            CD                      : out STD_LOGIC;
            CE                      : out STD_LOGIC;
            CF                      : out STD_LOGIC;
            CG                      : out STD_LOGIC;
            DP                      : out STD_LOGIC;
            
            AN1                     : out STD_LOGIC;
            AN2                     : out STD_LOGIC;
            AN3                     : out STD_LOGIC;
            AN4                     : out STD_LOGIC;
            
            Buzzer_Ring                  : out STD_LOGIC;
            
            --System Outputs from VGA Display Module--
            VGA_hsync                   : out STD_LOGIC;
            VGA_vsync                   : out STD_LOGIC;
            VGA_red: out STD_LOGIC_VECTOR(3 downto 0);
            VGA_green: out STD_LOGIC_VECTOR(3 downto 0);
            VGA_blue: out STD_LOGIC_VECTOR(3 downto 0)
            
            --TODO: ADD hsync, vsync, red, green, blue as OUTPUTS to this system (DONE)

    );
end reactionGameTopLevel;

architecture Behavioral of reactionGameTopLevel is

	signal pseudoRandomDelayGenerator_enable_i, pseudoRandomDelayGenerator_reset_i : STD_LOGIC;
	signal delay_i : STD_LOGIC_VECTOR(3 downto 0);
	signal delayClockDivider_reset_i, delayClockDivider_enable_i, delayClockDivider_zero_i : STD_LOGIC;
	signal playClockDivider_reset_i, playClockDivider_enable_i : STD_LOGIC;
	signal letterDigitMUX_select_i : STD_LOGIC;
	signal secs_i, tenths_secs_i, hundredths_secs_i, thousandths_secs_i : STD_LOGIC_VECTOR(3 downto 0);
	signal lapRegister_reset_i, lapRegister_load_i : STD_LOGIC;
	signal lap_thousandths_secs_i, lap_hundredths_secs_i, lap_tenths_secs_i, lap_secs_i: STD_LOGIC_VECTOR(3 downto 0);
	signal lapRegisterMUX_selector_i : STD_LOGIC;
	signal digit_mux_thousandths_secs_i, digit_mux_hundredths_secs_i, digit_mux_tenths_secs_i, digit_mux_secs_i: STD_LOGIC_VECTOR(3 downto 0);
	signal digit_mux_slector_i : STD_LOGIC_VECTOR(3 downto 0);
	signal time_digit_i : STD_LOGIC_VECTOR (3 downto 0);
	signal display_value_i: STD_LOGIC_VECTOR (3 downto 0);
	signal seven_segment_signals_i : STD_LOGIC_VECTOR (7 downto 0);
	signal data_i : STD_LOGIC_VECTOR ( 3 downto 0);
	signal dp_in_i : STD_LOGIC;
	signal digit_select_i, an_outputs_i : STD_LOGIC_VECTOR (3 downto 0);
	signal stimulus_enable_i : STD_LOGIC;
	signal stim_LEDs_i: STD_LOGIC_VECTOR(6 downto 0);
	signal player1_LEDs_i, player2_LEDs_i: STD_LOGIC_VECTOR(2 downto 0);
	signal sevenSegmentDigitSelector_reset_i : STD_LOGIC;
	signal scoreKeeper_reset_i, player1_score_enable_i, player2_score_enable_i : STD_LOGIC;
	signal player1_win_enable_i, player2_win_enable_i : STD_LOGIC;
	signal P1Win_LED_i, P2Win_LED_i : STD_LOGIC;
	signal letter_i : STD_LOGIC_VECTOR (3 downto 0);
	signal buzzer_signal_i : STD_LOGIC;
	signal buzzer_enable_i : STD_LOGIC;
	signal buzzer_zero_i :STD_LOGIC;
	signal start_signal_i: STD_LOGIC;
	signal win_signal_i:STD_LOGIC;
	signal title_buzz : STD_LOGIC;
	signal win_buzz : STD_LOGIC;
	signal title_song_i : STD_LOGIC;
	signal win_song_i : STD_LOGIC;
	signal stim_song_i : STD_LOGIC;
	signal title_i : STD_LOGIC;
	signal stim_song_reset : STD_LOGIC;
	signal win_song_reset : STD_LOGIC;
	signal win_i : STD_LOGIC;
	
    --Internal Signals from VGA Module
    signal red_i, green_i, blue_i : STD_LOGIC_VECTOR(3 downto 0);
    signal vsync_i, hsync_i : STD_LOGIC;
    signal player_1_score_i, player_2_score_i : STD_LOGIC_VECTOR(1 downto 0);

    component reactionGame_FSM is
        PORT (
                clk		: in STD_LOGIC;
                reset        : in STD_LOGIC;
                start_game     : in STD_LOGIC;
                    
                player1_input     : in STD_LOGIC; --inputs needed by the FSM logic
                player2_input     : in STD_LOGIC; --inputs needed by the FSM logic
                next_game_input : in STD_LOGIC;
                           
                delayClockDivider_zero : in STD_LOGIC; --inputs needed by the FSM logic
                
                player1_win_enable : in STD_LOGIC;
                player2_win_enable : in STD_LOGIC;
                    
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
                
                --scoreKeeper_reset : out STD_LOGIC;
                player1_score_enable : out STD_LOGIC;
                player2_score_enable : out STD_LOGIC;     
                
                lapRegister_load : out STD_LOGIC;
                lapRegisterMUX_selector : out STD_LOGIC; 
                
                winP1_LED3 : out STD_LOGIC;
                winP2_LED7 : out STD_LOGIC
             );
    end component;
    
    component delayClockDivider_FSM is 
		PORT ( 	clk      : in  STD_LOGIC;
           		reset    : in  STD_LOGIC;
           		enable   : in  STD_LOGIC;
           		FSM_enable : out STD_LOGIC; --change this name
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
		
	component sevenSegmentDecoder_FSM is
		    PORT ( 
			   seven_segment_signals : out STD_LOGIC_VECTOR(7 downto 0);
			   dp_in : in  STD_LOGIC;
			   data  : in  STD_LOGIC_VECTOR (3 downto 0)
			 );
	end component;
	
	component sevenSegmentDigitSelector_FSM is
		    PORT ( clk      : in  STD_LOGIC;
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
	
	component scoreKeeper is
        PORT(   
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                
                player1_score_enable : in STD_LOGIC;
                player2_score_enable : in STD_LOGIC;
                
                player1_LEDs            : out STD_LOGIC_VECTOR(2 downto 0);
                player2_LEDs            : out STD_LOGIC_VECTOR(2 downto 0);
                
                player1_win_enable           : out STD_LOGIC;
                player2_win_enable           : out STD_LOGIC;
                
                player1_score           : out STD_LOGIC_VECTOR(1 downto 0);
                player2_score           : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    component letterDigitMUX_FSM is
        PORT(
             LetterValue : in STD_LOGIC_VECTOR (3 downto 0);
             DigitValue : in STD_LOGIC_VECTOR (3 downto 0);
             selector : in STD_LOGIC;
             DisplayValue : out STD_LOGIC_VECTOR (3 downto 0)
             );
    end component;
    
    component letterMUX_FSM is
      PORT ( 
              selector   : in  STD_LOGIC_VECTOR(3 downto 0);
              letter : out STD_LOGIC_VECTOR(3 downto 0)
            );
    end component;
    
    component buzzerModule_FSM is
    Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            enable_flipflop : in STD_LOGIC;
            buzzer_signal : out STD_LOGIC
          );
    end component;
    
    component downcounter is
    GENERIC (
                 period  : integer := 4;
                 WIDTH   : integer := 3
             );
    PORT    (
                clk:    in STD_LOGIC;
                reset:  in STD_LOGIC;
                enable: in STD_LOGIC;
                zero:   out STD_LOGIC
              );
     end component;
     
     component upcounter_FSM is
        Generic ( period : integer:= 4;
                  WIDTH  : integer:= 3
                );
           PORT (  clk    : in  STD_LOGIC;
                   reset  : in  STD_LOGIC;
                   enable : in  STD_LOGIC;
                   zero   : out STD_LOGIC;
                   value  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
                );
     end component;
     
     component vga_module is
         Port (  clk : in  STD_LOGIC;
                 reset: in STD_LOGIC; --TODO: Don't need this -> change to a straight reset signal
                 mode: in STD_LOGIC; --TODO: Needs to be changed to be a single signal for MODE that will be controlled by SW1 (from top-level)
                 stimulus_enable : in STD_LOGIC;
                 player1_win_enable : in STD_LOGIC;
                 player2_win_enable : in STD_LOGIC;
                 player_1_score : in STD_LOGIC_VECTOR(1 downto 0);
                 player_2_score : in STD_LOGIC_VECTOR(1 downto 0);
                 secs   : in STD_LOGIC_VECTOR(3 downto 0);
                 tenths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
                 hundredths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
                 thousandths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
                 red: out STD_LOGIC_VECTOR(3 downto 0);
                 green: out STD_LOGIC_VECTOR(3 downto 0);
                 blue: out STD_LOGIC_VECTOR(3 downto 0);
                 hsync: out STD_LOGIC;
                 vsync: out STD_LOGIC
          );
     end component;

        component Game_Win_FSM is
          Port (
                clk : in STD_LOGIC;
              reset : in STD_LOGIC;
              start : in STD_LOGIC;
              buzzer : out STD_LOGIC
                 );
        end component;
        
        component Title_Screen_FSM is
          Port (
                clk : in STD_LOGIC;
              reset : in STD_LOGIC;
              start : in STD_LOGIC;
              buzzer : out STD_LOGIC
                 );
        end component;

         component Stim_Sound is
             Port (
                 clk : in STD_LOGIC;
                 reset : in STD_LOGIC;
                 start : in STD_LOGIC;
                 buzzer : out STD_LOGIC
             );
            end component;

begin

stim_song_reset <= NOT(stimulus_enable_i) OR reset;
win_song_reset <= NOT((player1_win_enable_i OR player2_win_enable_i)) OR reset;
win_i <= (player1_win_enable_i OR player2_win_enable_i);
title_i <= NOT(start_game);

REACT_FSM: reactionGame_FSM 
        PORT MAP(
                clk		=> clk,
                reset   => reset,
                start_game     => start_game,
                            
                player1_input     => player2_input,
                player2_input     => player1_input,
                next_game_input   => next_game_input,
                                   
                delayClockDivider_zero => delayClockDivider_zero_i,
                
                player1_win_enable =>  player1_win_enable_i,
                player2_win_enable =>  player2_win_enable_i,
                            
                pseudoRandomDelaygenerator_reset => pseudoRandomDelaygenerator_reset_i,
                delayClockDivider_reset => delayClockDivider_reset_i,
                lapRegister_reset => lapRegister_reset_i,
                playClockDivider_reset => playClockDivider_reset_i,
                sevenSegmentDigitSelector_reset => sevenSegmentDigitSelector_reset_i, 
                pseudoRandomDelayGenerator_enable => pseudoRandomDelayGenerator_enable_i,
                delayClockDivider_enable => delayClockDivider_enable_i,
                stimulus_enable => stimulus_enable_i,
                playClockDivider_enable => playClockDivider_enable_i,  
                letterDigitMUX_select => letterDigitMUX_select_i,
                buzzer_enable => buzzer_enable_i,
                
                player1_score_enable => player1_score_enable_i,
                player2_score_enable => player2_score_enable_i,
                
                lapRegister_load => lapRegister_load_i,
                lapRegisterMUX_selector => lapRegisterMUX_selector_i,
                
                winP1_LED3 => P1Win_LED_i,
                winP2_LED7 => P2Win_LED_i
                );

DELAY_GEN: psuedoRandomDelayGenerator_FSM
		PORT MAP(
				clk     => clk,
				reset   => reset,
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
			   	lap_secs		=> lap_secs_i
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
			   	lap_secs			=> lap_secs_i,
			   	digit_mux_thousandths_secs	=> digit_mux_thousandths_secs_i,
			   	digit_mux_hundredths_secs	=> digit_mux_hundredths_secs_i,
			  	digit_mux_tenths_secs		=> digit_mux_tenths_secs_i,
			   	digit_mux_secs			=> digit_mux_secs_i
			);
		
	DIGIT_MUX: digitMux_FSM
		PORT MAP(
				thousandths_secs   		=> thousandths_secs_i,
				hundredths_secs   		=> hundredths_secs_i,
				tenths_secs   			=> tenths_secs_i,
			   	secs				=> secs_i,
				selector   			=> digit_select_i,
				time_digit 			=> time_digit_i
			);
		
	SS_DECODER: sevenSegmentDecoder_FSM
		PORT MAP(
				seven_segment_signals 		=> seven_segment_signals_i,
			   	dp_in 				=> dp_in_i,
			   	data  				=> display_value_i
			);
		
	SS_SELECTOR: sevenSegmentDigitSelector_FSM
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
			
	SC_KEEP: scoreKeeper
	   PORT MAP(
	            clk                    => clk,
	            reset                  => reset,
	            player1_score_enable   => player1_score_enable_i,
	            player2_score_enable   => player2_score_enable_i,
	            player1_LEDs           => player1_LEDs_i,
	            player2_LEDs           => player2_LEDs_i,
	            player1_win_enable     => player1_win_enable_i,
	            player2_win_enable     => player2_win_enable_i,
	            player1_score          => player_1_score_i,
	            player2_score          => player_2_score_i
	           );
	           
	  LET_MUX: letterMUX_FSM
	    PORT MAP(
	             selector => digit_select_i,
	             letter => letter_i
	             );
	             
	   LD_MUX: letterDigitMUX_FSM
	       PORT MAP(
	                 LetterValue => letter_i,
	                 DigitValue => time_digit_i,
	                 selector => letterDigitMUX_select_i,
	                 DisplayValue => display_value_i
	                 );
	                 
	   BUZZER_COUNTDOWN: downcounter
            GENERIC MAP(
                            period  => (12500),
                            WIDTH   => 14
                     )
            PORT MAP(
                          clk => clk,
                          reset => reset,
                          enable => buzzer_enable_i,
                          zero =>   buzzer_zero_i
                     );
	                 
	    BUZZER_ACTIVATE: buzzerModule_FSM
	       PORT MAP(
	                 clk => clk,
	                 reset => reset,
	                 enable_flipflop => buzzer_zero_i,
	                 buzzer_signal => buzzer_signal_i
	                );
        
        VGA: vga_module 
           PORT MAP (  clk => clk,
                       reset => reset,
                       mode => start_game,
                       stimulus_enable => stimulus_enable_i,
                       player1_win_enable=> player1_win_enable_i,
                       player2_win_enable=> player2_win_enable_i,
                       player_1_score => player_1_score_i,
                       player_2_score => player_2_score_i,
                       secs => secs_i,
                       tenths_secs => tenths_secs_i,
                       hundredths_secs => hundredths_secs_i,
                       thousandths_secs => thousandths_secs_i,
                       red => red_i,
                       green => green_i,
                       blue => blue_i,
                       hsync => hsync_i,
                       vsync => vsync_i
                     );
        

        TITLE_SONG : Title_Screen_FSM
            PORT MAP(
                      clk => clk,
                      reset => reset,
                      start => title_i,
                      buzzer => title_song_i
                    );
                    

        GAME_OVER : Game_Win_FSM
            PORT MAP(
                       clk => clk,
                       reset => win_song_reset, 
                       start =>  win_i,
                       buzzer => win_song_i
                     );   
 
        STIM_PLAY : Stim_Sound
               PORT MAP(
                      clk => clk,
                      reset => stim_song_reset, 
                      start =>  stimulus_enable_i,
                      buzzer => stim_song_i
                        );   
                        
                        
     stim_LED9      <= stim_LEDs_i(0);
     stim_LED10     <= stim_LEDs_i(1);
     stim_LED11     <= stim_LEDs_i(2);
     stim_LED12     <= stim_LEDs_i(3);
     stim_LED13     <= stim_LEDs_i(4);
     stim_LED14     <= stim_LEDs_i(5);
     stim_LED15     <= stim_LEDs_i(6);
               
     player1_LED0   <= '0';
     player1_LED1   <= '0';
     player1_LED2   <= '0';
               
     player2_LED4   <= '0';
     player2_LED5   <= '0';
     player2_LED6   <= '0';
               
     P1Win_LED3      <= '0';
     P2Win_LED7      <= '0';
               
     DP             <= seven_segment_signals_i(7);
     CA             <= seven_segment_signals_i(6);
     CB             <= seven_segment_signals_i(5);
     CC             <= seven_segment_signals_i(4);
     CD             <= seven_segment_signals_i(3);
     CE             <= seven_segment_signals_i(2);
     CF             <= seven_segment_signals_i(1);
     CG             <= seven_segment_signals_i(0);
               
     AN1            <= an_outputs_i(0);
     AN2            <= an_outputs_i(1);
     AN3            <= an_outputs_i(2);
     AN4            <= an_outputs_i(3);	    
     
     --Buzzer_Ring          <= (title_buzz OR win_buzz);  
     
     --Mapping VGA signals to output
     VGA_hsync  <= hsync_i;
     VGA_vsync <= vsync_i;
     VGA_red <= red_i;
     VGA_green <= green_i;
     VGA_blue <= blue_i;
     
     BUZZER_CHOOSE: process(player1_win_enable_i,player2_win_enable_i, stimulus_enable_i, title_song_i)
          begin
          if(rising_edge(clk)) then
              if((player1_win_enable_i OR player2_win_enable_i) = '1') then
              Buzzer_Ring <= win_song_i;  
              elsif(stimulus_enable_i = '1') then
              Buzzer_Ring <= stim_song_i ;
              elsif(title_i = '1') then
              Buzzer_Ring <= title_song_i;
              end if;
          end if;
          end process;
          
     DP_PLACE: process(clk) --takes care of decimal point when there is text vs when there are times being displayed
     begin 
        if(letterDigitMUX_select_i = '1') then   
        dp_in_i        <= an_outputs_i(0);
        else
        dp_in_i        <= an_outputs_i(3);
        end if;
     end process;

end Behavioral;
