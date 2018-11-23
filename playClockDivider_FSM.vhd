library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockDivider_FSM is	
	PORT ( clk      		: in  STD_LOGIC;
           reset    		: in  STD_LOGIC;
           enable   		: in STD_LOGIC;
           set_secs : in STD_LOGIC_VECTOR (3 downto 0);
           set_tens_secs   : in STD_LOGIC_VECTOR (3 downto 0);
           set_mins        : in STD_LOGIC_VECTOR (3 downto 0);
           set_tens_mins   : in STD_LOGIC_VECTOR (3 downto 0);
           secs : out STD_LOGIC_VECTOR(3 downto 0);
           tens_secs : out STD_LOGIC_VECTOR(3 downto 0);
           mins : out STD_LOGIC_VECTOR(3 downto 0);
           tens_mins : out STD_LOGIC_VECTOR(3 downto 0)     
     );