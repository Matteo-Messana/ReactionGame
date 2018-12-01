library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevenSegmentDecoder_FSM is
    PORT ( 
           seven_segment_signals : out STD_LOGIC_VECTOR(7 downto 0);
           dp_in : in  STD_LOGIC;
           data  : in  STD_LOGIC_VECTOR (3 downto 0)
         );
end sevenSegmentDecoder_FSM;

architecture Behavioral of sevenSegmentDecoder_FSM is

   signal decoded_bits : STD_LOGIC_VECTOR(6 downto 0);

BEGIN
   
   Decoding: process(data) begin
                                      -- ABCDEFG         7-segment LED pattern for reference
      case data is                    -- 6543210 
         when "0000" => decoded_bits <= "1111110"; -- 0  --      A-6
         when "0001" => decoded_bits <= "0110000"; -- 1  --  F-1     B-5
         when "0010" => decoded_bits <= "1101101"; -- 2  --      G-0
         when "0011" => decoded_bits <= "1111001"; -- 3  --  E-2     C-4
         when "0100" => decoded_bits <= "0110011"; -- 4  --      D-3      DP

         when "0101" => decoded_bits <= "1011011"; -- 5  --
         when "0110" => decoded_bits <= "1011111"; -- 6  --
         when "0111" => decoded_bits <= "1110000"; -- 7  --
         when "1000" => decoded_bits <= "1111111"; -- 8  --
         when "1001" => decoded_bits <= "1111011"; -- 9  --

         when "1010" => decoded_bits <= "1110111"; -- A -- don't need hexadecimal display values for stopwatch
         when "1011" => decoded_bits <= "1100111"; -- P -- don't need hexadecimal display values for stopwatch
         when "1100" => decoded_bits <= "0001110"; -- L -- don't need hexadecimal display values for stopwatch
         when "1101" => decoded_bits <= "0111011"; -- Y -- don't need hexadecimal display values for stopwatch
         when "1110" => decoded_bits <= "1001111"; -- E -- don't need hexadecimal display values for stopwatch
         when "1111" => decoded_bits <= "1000111"; -- F -- don't need hexadecimal display values for stopwatch
         when others => decoded_bits <= "0000000"; -- all LEDS off
      end case;
      
   end process;
   
   seven_segment_signals(7) <= dp_in; --DP
   seven_segment_signals(6) <= not decoded_bits(6); --CA
   seven_segment_signals(5) <= not decoded_bits(5); --CB
   seven_segment_signals(4) <= not decoded_bits(4); --CC
   seven_segment_signals(3) <= not decoded_bits(3); --CD
   seven_segment_signals(2) <= not decoded_bits(2); --CE
   seven_segment_signals(1) <= not decoded_bits(1); --CF
   seven_segment_signals(0) <= not decoded_bits(0); --CG
   
END Behavioral;
