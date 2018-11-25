library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity psuedoRandomDelayGenerator_FSM is
  PORT (
        clk     : in STD_LOGIC;
        reset   : in STD_LOGIC;
        enable  : in STD_LOGIC;
        delay   : out STD_LOGIC_VECTOR (3 downto 0)  
    );
  
  architecture behavioural of psuedoRandomDelayGenerator_FSM is
    
    signal count    : STD_LOGIC_VECTOR (3 downto 0);

    begin

      process(clk, reset) begin 
        if(reset = '1') then 
          count <= (others => '0');
        elsif(rising_edge(clk)) then
          if(enable = '1') then
            count(3) <= count(0);
            count(2) <= ~(count(3)) XOR count(0);
            count(1) <= count(2);
            count(0) <= count(1);
          end if;
        end if;
      end process;

      delay(3) <= count(3);
      delay(2) <= count(2);
      delay(1) <= count(1);
      delay(0) <= count(0);

  end architecture;
