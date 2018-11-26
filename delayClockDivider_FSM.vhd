library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity delayClockDivider_FSM is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           enable   : in  STD_LOGIC;
           FSM_enable : out STD_LOGIC;
           set_digit : in STD_LOGIC_VECTOR (3 downto 0)
     );
end delayClockDivider_FSM;

architecture Behavioral of delayClockDivider_FSM is

signal hundredhertz : STD_LOGIC;
signal seconds: STD_LOGIC;

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


component settableDowncounter is
GENERIC (
             period  : integer := 4;
             WIDTH   : integer := 4
         );
PORT    (
            clk:    in STD_LOGIC;
            reset:  in STD_LOGIC;
            enable: in STD_LOGIC;
            set_digit: in STD_LOGIC_VECTOR(3 downto 0);
            zero:   out STD_LOGIC
          );
                 
end component;

begin     
        oneHertzClock: downcounter 
        GENERIC MAP ( 
                        period => (100000000), --one second downcounter (as used in lab 2 & 3)
                        WIDTH => 28
                     )
        PORT MAP (
                    clk => clk,
                    reset => reset, --this will receive an FSM reset
                    enable => enable, --this will receive an FSM enable
                    zero => seconds --sends to settable downcounter
                 );
                 
        SecondsClock: settableDowncounter 
                 GENERIC MAP (
                                 period => (16), --can count down 16 seconds (F to 0)
                                 WIDTH => 4
                              )
                 PORT MAP (
                             clk => clk,
                             reset => reset, --this will receive an FSM reset
                             enable => seconds, --received from the usable downcounter
                             set_digit => set_digit, --received from the pseudo-random delay generator
                             zero => FSM_enable --this outputs an enable signal to the FSM
                          );          
                                              
end Behavioral;
