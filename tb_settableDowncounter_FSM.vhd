library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_settableDowncounter_FSM is
end tb_settableDowncounter_FSM;

component tb_settableDowncounter_FSM is
  Generic ( period : integer:= 4;       
            WIDTH  : integer:= 3
		  );
    PORT ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           set_digit: in STD_LOGIC_VECTOR(3 downto 0);
           zero   : out STD_LOGIC
         );
end tb_settableDowncounter_FSM;

architecture Behavioral of settableDowncounter_FSM is

--Inputs
 constant period : integer := 4;
 constant WIDTH : integer := 4;
 signal clk : STD_LOGIC := '0';
 signal reset: STD_LOGIC := '0';
 signal enable: STD_LOGIC := '0';
 signal set_digit: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
 
 --Outputs
 signal zero : STD_LOGIC;
 
 --CLK Period
 constant clk_period : time := 20ns;
 
 BEGIN
 
 uut: settableDowncounter_FSM
 PORT MAP(
		clk => clk,
        reset => reset,
        enable => enable,
        set_digit => set_digit,
        zero => zero
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
        
            reset <= '1';
            wait for clk_period*2;
            reset <= '0';
            wait for clk_period*2;
            set_digit <= "1001";
            enable <= '1';
            wait;
        end process;		
			
			
			
 
 