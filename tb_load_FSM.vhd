library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_load_FSM is
end tb_load_FSM;

architecture behaviour of tb_load_FSM
  component load_FSM 
    PORT (
           input:        in STD_LOGIC;
           clk:          in STD_LOGIC;
           output:       out STD_LOGIC
         );
  end component;
  
  --Inputs
  signal input : STD_LOGIC := '0';
  signal clk :  STD_LOGIC := '0';
  
  --Outputs
  signal output : STD_LOGIC;
  
  --Clock period definition
  constant clk_period : time := 10ns;
  
  BEGIN
    
    uut: load_FSM
      PORT MAP(
                clk => clk,
                input => input,
                output => output
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
    
      input <= '1';
      wait for 200ns;
      input <= '0';
      wait for 200ns;
      input <= '1';
      wait for 200ns;
      input <= '0';
      wait for 200ns;
      
   end process;

END;
 
