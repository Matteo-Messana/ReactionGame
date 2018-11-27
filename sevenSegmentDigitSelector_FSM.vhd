library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_sevenSegmentDigitSelector_FSM is
end tb_sevenSegmentDigitSelector_FSM;

architecture Behavioral of tb_sevenSegmentDigitSelector_FSM is

entity sevenSegmentDigitSelector_FSM is
    PORT ( clk          : in  STD_LOGIC;
           digit_select : out STD_LOGIC_VECTOR (3 downto 0);
           an_outputs   : out STD_LOGIC_VECTOR (3 downto 0);
           reset        : in  STD_LOGIC
		 );
end sevenSegmentDigitSelector_FSM;

--Inputs
signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';

--Outputs
signal digit_select : STD_LOGIC_VECTOR( 3 downto 0);
signal an_outputs : STD_LOGIC_VECTOR( 3 downto 0);

--CLK Period
constant clk_period           : time := 20ns;

BEGIN

uut:sevenSegmentDigitSelector_FSM
PORT MAP(
			clk => clk,
			digit_select => digit_select,
			an_outputs => an_outputs
			reset => reset
			);
			
		clk_proc: process
        begin
               clk <= '0';
               wait for clk_period/2;
               clk <= '1';
               wait for clk_period/2;
        
        end process;
		
		stim_proc: process
			begin	
				-- hold reset state for 100 ns.
			reset_i <= '0';
			wait for 100 ns;   
			reset_i <= '1';
			wait for clk_period*10;
			reset_i <= '0';
			-- insert stimulus here 

			wait for clk_period*10;
			wait;
		end process;

END;