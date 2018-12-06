----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2018 05:43:06 PM
-- Design Name: 
-- Module Name: Game_Win_FSM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Game_Win_FSM is
  Port (
        clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      start : in STD_LOGIC;
      buzzer : out STD_LOGIC
         );
end Game_Win_FSM;

architecture Behavioral of Game_Win_FSM is

component downcounter is
  Generic ( period: integer:= 4;       
            WIDTH  : integer:= 4
		  );
    PORT ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           zero   : out STD_LOGIC
          -- value_check_d : out STD_LOGIC_VECTOR (3 downto 0)
         );
end component;

component upcounter_FSM is
   Generic (  period : integer:= 4;
              WIDTH  : integer:= 3
           );--generics are just information, no specified behaviour in an entity
      PORT ( clk    : in  STD_LOGIC;
             reset  : in  STD_LOGIC;
             enable : in  STD_LOGIC;
             zero   : out STD_LOGIC;
             value  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
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

--SIGNALS--
signal buzzG2 : STD_LOGIC;
signal buzzC3 : STD_LOGIC;
signal buzzE3 : STD_LOGIC;
signal buzzG3 : STD_LOGIC;
signal buzzC4 : STD_LOGIC;
signal buzzE4 : STD_LOGIC;
signal buzzG4 : STD_LOGIC;
signal buzzGA2 : STD_LOGIC;
signal buzzDE3 : STD_LOGIC;
signal buzzGA3 : STD_LOGIC;
signal buzzDE4 : STD_LOGIC;
signal buzzGA4 : STD_LOGIC;
signal buzzBflat2 : STD_LOGIC;
signal buzzD3 : STD_LOGIC;
signal buzzF3 : STD_LOGIC;
signal buzzBflat3 : STD_LOGIC;
signal buzzD4 : STD_LOGIC;
signal buzzF4 : STD_LOGIC;
signal buzzBflat4 : STD_LOGIC;
signal buzzC5 : STD_LOGIC;

signal soundG2 : STD_LOGIC;
signal soundC3 : STD_LOGIC;
signal soundE3 : STD_LOGIC;
signal soundG3 : STD_LOGIC;
signal soundC4 : STD_LOGIC;
signal soundE4 : STD_LOGIC;
signal soundG4 : STD_LOGIC;
signal soundGA2 : STD_LOGIC;
signal soundDE3 : STD_LOGIC;
signal soundGA3 : STD_LOGIC;
signal soundDE4 : STD_LOGIC;
signal soundGA4 : STD_LOGIC;
signal soundBflat2 : STD_LOGIC;
signal soundD3 : STD_LOGIC;
signal soundF3 : STD_LOGIC;
signal soundBflat3 : STD_LOGIC;
signal soundD4 : STD_LOGIC;
signal soundF4 : STD_LOGIC;
signal soundBflat4 : STD_LOGIC;
signal soundC5 : STD_LOGIC;

signal second : STD_LOGIC;
signal second2 : STD_LOGIC;
signal change : STD_LOGIC;
signal start_signal : STD_LOGIC;
signal start_i : STD_LOGIC;
signal cycle : STD_LOGIC_VECTOR(5 downto 0);
signal reset_i : STD_LOGIC;
signal reset_song : STD_LOGIC;

begin
--start_signal <= '1';
reset_song <= reset OR reset_i;
start_i <= start AND start_signal;

MARIO_SECOND_GENERATOR : downcounter
GENERIC MAP(
                period => (15000000),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>second
          );

NOTE_CYCLE: upcounter_FSM
GENERIC MAP(
               period => (63),
               WIDTH => 6
            )
PORT MAP(
            clk => clk,
            reset => reset_song,
            enable => second,
            zero => open,
            value => cycle
         );  

G5_NOTE : downcounter
GENERIC MAP(
                period => (127553),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzG2
          );

C6_NOTE : downcounter
GENERIC MAP(
                period => (95557),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzC3
          );

E6_NOTE : downcounter
GENERIC MAP(
                period => (75843),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzE3
          );

G6_NOTE : downcounter
GENERIC MAP(
                period => (63776),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzG3
          );

C7_NOTE : downcounter
GENERIC MAP(
                period => (47778),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzC4
          );

E7_NOTE : downcounter
GENERIC MAP(
                period => (37922),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzE4
          );

G7_NOTE : downcounter
GENERIC MAP(
                period => (31888),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzG4
          );

GA5_NOTE : downcounter
GENERIC MAP(
                period => (120393),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzGA2
          );

DE6_NOTE : downcounter
GENERIC MAP(
                period => (80353),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzDE3
          );

GA6_NOTE : downcounter
GENERIC MAP(
                period => (60197),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzGA3
          );

DE7_NOTE : downcounter
GENERIC MAP(
                period => (40176),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzDE4
          );

GA7_NOTE : downcounter
GENERIC MAP(
                period => (30098),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzGA4
          );

Bflat5_NOTE : downcounter
GENERIC MAP(
                period => (107258),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzBflat2
          );

D6_NOTE : downcounter
GENERIC MAP(
                period => (85131),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzD3
          );

F6_NOTE : downcounter
GENERIC MAP(
                period => (71587),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzF3
          );

Bflat6_NOTE : downcounter
GENERIC MAP(
                period => (53629),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzBflat3
          );

D7_NOTE : downcounter
GENERIC MAP(
                period => (42566),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzD4
          );

F7_NOTE : downcounter
GENERIC MAP(
                period => (35793),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzF4
          );

Bflat7_NOTE : downcounter
GENERIC MAP(
                period => (26815),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzBflat4
          );

C8_NOTE : downcounter
GENERIC MAP(
                period => (23889),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start_i,
                zero =>buzzC5
          );

G2_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzG2,
            buzzer_signal => soundG2
          );

C3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzC3,
            buzzer_signal => soundC3
          );

E3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzE3,
            buzzer_signal => soundE3
          );

G3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzG3,
            buzzer_signal => soundG3
          );

C4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzC4,
            buzzer_signal => soundC4
          );

E4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzE4,
            buzzer_signal => soundE4
          );

G4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzG4,
            buzzer_signal => soundG4
          );

GA2_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzGA2,
            buzzer_signal => soundGA2
          );

DE3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzDE3,
            buzzer_signal => soundDE3
          );

GA3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzGA3,
            buzzer_signal => soundGA3
          );

DE4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzDE4,
            buzzer_signal => soundDE4
          );

GA4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzGA4,
            buzzer_signal => soundGA4
          );

Bflat2_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzBflat2,
            buzzer_signal => soundBflat2
          );

D3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzD3,
            buzzer_signal => soundD3
          );

F3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzF3,
            buzzer_signal => soundF3
          );

Bflat3_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzBflat3,
            buzzer_signal => soundBflat3
          );

D4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzD4,
            buzzer_signal => soundD4
          );

F4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzF4,
            buzzer_signal => soundF4
          );

Bflat4_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzBflat4,
            buzzer_signal => soundBflat4
          );

C5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzC5,
            buzzer_signal => soundC5
          );


PLAY_SONG : process(reset,cycle)
begin
if(reset = '1') then
start_signal <= '1';
elsif(cycle = "000000") then
buzzer <= soundG2 ;
reset_i <= '0';
elsif(cycle = "000001") then
buzzer <= soundC3 ;
elsif(cycle = "000010") then
buzzer <= soundE3 ;
elsif(cycle = "000011") then
buzzer <= soundG3 ;
elsif(cycle = "000100") then
buzzer <= soundC4 ;
elsif(cycle = "000101") then
buzzer <= soundE4 ;
elsif(cycle = "000110") then
buzzer <= soundG4 ;
elsif(cycle = "000111") then
buzzer <= soundG4 ;
elsif(cycle = "001000") then
buzzer <= soundG4 ;
elsif(cycle = "001001") then
buzzer <= soundE4 ;
elsif(cycle = "001010") then
buzzer <= soundE4 ;
elsif(cycle = "001011") then
buzzer <= soundE4 ;

elsif(cycle = "001100") then
buzzer <= soundGA2 ;
elsif(cycle = "001101") then
buzzer <= soundC3 ;
elsif(cycle = "001110") then
buzzer <= soundDE3 ;
elsif(cycle = "001111") then
buzzer <= soundGA3 ;
elsif(cycle = "010000") then
buzzer <= soundC4 ;
elsif(cycle = "010001") then
buzzer <= soundDE4 ;
elsif(cycle = "010010") then
buzzer <= soundGA4 ;
elsif(cycle = "010011") then
buzzer <= soundGA4 ;
elsif(cycle = "010100") then
buzzer <= soundGA4 ;
elsif(cycle = "010101") then
buzzer <= soundDE4 ;
elsif(cycle = "010110") then
buzzer <= soundDE4 ;
elsif(cycle = "010111") then
buzzer <= soundDE4 ;

elsif(cycle = "011000") then
buzzer <= soundBflat2 ;
elsif(cycle = "011001") then
buzzer <= soundD3 ;
elsif(cycle = "011010") then
buzzer <= soundF3 ;
elsif(cycle = "011011") then
buzzer <= soundBflat3 ;
elsif(cycle = "011100") then
buzzer <= soundD4 ;
elsif(cycle = "011101") then
buzzer <= soundF4 ;
elsif(cycle = "011110") then
buzzer <= soundBflat4 ;
elsif(cycle = "011111") then
buzzer <= soundBflat4 ;
elsif(cycle = "100000") then
buzzer <= soundBflat4 ;
elsif((cycle = "100001")) then
buzzer <= soundBflat4 ;
elsif((cycle = "100011")) then
buzzer <= soundBflat4 ;

elsif(cycle = "100100") then
buzzer <= soundC5 ;
elsif(cycle = "100101") then
buzzer <= soundC5  ;
elsif(cycle = "100110") then
buzzer <= soundC5  ;
elsif(cycle = "100111") then
buzzer <= soundC5  ;
elsif(cycle = "101000") then
buzzer <= soundC5  ;
elsif(cycle = "101001") then
buzzer <= soundC5  ;
elsif(cycle = "101010") then
start_signal <='0';
end if;
end process;

end Behavioral;
