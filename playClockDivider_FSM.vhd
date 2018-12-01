library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity playClockDivider_FSM is	
	PORT ( clk      				: in  STD_LOGIC;
           reset    				: in  STD_LOGIC;
           enable   				: in STD_LOGIC;
           secs 					: out STD_LOGIC_VECTOR(3 downto 0);
           tenths_secs 				: out STD_LOGIC_VECTOR(3 downto 0);
           hundredths_secs 			: out STD_LOGIC_VECTOR(3 downto 0);
           thousandths_secs 		: out STD_LOGIC_VECTOR(3 downto 0)     
     );
end playClockDivider_FSM;

architecture Behavioural of playClockDivider_FSM is
-- Signals:
signal usableTime, thousandths_zero, hundredths_zero, tenths_zero: STD_LOGIC;
signal thousandths_value, hundredths_value, tenths_value, secs_value : STD_LOGIC_VECTOR(3 downto 0);

-- Components declarations
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

BEGIN

usableTimeClock: upcounter_FSM
   generic map(
               period => (100000),   -- divide by 100_000 to divide 100 MHz down to 1 kHz 
               WIDTH  => 17             -- 17 bits are required to hold the binary value of 11000011010100000
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => enable,
               zero   => usableTime, -- this is a 1 Hz clock signal
               value  => open  -- Leave open since we won't display this value
            );
			
thousandthsClock: upcounter_FSM
   generic map(
               period => (10),   
               WIDTH  => 4             
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => usableTime,
               zero   => thousandths_zero, 
               value  => thousandths_value  
            );
			
hundredthsClock: upcounter_FSM
	generic map(
               period => (10),   
               WIDTH  => 4             
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => thousandths_zero,
               zero   => hundredths_zero, 
               value  => hundredths_value 
            );
			
tenthsClock: upcounter_FSM
	generic map(
               period => (10),   
               WIDTH  => 4             
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => hundredths_zero,
               zero   => tenths_zero, 
               value  => tenths_value
            );
	
secsClock: upcounter_FSM
	generic map(
               period => (10),   
               WIDTH  => 4             
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => tenths_zero,
               zero   => open, 
               value  => secs_value
            );
			
--Output
thousandths_secs 	<= thousandths_value;
hundredths_secs 	<= hundredths_value;
tenths_secs 		<= tenths_value;
secs 			<= secs_value;
			
END;