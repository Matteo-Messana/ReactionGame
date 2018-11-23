library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lapRegister_FSM is
    PORT ( clk:						in STD_LOGIC;
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
end lapRegister_FSM;

architecture Behavioral of lapRegister_FSM is
begin
    process(clk, reset, thousandths_secs, hundredths_secs, tenths_secs, secs) 
    begin
        if(reset = '1') then 
            lap_thousandths_secs <= "0000";
            lap_hundredths_secs <= "0000";
            lap_tenths_secs <= "0000";
            lap_secs <= "0000";
        else
            if(rising_edge(clk)) then
                if(load = '1') then
                    lap_thousandths_secs <= thousandths_secs;
                    lap_hundredths_secs <= hundredths_secs;
                    lap_tenths_secs <= tenths_secs;
                    lap_secs <= secs;
                 end if;
            end if;
        end if;
     end process;
end Behavioral;