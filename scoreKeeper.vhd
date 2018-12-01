library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scoreKeeper is
    PORT(   
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            
            player1_score_enable : in STD_LOGIC;
            player2_score_enable : in STD_LOGIC;
            
            player1_LEDs            : out STD_LOGIC_VECTOR(2 downto 0);
            player2_LEDs            : out STD_LOGIC_VECTOR(2 downto 0);
            
            player1_win_enable           : out STD_LOGIC;
            player2_win_enable           : out STD_LOGIC
            --buzzer_enable           : out STD_LOGIC
    );
end scoreKeeper;

architecture Behavioral of scoreKeeper is

signal player1_score : STD_LOGIC_VECTOR(1 downto 0);
signal player2_score : STD_LOGIC_VECTOR(1 downto 0);

signal player1_LEDs_i            : STD_LOGIC_VECTOR(2 downto 0);
signal player2_LEDs_i            : STD_LOGIC_VECTOR(2 downto 0);

signal player1_win_enable_i      :STD_LOGIC;
signal player2_win_enable_i      :STD_LOGIC;


begin

updatePlayerScore : process(reset, clk, player1_score_enable, player2_score_enable)
    begin
        if(reset = '1') then
            player1_score <= (others => '0');
            player2_score <= (others => '0');
        elsif(rising_edge(clk)) then
            if(player1_score_enable = '1') then
                player1_score <= player1_score + '1';
            elsif(player2_score_enable = '1') then 
                player2_score <= player2_score + '1';
            end if;
        end if;
end process;

displayPlayerScore : process(clk, player1_score, player2_score) --just gonna mark this in case it was a bad idea... internals on sensitivity list?
	begin 
		if(rising_edge(clk)) then
			if(player1_score = "00") then
				player1_LEDs_i <= "000";
				--buzzer_enable <= '0';
			elsif(player1_score = "01") then
				player1_LEDs_i <= "001";
			elsif(player1_score = "10") then
				player1_LEDs_i <= "011";
			elsif(player1_score <= "11") then
				player1_LEDs_i <= "111";
			end if;
			
			if(player2_score = "00") then
				player2_LEDs_i <= "000";
				--buzzer_enable <= '0';
			elsif(player2_score = "01") then
				player2_LEDs_i <= "001";
			elsif(player2_score = "10") then
				player2_LEDs_i <= "011";
			elsif(player2_score <= "11") then
				player2_LEDs_i <= "111";
			end if;
		end if;
	end process;
	
winnerEnable: process(clk, reset, player1_score, player2_score)
    begin
        if(reset = '1') then
            player1_win_enable_i  <= '0';
            player2_win_enable_i  <= '0';
            --buzzer_enable <= '0';
        elsif(falling_edge(clk)) then
            if(player1_score = "11") then
                player2_win_enable_i <= '0';  
                player1_win_enable_i <= '1';
                --buzzer_enable <= '1';
             elsif(player2_score = "11") then 
                player2_win_enable_i <= '1';
                player1_win_enable_i <= '0';
                --buzzer_enable <= '1';
             else 
                player1_win_enable_i <= '0';
                player2_win_enable_i <= '0';
             end if;
         end if;
 end process;
 
player1_LEDs <= player1_LEDs_i;
player2_LEDs <= player2_LEDs_i;

player1_win_enable <= player1_win_enable_i;
player2_win_enable <= player2_win_enable_i;

end Behavioral;
