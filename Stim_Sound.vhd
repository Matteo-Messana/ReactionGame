----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2018 12:55:54 PM
-- Design Name: 
-- Module Name: Stim_Sound - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stim_Sound is
 Port (
     clk : in STD_LOGIC;
     reset : in STD_LOGIC;
     start : in STD_LOGIC;
     buzzer : out STD_LOGIC
 );
end Stim_Sound;

architecture Behavioral of Stim_Sound is

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


signal buzzBflat5 : STD_LOGIC;
signal buzzDflat6 : STD_LOGIC;
signal buzzEflat6 : STD_LOGIC;
signal buzzG6 : STD_LOGIC;
signal buzzBflat6 : STD_LOGIC;

signal soundBflat5 : STD_LOGIC;
signal soundDflat6 : STD_LOGIC;
signal soundEflat6 : STD_LOGIC;
signal soundG6 : STD_LOGIC;
signal soundBflat6 : STD_LOGIC;

signal second : STD_LOGIC;
signal second2 : STD_LOGIC;
signal change : STD_LOGIC;
signal cycle : STD_LOGIC_VECTOR(15 downto 0);
signal reset_i : STD_LOGIC;
signal reset_song : STD_LOGIC;


begin

reset_song <= reset OR reset_i;

ALERT_SECOND_GENERATOR : downcounter
GENERIC MAP(
                period => (2000000),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>second
          );

NOTE_CYCLE: upcounter_FSM
GENERIC MAP(
               period => (32768),
               WIDTH => 16
            )
PORT MAP(
            clk => clk,
            reset => reset_song,
            enable => second,
            zero => open,
            value => cycle
         );  
 
 

Bflat5_NOTE : downcounter
GENERIC MAP(
                period => (53629),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>buzzBflat5
          ); 

Dflat6_NOTE : downcounter
GENERIC MAP(
                period => (45097),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>buzzDflat6
          ); 

Eflat6_NOTE : downcounter
GENERIC MAP(
                period => (40176),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>buzzEflat6
          ); 

G6_NOTE : downcounter
GENERIC MAP(
                period => (31888),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>buzzG6
          );  

Bflat6_NOTE : downcounter
GENERIC MAP(
                period => (26815),
                WIDTH => 28
            )
 PORT MAP(
                clk => clk,
                reset => reset_song,
                enable => start,
                zero =>buzzBflat6
          );  

 Bflat5_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset_song,
            enable_flipflop => buzzBflat5,
            buzzer_signal => soundBflat5
          );

 Dflat6_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset_song,
            enable_flipflop => buzzDflat6,
            buzzer_signal => soundDflat6
          );

 Eflat6_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset_song,
            enable_flipflop => buzzEflat6,
            buzzer_signal => soundEflat6
          );

 G6_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset_song,
            enable_flipflop => buzzG6,
            buzzer_signal => soundG6
          );

 Gflat6_START : buzzerModule_FSM
 PORT MAP(
            clk => clk,
            reset => reset_song,
            enable_flipflop => buzzBflat6,
            buzzer_signal => soundBflat6
          );

PLAY_SONG : process(cycle)
begin
if(cycle = "0000000000000000") then
reset_i <= '0';
buzzer <= soundBflat5;
elsif(cycle = "0000000000000001") then
buzzer <= soundBflat5;
elsif(cycle = "0000000000000010") then
buzzer <= soundDflat6; 
elsif(cycle = "0000000000000011") then
buzzer <= soundDflat6; 
elsif(cycle = "0000000000000100") then
buzzer <= soundEflat6; 
elsif(cycle = "0000000000000101") then
buzzer <= soundG6;
elsif(cycle = "0000000000000110") then
buzzer <= soundBflat6;
end if;
end process;

end Behavioral;
