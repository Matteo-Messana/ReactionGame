library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stimulus is
       PORT ( 
              enable         :   in STD_LOGIC;
              LED9to15       :   out STD_LOGIC
       );
end stimulus;

architecture Behavioral of stimulus is

begin

process(enable)
begin
    if(enable = '0') then
        LED9to15  <= (others => '0');
    elseif(enable = '1') then
        LED9to15  <= (others => '1');
    end if;
end process;

end Behavioral;
