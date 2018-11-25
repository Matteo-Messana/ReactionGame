library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity load_FSM is
 PORT( input:        in STD_LOGIC;
       clk:          in STD_LOGIC;
       output:       out STD_LOGIC
      );
end load_FSM;

architecture Behavioral of load_FSM is
    signal Q_i: STD_LOGIC;
begin
    process(clk) begin
        if(rising_edge(clk)) then Q_i <= input;
        end if;
    end process;
    
    output <= input AND (NOT Q_i);

end Behavioral;