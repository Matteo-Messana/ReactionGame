library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity buzzerCounter_FSM is
GENERIC(
        count_size : integer := 4
       );
PORT(
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      enable : in STD_LOGIC;
      zero_enable : out STD_LOGIC
     );
end buzzerCounter_FSM;

architecture Behavioral of buzzerCounter_FSM is

signal count: STD_LOGIC_VECTOR (count_size-1 downto 0);

begin

counter: process(clk,reset)
begin
    if (rising_edge(clk)) then
        if(count(count_size-4) = '1') then
            if(count(count_size-3) = '1') then
                if(count(count_size-1) = '1') then
                zero_enable <= '1';
                end if;
            end if;
        elsif (reset = '1') then
                count <= (others => '0');
                zero_enable <= '0';
        else
                count <= count + 1;
        end if;
     end if;
end process;

end Behavioral;
