----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2018 04:07:45 PM
-- Design Name: 
-- Module Name: Title_Screen_FSM - Behavioral
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

entity Title_Screen_FSM is
  Port (
     clk : in STD_LOGIC;
     reset : in STD_LOGIC;
     start : in STD_LOGIC;
     buzzer : out STD_LOGIC
   );
end Title_Screen_FSM;

architecture Behavioral of Title_Screen_FSM is

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
signal buzzA5 : STD_LOGIC;
signal buzzE5 : STD_LOGIC;
signal buzzG5 : STD_LOGIC;
signal buzzF_SHARP_5 : STD_LOGIC;

signal soundA5: STD_LOGIC;
signal soundE5 : STD_LOGIC;
signal soundG5 : STD_LOGIC;
signal soundF_SHARP_5 : STD_LOGIC;

signal second : STD_LOGIC;
signal second2 : STD_LOGIC;
signal change : STD_LOGIC;
signal cycle : STD_LOGIC_VECTOR(4 downto 0);
signal reset_i : STD_LOGIC;
signal reset_song : STD_LOGIC;

begin

reset_song <= reset OR reset_i;

HALF_SECOND_GENERATOR : downcounter
GENERIC MAP(
                period => (50000000),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start,
                zero =>second
          );

NOTE_CYCLE: upcounter_FSM
GENERIC MAP(
               period => (63),
               WIDTH => 5
            )
PORT MAP(
            clk => clk,
            reset => reset_song,
            enable => second,
            zero => open,
            value => cycle
         );  

A5_NOTE : downcounter
GENERIC MAP(
                period => (113636),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset,
                enable => start,
                zero =>buzzA5
          );
          
 E5_NOTE : downcounter
    GENERIC MAP(
                period => (151688),
                WIDTH => 28
               )
 PORT MAP(
            clk => clk,
            reset => reset,
            enable => start,
            zero =>buzzE5
          );
          
 G5_NOTE : downcounter
    GENERIC MAP(
                period => (127553),
                WIDTH => 28
               )
 PORT MAP(
            clk => clk,
            reset => reset,
            enable => start,
            zero =>buzzG5
          );

F_SHARP_5_NOTE : downcounter
    GENERIC MAP(
                period => (135137),
                WIDTH => 28
               )
 PORT MAP(
            clk => clk,
            reset => reset,
            enable => start,
            zero =>buzzF_SHARP_5
          );

 A5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzA5,
            buzzer_signal => soundA5
          );

E5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzE5,
            buzzer_signal => soundE5
          );
          

G5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzG5,
            buzzer_signal => soundG5
          );

F_SHARP_5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset,
            enable_flipflop => buzzF_SHARP_5,
            buzzer_signal => soundF_SHARP_5
          );

PLAY_SONG : process(cycle)
begin
if(cycle = "00000") then
buzzer <= soundA5;
reset_i <= '0';
elsif(cycle = "00001") then
buzzer <= soundA5;
elsif(cycle = "00010") then
buzzer <= soundE5;
elsif(cycle = "00011") then
buzzer <= soundE5;
elsif(cycle = "00100") then
buzzer <= soundG5;
elsif(cycle = "00101") then
buzzer <= soundF_SHARP_5;
elsif(cycle = "00110") then
buzzer <= soundE5;
elsif(cycle = "00111") then
buzzer <= soundE5;
elsif(cycle = "01000") then
buzzer <= soundG5;
elsif(cycle = "01001") then
buzzer <= soundF_SHARP_5;
elsif(cycle = "01010") then
buzzer <= soundG5;
elsif(cycle = "01011") then
buzzer <= soundF_SHARP_5;
elsif(cycle = "01100") then
buzzer <= soundG5;
elsif(cycle = "01101") then
buzzer <= soundF_SHARP_5;
elsif(cycle = "01110") then
buzzer <= soundE5;
elsif(cycle = "01111") then
buzzer <= soundE5;
elsif(cycle = "10000") then
reset_i <= '1';
end if;
end process;

end Behavioral;
