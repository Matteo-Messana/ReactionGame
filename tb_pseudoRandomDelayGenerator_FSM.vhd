library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_psuedoRandomDelayGenerator_FSM IS
END tb_psuedoRandomDelayGenerator_FSM;

architecture behavioural of tb_psuedoRandomDelayGenerator_FSM is

component psuedoRandomDelayGenerator_FSM is
	  PORT (
			clk     : in STD_LOGIC;
			reset   : in STD_LOGIC;
			enable  : in STD_LOGIC;
			delay   : out STD_LOGIC_VECTOR (3 downto 0)  
			);
end component;

--Inputs
signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal enable : STD_LOGIC := '0';

--Outputs
signal delay : STD_LOGIC_VECTOR (3 downto 0);

-- Clock period definitions
constant clk_period : time := 10 ns;

BEGIN

	uut:psuedoRandomDelayGenerator_FSM
	PORT MAP(
			clk => clk,
			reset => reset,	
			enable => enable,
			delay => delay
			);
	
		clk_process :process
	 begin
	  clk <= '0';
	  wait for clk_period/2;
	  clk <= '1';
	  wait for clk_period/2;
	 end process;
	 
	 stim_proc: process
	 begin
	 
		reset <= '1';
		wait for 20ns;
		reset <= '0';
		wait for 20ns;
		enable <= '1';
		
	end process;
	
end;
	   
	  