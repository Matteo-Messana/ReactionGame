library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buzzerModule_FSM is
Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable_flipflop : in STD_LOGIC;
        buzzer_signal : out STD_LOGIC
      );
end buzzerModule_FSM;

architecture Behavioral of buzzerModule_FSM is

signal D : STD_LOGIC;
signal Q : STD_LOGIC;

begin
          
 BUZZER_ACTIVE : process(clk)
 begin
 if(reset ='1') then
     Q <= '0';
     D <= '1';
 elsif(rising_edge(clk)) then
     if(enable_flipflop = '1') then
         Q <= D;
         D <= not Q;
     else
         Q <= Q;
         D <= D;
     end if;
    end if;
 end process;
 
buzzer_signal <= Q;

end Behavioral;
