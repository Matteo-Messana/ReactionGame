library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digitMux_FSM is
  PORT ( 
          thousandths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          hundredths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          tenths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          secs   : in  STD_LOGIC_VECTOR(3 downto 0);
          selector   : in  STD_LOGIC_VECTOR(3 downto 0);
          time_digit : out STD_LOGIC_VECTOR(3 downto 0)
        );
end digitMux_FSM;

architecture Behavioral of digitMux_FSM is

BEGIN

digit_multiplexer_process: process (selector, thousandths_secs, hundredths_secs, tenths_secs, secs)
begin
    if(selector = "0001") then time_digit  <= thousandths_secs;
    elsif (selector = "0010") then time_digit  <= hundredths_secs;
    elsif (selector = "0100") then time_digit <= tenths_secs;
    elsif (selector = "1000") then time_digit <= secs;
    end if;
end process;


END Behavioral;
