library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Countdown_clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           enable   : in  STD_LOGIC;
           FSM_enable : out STD_LOGIC;
           set_digit : in STD_LOGIC_VECTOR (3 downto 0)
     );
end Countdown_clock_divider;

architecture Behavioral of Countdown_clock_divider is

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
            zero:   out STD_LOGIC;
          );
                 
end component;


component settable_downcounter is
GENERIC (
             period  : integer := 4;
             WIDTH   : integer := 4
         );
PORT    (
            clk:    in STD_LOGIC;
            reset:  in STD_LOGIC;
            enable: in STD_LOGIC;
            set_digit: in STD_LOGIC_VECTOR(3 downto 0);
            zero:   out STD_LOGIC;
          );
                 
end component;

begin     
        oneHertzClock: downcounter 
        GENERIC MAP (
                        period => (100000000),
                        WIDTH => 28
                     )
        PORT MAP (
                    clk => clk,
                    reset => reset, --this will receive an FSM reset
                    enable => enable, --this will receive an FSM enable
                    zero => seconds
                 );
                 
        SecondsClock: settable_downcounter 
                 GENERIC MAP (
                                 period => (10),
                                 WIDTH => 4
                              )
                 PORT MAP (
                             clk => clk,
                             reset => reset, --this will receive an FSM reset
                             enable => seconds,
                             set_digit => set_digit,
                             zero => FSM_enable --this outputs an enable signal to the FSM
                          );          
                                              
end Behavioral;
