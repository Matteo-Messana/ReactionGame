LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_lapRegisterMux_FSM is
end tb_lapRegisterMux_FSM;

architecture behaviour of tb_lapRegister is
  
  component lapRegisterMux_FSM
  PORT( 
           selector:						in STD_LOGIC;
           thousandths_secs:				in STD_LOGIC_VECTOR(3 downto 0);
           hundredths_secs:					in STD_LOGIC_VECTOR(3 downto 0);
           tenths_secs:						in STD_LOGIC_VECTOR(3 downto 0);
           secs:              				in STD_LOGIC_VECTOR(3 downto 0);
           lap_thousandths_secs:    		in STD_LOGIC_VECTOR(3 downto 0);
           lap_hundredths_secs:     		in STD_LOGIC_VECTOR(3 downto 0);
           lap_tenths_secs:         		in STD_LOGIC_VECTOR(3 downto 0);
           lap_secs:          				in STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_thousandths_secs :     out STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_hundredths_secs :   	out STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_tenths_secs :   		out STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_secs :   				out STD_LOGIC_VECTOR(3 downto 0)
       );
   end component;
   
   --Inputs
           selector:						STD_LOGIC := '0';
           thousandths_secs:				STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           hundredths_secs:					STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           tenths_secs:						STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           secs:              				STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           lap_thousandths_secs:    		STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           lap_hundredths_secs:     		STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           lap_tenths_secs:         		STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           lap_secs:          				STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    
   --Outputs
           digit_mux_thousandths_secs :    STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_hundredths_secs :   	STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_tenths_secs :   		STD_LOGIC_VECTOR(3 downto 0);
           digit_mux_secs :   				STD_LOGIC_VECTOR(3 downto 0);
   
   BEGIN
    uut: lapRegisterMux_FSM
    PORT MAP (
               selector => selector,
               thousandths_secs => thousandths_secs,
               hundredths_secs => hundredths_secs,
               tenths_secs => tenths_secs,
               secs => secs,
               lap_thousandths_secs => lap_thousandths_secs,
               lap_hundredths_secs => lap_hundredths_secs,
               lap_tenths_secs => lap_tenths_secs,
               lap_secs => lap_secs,
               digit_mux_thousandths_secs => digit_mux_thousandths_secs,
               digit_mux_hundredths_secs => digit_mux_hundredths_secs,
               digit_mux_tenths_secs => digit_mux_tenths_secs,
               digit_mux_secs =>  digit_mux_secs
              );
              
     stim_proc: process
     begin
      thousandths_secs <= "1111";
      hundredths_secs <= "1111";
      tenths_secs <= "1111";
      secs <= "1111";
      wait for 50ns;
      
      lap_thousandths_secs <= "1001";
      lap_hundredths_secs <= "1001";
      lap_tenths_secs <= "1001";
      lap_secs <= "1001";
      waut for 50ns;
      
      selector <= '1';
      wait for 250ns;
      selector <= '0';
      wait;
   
     end process;
 
 END;
   
       
