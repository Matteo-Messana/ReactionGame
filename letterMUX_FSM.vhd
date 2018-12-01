
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity letterMUX_FSM is
  PORT ( 
          selector   : in  STD_LOGIC_VECTOR(3 downto 0);
          letter : out STD_LOGIC_VECTOR(3 downto 0)
        );
end letterMUX_FSM;



architecture Behavioral of letterMUX_FSM is

signal P : STD_LOGIC_VECTOR(3 downto 0) := "1011";
signal L : STD_LOGIC_VECTOR(3 downto 0) := "1100";
signal A : STD_LOGIC_VECTOR(3 downto 0) := "1010";
signal Y : STD_LOGIC_VECTOR(3 downto 0) := "1101";

begin
letter_multiplexer_process: process (selector)
begin
    if(selector = "1000") then letter  <= P;
    elsif (selector = "0100") then letter  <= L;
    elsif (selector = "0010") then letter <= A;
    elsif (selector = "0001") then letter <= Y;
    end if;
end process;


end Behavioral;
