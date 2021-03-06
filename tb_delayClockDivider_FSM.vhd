LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_delayClockDivider_FSM is
end tb_delayClockDivider_FSM;

architecture behaviour of tb_delayClockDivider_FSM is

  component delayClockDivider_FSM
    PORT (
            clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
            enable  : in STD_LOGIC;
            FSM_enable : out STD_LOGIC;
            set_digit : in STD_LOGIC_VECTOR(3 downto 0);
            value_check : out STD_LOGIC_VECTOR(3 downto 0);
            value_check_down : out STD_LOGIC_VECTOR (3 downto 0)
          );
     end component;
     
     --Inputs
     signal clk   : STD_LOGIC := '0';
     signal reset : STD_LOGIC := '0';
     signal enable : STD_LOGIC := '0';
     signal set_digit :  STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');
     
     --output
     signal FSM_enable : STD_LOGIC;
     signal value_check : STD_LOGIC_VECTOR(3 downto 0);
     signal value_check_down : STD_LOGIC_VECTOR (3 downto 0);
     
     --Clock period definitions
     constant clk_period : time := 10 ns;
     
     BEGIN
     
     uut: delayClockDivider_FSM
     PORT MAP (
                clk => clk,
                reset => reset,
                enable => enable,
                FSM_enable => FSM_enable,
                set_digit => set_digit,
                value_check => value_check,
                value_check_down => value_check_down
        );
        
     --clock process
     clk_process: process
     begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
     end process;
     
     --stimulus process
     stim_proc: process
     begin
      
      set_digit <= "1111";
      wait for clk_period;
      reset <= '1'; 
      wait for clk_period;
      reset <= '0';
      wait for clk_period/2;
      
      enable <= '1';
      wait;
     end process;
     
END;
     
     
     
