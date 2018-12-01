----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2018 12:56:14 PM
-- Design Name: 
-- Module Name: letterDigitMUX_FSM - Behavioral
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

entity letterDigitMUX_FSM is
    PORT(
         LetterValue : in STD_LOGIC_VECTOR (3 downto 0);
         DigitValue : in STD_LOGIC_VECTOR (3 downto 0);
         selector : in STD_LOGIC;
         DisplayValue : out STD_LOGIC_VECTOR (3 downto 0)
         );
end letterDigitMUX_FSM;

architecture Behavioral of letterDigitMUX_FSM is

begin

letter_digit_select : process(selector)
begin
if(selector = '1') then DisplayValue <= LetterValue;
else 
DisplayValue <= DigitValue;
end if;

end process;

end Behavioral;
