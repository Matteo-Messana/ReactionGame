library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lapRegisterMux_FSM is
    PORT ( selector:						in STD_LOGIC;
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
           digit_mux_secs :   				out std_logic_vector(3 downto 0)
      );
end lapRegisterMux_FSM;

architecture Behavioral of lapRegisterMux_FSM is

begin
    process(selector, thousandths_secs, hundredths_secs, tenths_secs, secs, lap_thousandths_secs, lap_hundredths_secs, lap_tenths_secs, lap_secs) 
    begin
        if(selector = '0') then
            digit_mux_thousandths_secs <= thousandths_secs;
            digit_mux_hundredths_secs <= hundredths_secs;
            digit_mux_tenths_secs <= tenths_secs;
            digit_mux_secs <= secs;
        else
            digit_mux_thousandths_secs <= lap_thousandths_secs;
            digit_mux_hundredths_secs <= lap_hundredths_secs;
            digit_mux_tenths_secs <= lap_tenths_secs;
            digit_mux_secs <= lap_secs;
        end if;
    end process;
end Behavioral;