library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sevenSegmentDecoder_FSM is
end tb_sevenSegmentDecoder_FSM;

architecture Behavioral of sevenSegmentDecoder_FSM is

component sevenSegmentDecoder_FSM is
    PORT ( 
           seven_segment_signals : out STD_LOGIC_VECTOR(7 downto 0);
           dp_in : in  STD_LOGIC;
           data  : in  STD_LOGIC_VECTOR (3 downto 0)
         );
end component;

--Inputs
signal dp_in : STD_LOGIC := '0';
signal data : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

--Outputs
signal seven_segment_signals : STD_LOGIC_VECTOR(7 downto 0);

BEGIN

uut:sevenSegmentDecoder_FSM
PORT MAP(
			dp_in => dp_in,
			data => data,
			seven_segment_signals => seven_segment_signals
		);
		
stim_proc:process
begin
				  dp_in_i <= '0';
				  wait for 100 ns;
				  data <= "0000"; -- 0
				  wait for 50 ns;
				  data <= "0001"; -- 1
				  wait for 50 ns; 
				  data <= "0010"; -- 2
				  wait for 50 ns;
				  data <= "0011"; -- 3
				  wait for 50 ns;
				  data <= "0100"; -- 4
                  wait for 50 ns;
                  data <= "0101"; -- 5
                  wait for 50 ns;
                  data <= "0110"; -- 6
                  wait for 50 ns;
                  data <= "0111"; -- 7
                  wait for 50 ns;
                  data <= "1000"; -- 8
                  wait for 50 ns;
                  data <= "1001"; -- 9
                  wait for 50 ns;
                  data <= "1010"; -- A
                  wait for 50 ns;
                  data <= "1011"; -- B
                  wait for 50 ns;
                  data <= "1100"; -- C
                  wait for 50 ns;
                  data <= "1101"; -- D
                  wait for 50 ns;
                  data <= "1111"; -- F
                  wait for 50 ns;
                  dp_in_i <= '1';
                  wait for 50 ns;
                  wait;
               end process;
			   
			   end;

