library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_lapRegister_FSM is
end tb_lapRegister_FSM;

architecture behaviour of tb_lapRegister_FSM is

  component lapRegister_FSM
    PORT ( 
           clk:						in STD_LOGIC;
           reset:					in STD_LOGIC;
           load:					in STD_LOGIC;
           thousandths_secs:        in STD_LOGIC_VECTOR(3 downto 0);
           hundredths_secs:			in STD_LOGIC_VECTOR(3 downto 0);
           tenths_secs :			in STD_LOGIC_VECTOR(3 downto 0);
           secs:					in STD_LOGIC_VECTOR(3 downto 0);
           lap_thousandths_secs :	out STD_LOGIC_VECTOR(3 downto 0);
           lap_hundredths_secs :	out STD_LOGIC_VECTOR(3 downto 0);
           lap_tenths_secs :		out STD_LOGIC_VECTOR(3 downto 0);
           lap_secs:				out STD_LOGIC_VECTOR(3 downto 0)
        );
   end component;
   
   --Inputs
           clk:						 STD_LOGIC := '0';
           reset:					 STD_LOGIC := '0';
           load:					 STD_LOGIC := '0';
           thousandths_secs:         STD_LOGIC_VECTOR(3 downto 0) := (others=> '0');
           hundredths_secs:			 STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           tenths_secs :			 STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           secs:					 STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); 
   
   --Outputs
            lap_thousandths_secs :	STD_LOGIC_VECTOR(3 downto 0);
            lap_hundredths_secs :	STD_LOGIC_VECTOR(3 downto 0);
            lap_tenths_secs :		STD_LOGIC_VECTOR(3 downto 0);
            lap_secs:				STD_LOGIC_VECTOR(3 downto 0);
            
   -- Clock period definition
            constant clk_period : time := 10 ns;
            
   BEGIN
   
    uut: lapRegister_FSM
      PORT MAP (
                 clk => clk,
                 reset => reset,
                 load => load,
                 thousandths_secs => thousandths_secs,
                 hundredths_secs => hundredths_secs, 
                 tenths_secs => tenths_secs, 
                 secs => secs,
                 lap_thousandths_secs => lap_thousandths_secs,
                 lap_hundredths_secs => lap_hundredths_secs,
                 lap_tenths_secs => lap_tenths_secs,
                 lap_secs => lap_secs
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
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        thousandths_secs <= "1001";
        hundredths_secs <= "1000";
        tenths_secs <= "0010";
        secs <= "1010";
        wait for 250ns;
        
        load <= '1';
        wait;
     end process;
END;
