LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tb_digitMux_FSM is
end tb_digitMux_FSM;

architecture behaviour of tb_digitMux_FSM is

  component digitMux_FSM
    PORT (
            thousandths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
            hundredths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
            tenths_secs   : in  STD_LOGIC_VECTOR(3 downto 0);
            secs   : in  STD_LOGIC_VECTOR(3 downto 0);
            selector   : in  STD_LOGIC_VECTOR(3 downto 0);
            time_digit : out STD_LOGIC_VECTOR(3 downto 0)
          );
   end component;
   
   --Inputs
   signal thousandths_secs  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal hundredths_secs  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal tenths_secs  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal secs  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   signal selector  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
   
   --Outputs
   signal time_digit  : STD_LOGIC_VECTOR(3 downto 0);
   
   BEGIN
    uut: digitMux_FSM
      PORT MAP (
                  thousandths_secs   => thousandths_secs,
                  hundredths_secs   => hundredths_secs,
                  tenths_secs   => tenths_secs,
                  secs   => secs,
                  selector   => selector,
                  time_digit => time_digit
               );
               
    stim_proc: process
    begin
      
      thousandths_secs <= "1101";
      wait for 50ns;
      hundreths_secs <= "1001";
      wait for 50ns;
      tenths_secs <= "0010";
      wait for 50ns;
      secs <= "0001";
      wait for 50ns;
     
      selector <= "0001";
      wait for 100ns;
      selector <= "0010";
      wait for 100ns;
      selector <= "0100";
      wait for 100ns;
      selector <= "1000";
      wait for 100ns;

    end process
    
END;
