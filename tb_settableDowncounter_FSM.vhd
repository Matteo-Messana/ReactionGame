library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_settableDowncounter_FSM is
end tb_settableDowncounter_FSM;

architecture behavioural of tb_settableDowncounter_FSM is

component settableDowncounter_FSM is
  Generic ( period : integer:= 4;       
            WIDTH  : integer:= 4
		  );
    PORT ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           set_digit: in STD_LOGIC_VECTOR(3 downto 0);
           zero   : out STD_LOGIC;
           value  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
         );
end component;

--Inputs
 constant period : integer := 4;
 constant WIDTH : integer := 4;
 signal clk : STD_LOGIC := '0';
 signal reset: STD_LOGIC := '0';
 signal enable: STD_LOGIC := '0';
 signal set_digit: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
 
 --Outputs
 signal zero : STD_LOGIC;
 signal value  : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
 
 --CLK Period
 constant clk_period : time := 20ns;
 
 BEGIN
 
 uut: settableDowncounter_FSM
 GENERIC MAP(
            period => (16),
            WIDTH => 4
            )
 PORT MAP(
		clk => clk,
        reset => reset,
        enable => enable,
        set_digit => set_digit,
        value => value,
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
        
            set_digit <= "1111";
            wait for clk_period*2;
            reset <= '1';
            wait for clk_period;
            reset <= '0';
            wait for clk_period;
            enable <= '1';
            wait;
        end process;		
			
end;
			
			
 
 