LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity tb_playClockDivider_FSM is
end tb_playClockDivider_FSM;

architecture behaviour of tb_playClockDivider is

component playClockDivider_FSM is	
	PORT ( clk      				: in  STD_LOGIC;
           reset    				: in  STD_LOGIC;
           enable   				: in STD_LOGIC;
           secs 					: out STD_LOGIC_VECTOR(3 downto 0);
           tenths_secs 				: out STD_LOGIC_VECTOR(3 downto 0);
           hundredths_secs 			: out STD_LOGIC_VECTOR(3 downto 0);
           thousandths_secs 		: out STD_LOGIC_VECTOR(3 downto 0)     
     );
end component;

--Inputs
signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal enable : STD_LOGIC := '0';

--Outputs
signal secs : STD_LOGIC_VECTOR(3 downto 0);
signal tenths_secs : STD_LOGIC_VECTOR(3 downto 0);
signal hundredths_secs : STD_LOGIC_VECTOR(3 downto 0);
signal thousandths_secs : STD_LOGIC_VECTOR(3 downto 0);

--CLK period
constant clk_period : time := 10 ns;

BEGIN

uut: playClockDivider_FSM
PORT MAP(
			clk => clk,
			reset => reset,
			enable => enable,
			secs => secs,
			tenths_secs => tenths_secs,
			hundredths_secs => hundredths_secs,
			thousandths_secs => thousandths_secs
			);
			
	-- Clock process definitions
   clk_process :process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
   
   -- Stimulus process
   stim_proc : process
   BEGIN
   
   wait for 10ns;
   reset <= '1';
   wait for 20ns;
   reset <= '0';
   wait for 20ns;
   enable <= '1';
   wait;
   end process;
   
   end;
   
   
   