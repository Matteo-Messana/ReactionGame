library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stimulus is
end tb_stimulus;

architecture behavioural of tb_stimulus is

component stimulus is
       PORT ( 
              enable         :   in STD_LOGIC;
              LED9to15       :   out STD_LOGIC_VECTOR(6 downto 0)
       );
end component;

--Inputs
signal enable : STD_LOGIC := '0';

--Outputs
signal LED9to15 : STD_LOGIC_VECTOR (6 downto 0);

BEGIN
uut:stimulus
PORT MAP(
			enable => enable,
			LED9to15 => LED9to15
		);
		
		stim_proc:process
		begin
		wait for 50 ns;
		enable <= '1';
		wait for 200 ns;
		enable <= '0';
		wait;
		end process;
		
end;