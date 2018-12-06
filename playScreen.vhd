----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2018 07:37:15 PM
-- Design Name: 
-- Module Name: playScreen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity playScreen is
Port( clk   : in STD_LOGIC;
        reset : in STD_LOGIC;
        scan_line_x : in STD_LOGIC_VECTOR(10 downto 0);
        scan_line_y : in STD_LOGIC_VECTOR(10 downto 0);
        play_stimulus_enable : in STD_LOGIC;
        play_player1_win_enable : in STD_LOGIC;
        play_player2_win_enable : in STD_LOGIC;
        play_player_1_score : in STD_LOGIC_VECTOR(1 downto 0);
        play_player_2_score : in STD_LOGIC_VECTOR(1 downto 0);
        play_secs   : in STD_LOGIC_VECTOR(3 downto 0);
        play_tenths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
        play_hundredths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
        play_thousandths_secs   : in STD_LOGIC_VECTOR(3 downto 0);
        oneHz : in STD_LOGIC;
        red : out STD_LOGIC_VECTOR(3 downto 0);
        blue: out STD_LOGIC_VECTOR(3 downto 0);
        green : out STD_LOGIC_VECTOR(3 downto 0)
    );
end playScreen;

architecture Behavioral of playScreen is
--DEFINE SIGNALS HERE--
signal pixel_color : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
signal Q, D, oneHz_i : STD_LOGIC;
--DEFINE CONSTANTS HERE--

--TIME SIGNALS--
--Horizontal Axis Time Signals - SAME FOR ALL SIGNALS--
constant t_horizontal_pixel_48: std_logic_vector(9 downto 0) := "0000110000";
constant t_horizontal_pixel_60: std_logic_vector(9 downto 0) := "0000111100";
constant t_horizontal_pixel_96: std_logic_vector(9 downto 0) := "0001100000";
constant t_horizontal_pixel_108: std_logic_vector(9 downto 0) := "0001101100";
constant t_horizontal_pixel_144: std_logic_vector(9 downto 0) := "0010010000";
constant t_horizontal_pixel_156: std_logic_vector(9 downto 0) := "0010011100";
--Vertical Axis Time Signals (USE SECONDS DIGIT AS A REFERENCE-
constant t_vertical_pixel_80: std_logic_vector(9 downto 0) := "0001010000";
constant t_vertical_pixel_100: std_logic_vector(9 downto 0) := "0001100100";
constant t_vertical_pixel_160: std_logic_vector(9 downto 0) := "0010100000";
constant t_vertical_pixel_180: std_logic_vector(9 downto 0) := "0010110100";
--Time Digit Offsets--
constant tenths_offset : std_logic_vector(9 downto 0) := "0010001100";
constant hundredths_offset : std_logic_vector(9 downto 0) := "0100000100";
constant thousandths_offset : std_logic_vector(9 downto 0) := "0101111100";

--Decimal Point--
constant d_vertical_pixel_190: std_logic_vector(9 downto 0) := "0010111110";
constant d_vertical_pixel_210: std_logic_vector(9 downto 0) := "0011010010";
constant d_horizontal_pixel_144: std_logic_vector(9 downto 0) := "0010010000";
constant d_horizontal_pixel_168: std_logic_vector(9 downto 0) := "0010101000";

--Horizontal axis signals--
constant horizontal_pixel_192: std_logic_vector(9 downto 0) := "0011000000"; --Horizontal value 100
constant horizontal_pixel_240: std_logic_vector(9 downto 0) := "0011110000"; --Horizontal value 108
constant horizontal_pixel_264: std_logic_vector(9 downto 0) := "0100001000"; --Horizontal value 116
constant horizontal_pixel_312: std_logic_vector(9 downto 0) := "0100111000"; --Horizontal value 124
constant horizontal_pixel_336: std_logic_vector(9 downto 0) := "0101010000"; --Horizontal value 132
constant horizontal_pixel_360: std_logic_vector(9 downto 0) := "0101101000"; --Horizontal value 132
constant horizontal_pixel_384: std_logic_vector(9 downto 0) := "0110000000"; --Horizontal value 140
constant horizontal_pixel_408: std_logic_vector(9 downto 0) := "0110011000"; --Horizontal value 100
constant horizontal_pixel_432: std_logic_vector(9 downto 0) := "0110110000"; --Horizontal value 108
constant horizontal_pixel_456: std_logic_vector(9 downto 0) := "0111001000"; --Horizontal value 116

--Vertical axis signals--
constant vertical_pixel_20: std_logic_vector(9 downto 0) := "0000010100"; --Vertical value 64
constant vertical_pixel_40: std_logic_vector(9 downto 0) := "0000101000"; --Vertical value 72
constant vertical_pixel_160: std_logic_vector(9 downto 0) := "0010100000"; --Vertical value 76
constant vertical_pixel_180: std_logic_vector(9 downto 0) := "0010110100"; --Vertical value 64
constant vertical_pixel_240: std_logic_vector(9 downto 0) := "0011110000"; --Vertical value 72
constant vertical_pixel_400: std_logic_vector(9 downto 0) := "0110010000"; --Vertical value 76
constant vertical_pixel_460: std_logic_vector(9 downto 0) := "0111001100"; --Vertical value 64
constant vertical_pixel_480: std_logic_vector(9 downto 0) := "0111100000"; --Vertical value 72
constant vertical_pixel_600: std_logic_vector(9 downto 0) := "1001011000"; --Vertical value 76
constant vertical_pixel_620: std_logic_vector(9 downto 0) := "1001101100"; --Vertical value 64

--Colour Constants--
constant poly_green: std_logic_vector(11 downto 0) := "000011110000";
constant poly_yellow: std_logic_vector(11 downto 0) := "111111110000";
constant poly_magenta: std_logic_vector(11 downto 0) := "111100001111";
constant poly_blue: std_logic_vector(11 downto 0) := "000000001111";
constant poly_teal: std_logic_vector(11 downto 0) := "000010001000";
constant poly_cyan: std_logic_vector(11 downto 0) := "000011111111";
constant poly_black: std_logic_vector(11 downto 0) := "000000000000";
constant poly_maroon: std_logic_vector(11 downto 0) := "100000000000";
constant poly_olive: std_logic_vector(11 downto 0) := "100010000000";
constant poly_red: std_logic_vector(11 downto 0) := "111100000000";
constant poly_violet: std_logic_vector(11 downto 0) := "100000001000";

--Wait Signals--
--Horizontal axis signals for WAIT and GO!--
constant horizontal_pixel_270: std_logic_vector(9 downto 0) := "0100001110"; --Horizontal value 124
constant horizontal_pixel_282: std_logic_vector(9 downto 0) := "0100011010"; --Horizontal value 132
constant horizontal_pixel_294: std_logic_vector(9 downto 0) := "0100100110"; --Horizontal value 132
constant horizontal_pixel_306: std_logic_vector(9 downto 0) := "0100110010"; --Horizontal value 140
constant horizontal_pixel_318: std_logic_vector(9 downto 0) := "0100111110"; --Horizontal value 108
constant horizontal_pixel_330: std_logic_vector(9 downto 0) := "0101001010"; --Horizontal value 100

--Vertical axis signals for W--
constant vertical_pixel_244: std_logic_vector(9 downto 0) := "0011110100"; --Vertical value 72
constant vertical_pixel_252: std_logic_vector(9 downto 0) := "0011111100"; --Vertical value 76
constant vertical_pixel_256: std_logic_vector(9 downto 0) := "0100000000"; --Vertical value 64
constant vertical_pixel_264: std_logic_vector(9 downto 0) := "0100001000"; --Vertical value 72
constant vertical_pixel_268: std_logic_vector(9 downto 0) := "0100001100"; --Vertical value 76
constant vertical_pixel_276: std_logic_vector(9 downto 0) := "0100010100"; --Vertical value 64
--Verticacl axis signals for A--
constant vertical_pixel_284: std_logic_vector(9 downto 0) := "0100011100"; --Vertical value 72
constant vertical_pixel_292: std_logic_vector(9 downto 0) := "0100100100"; --Vertical value 76
constant vertical_pixel_308: std_logic_vector(9 downto 0) := "0100110100"; --Vertical value 64
constant vertical_pixel_316: std_logic_vector(9 downto 0) := "0100111100"; --Vertical value 72
--Vertical axis signals for I--
constant vertical_pixel_324: std_logic_vector(9 downto 0) := "0101000100"; --Vertical value 76
constant vertical_pixel_336: std_logic_vector(9 downto 0) := "0101010000"; --Vertical value 64
constant vertical_pixel_344: std_logic_vector(9 downto 0) := "0101011000"; --Vertical value 72
constant vertical_pixel_356: std_logic_vector(9 downto 0) := "0101100100"; --Vertical value 76
--Vertical axis signals for T--
constant vertical_pixel_364: std_logic_vector(9 downto 0) := "0101101100"; --Vertical value 72
constant vertical_pixel_376: std_logic_vector(9 downto 0) := "0101111000"; --Vertical value 76
constant vertical_pixel_384: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 72
constant vertical_pixel_396: std_logic_vector(9 downto 0) := "0110001100"; --Vertical value 76

--Vertical axis signals for G--
--constant vertical_pixel_264: std_logic_vector(9 downto 0) := "0101101100"; --Vertical value 72
constant vertical_pixel_272: std_logic_vector(9 downto 0) := "0100010000"; --Vertical value 76
constant vertical_pixel_280: std_logic_vector(9 downto 0) := "0100011000"; --Vertical value 72
constant vertical_pixel_288: std_logic_vector(9 downto 0) := "0100100000"; --Vertical value 76
constant vertical_pixel_296: std_logic_vector(9 downto 0) := "0100101000"; --Vertical value 76
--Vertical axis signals for O--
constant vertical_pixel_304: std_logic_vector(9 downto 0) := "0100110000"; --Vertical value 76
constant vertical_pixel_312: std_logic_vector(9 downto 0) := "0100111000"; --Vertical value 76
constant vertical_pixel_328: std_logic_vector(9 downto 0) := "0101001000"; --Vertical value 76
--constant vertical_pixel_336: std_logic_vector(9 downto 0) := "0110001100"; --Vertical value 76
--Vertical axis signals for !--
--constant vertical_pixel_356: std_logic_vector(9 downto 0) := "0110001100"; --Vertical value 76
--constant vertical_pixel_364: std_logic_vector(9 downto 0) := "0110001100"; --Vertical value 76

--WIN! Signals--
--Horizontal axis signals--
constant horizontal_pixel_366: std_logic_vector(9 downto 0) := "0101101110"; --Horizontal value 124
constant horizontal_pixel_378: std_logic_vector(9 downto 0) := "0101111010"; --Horizontal value 132
--constant horizontal_pixel_408: std_logic_vector(9 downto 0) := "0100111110"; --Horizontal value 108
constant horizontal_pixel_414: std_logic_vector(9 downto 0) := "0110011110"; --Horizontal value 132
constant horizontal_pixel_426: std_logic_vector(9 downto 0) := "0110101010"; --Horizontal value 140
--Vertical signals for WIN! should all have been defined already... will update as necessary--
constant vertical_pixel_332: std_logic_vector(9 downto 0) := "0101001100"; --Vertical value 76
constant vertical_pixel_348: std_logic_vector(9 downto 0) := "0101011100"; --Vertical value 72
begin
    
    ONE_HZ_HOLD: process(reset,clk,oneHz)
    begin
        if(reset ='1') then
             Q <= '0';
             D <= '0';
         elsif(rising_edge(clk)) then
             if(oneHz = '1') then
                 Q <= D;
                 D <= not Q;
             else
                 Q <= Q;
                 D <= D;
             end if;
            end if;
    end process;

oneHz_i <= Q;

    DRAW_PLAY_PANEL:  process(clk, scan_line_x, scan_line_y, play_player1_win_enable, play_player2_win_enable, play_player_1_score, play_player_2_score, oneHz_i)
    begin
       --TIME
       --Decimal Point--
        if  ((scan_line_x >= d_vertical_pixel_190) and --CB
            (scan_line_y >= d_horizontal_pixel_144) and 
            (scan_line_x < d_vertical_pixel_210) and 
            (scan_line_y < d_horizontal_pixel_168))then
                    pixel_color <= poly_green;
        --Seconds Digit 1--
        elsif((scan_line_x >= t_vertical_pixel_160) and --CB
            (scan_line_y >= t_horizontal_pixel_60) and 
             (scan_line_x < t_vertical_pixel_180) and 
             (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "0001") then
                    pixel_color <= poly_green;
        elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
            (scan_line_y >= t_horizontal_pixel_108) and 
             (scan_line_x < t_vertical_pixel_180) and 
             (scan_line_y < t_horizontal_pixel_144)) and  (play_secs = "0001") then
                    pixel_color <= poly_green;
        --Seconds Digit 2--
       elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
            (scan_line_y >= t_horizontal_pixel_48) and 
             (scan_line_x < t_vertical_pixel_160) and 
             (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0010") then
                    pixel_color <= poly_green;
        elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
            (scan_line_y >= t_horizontal_pixel_60) and 
             (scan_line_x < t_vertical_pixel_180) and 
             (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "0010") then
                    pixel_color <= poly_green;
        elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
            (scan_line_y >= t_horizontal_pixel_144) and 
             (scan_line_x < t_vertical_pixel_160) and 
             (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "0010") then
                    pixel_color <= poly_green;
       elsif  ((scan_line_x >= t_vertical_pixel_80) and --CE
            (scan_line_y >= t_horizontal_pixel_108) and 
             (scan_line_x < t_vertical_pixel_100) and 
             (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0010") then
                    pixel_color <= poly_green;
        elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
            (scan_line_y >= t_horizontal_pixel_96) and 
             (scan_line_x < t_vertical_pixel_160) and 
             (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "0010") then
                    pixel_color <= poly_green;
         --Seconds Digit 3--
         elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0011") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "0011") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0011") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "0011") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "0011") then
                      pixel_color <= poly_green;
         --Seconds Digit 4--
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "0100") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0100") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "0100") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "0100") then
                      pixel_color <= poly_green;
         --Seconds Digit 5--
         elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0101") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0101") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "0101") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "0101") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "0101") then
                      pixel_color <= poly_green;
         --Seconds Digit 6--
         elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0110") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0110") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "0110") then
                      pixel_color <= poly_green;
         elsif  ((scan_line_x >= t_vertical_pixel_80) and --CE
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0110") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "0110") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "0110") then
                      pixel_color <= poly_green;
         --Seconds Digit 7--
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0111") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "0111") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0111") then
                      pixel_color <= poly_green;
         --Seconds Digit 8--
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "1000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "1000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "1000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "1000") then
                      pixel_color <= poly_green;
         elsif  ((scan_line_x >= t_vertical_pixel_80) and --CE
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "1000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "1000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "1000") then
                      pixel_color <= poly_green;
         --Seconds Digit 9--
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "1001") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "1001") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "1001") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "1001") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "1001") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CG
              (scan_line_y >= t_horizontal_pixel_96) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_108)) and  (play_secs = "1001") then
                      pixel_color <= poly_green;
         --Seconds Digit 0--
         elsif  ((scan_line_x >= t_vertical_pixel_100) and --CA
              (scan_line_y >= t_horizontal_pixel_48) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_60)) and (play_secs = "0000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CB
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_96)) and  (play_secs = "0000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_160) and --CC
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_180) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_100) and --CD
              (scan_line_y >= t_horizontal_pixel_144) and 
               (scan_line_x < t_vertical_pixel_160) and 
               (scan_line_y < t_horizontal_pixel_156)) and  (play_secs = "0000") then
                      pixel_color <= poly_green;
         elsif  ((scan_line_x >= t_vertical_pixel_80) and --CE
              (scan_line_y >= t_horizontal_pixel_108) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_144)) and (play_secs = "0000") then
                      pixel_color <= poly_green;
          elsif  ((scan_line_x >= t_vertical_pixel_80) and --CF
              (scan_line_y >= t_horizontal_pixel_60) and 
               (scan_line_x < t_vertical_pixel_100) and 
               (scan_line_y < t_horizontal_pixel_96)) and (play_secs = "0000") then
                      pixel_color <= poly_green;
       --TENTHS-- 
       --TENTHS Digit 1--
               elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                   (scan_line_y >= t_horizontal_pixel_60) and 
                    (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "0001") then
                           pixel_color <= poly_green;
               elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                   (scan_line_y >= t_horizontal_pixel_108) and 
                    (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_144)) and  (play_tenths_secs = "0001") then
                           pixel_color <= poly_green;
               --TENTHS Digit 2--
              elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                   (scan_line_y >= t_horizontal_pixel_48) and 
                    (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0010") then
                           pixel_color <= poly_green;
               elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                   (scan_line_y >= t_horizontal_pixel_60) and 
                    (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "0010") then
                           pixel_color <= poly_green;
               elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                   (scan_line_y >= t_horizontal_pixel_144) and 
                    (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "0010") then
                           pixel_color <= poly_green;
              elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CE
                   (scan_line_y >= t_horizontal_pixel_108) and 
                    (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0010") then
                           pixel_color <= poly_green;
               elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                   (scan_line_y >= t_horizontal_pixel_96) and 
                    (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                    (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "0010") then
                           pixel_color <= poly_green;
                --TENTHS Digit 3--
                elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0011") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "0011") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0011") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "0011") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "0011") then
                             pixel_color <= poly_green;
                --TENTHS Digit 4--
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "0100") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0100") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "0100") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "0100") then
                             pixel_color <= poly_green;
                --TENTHS Digit 5--
                elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0101") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0101") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "0101") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "0101") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "0101") then
                             pixel_color <= poly_green;
                --TENTHS Digit 6--
                elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CE
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "0110") then
                             pixel_color <= poly_green;
                --TENTHS Digit 7--
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0111") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "0111") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0111") then
                             pixel_color <= poly_green;
                --TENTHS Digit 8--
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CE
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "1000") then
                             pixel_color <= poly_green;
                --TENTHS Digit 9--
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CG
                     (scan_line_y >= t_horizontal_pixel_96) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_108)) and  (play_tenths_secs = "1001") then
                             pixel_color <= poly_green;
                --TENTHS Digit 0--
                elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CA
                     (scan_line_y >= t_horizontal_pixel_48) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_60)) and (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CB
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and  (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_160+tenths_offset) and --CC
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_180+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_100+tenths_offset) and --CD
                     (scan_line_y >= t_horizontal_pixel_144) and 
                      (scan_line_x < t_vertical_pixel_160+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_156)) and  (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;
                elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CE
                     (scan_line_y >= t_horizontal_pixel_108) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_144)) and (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;
                 elsif  ((scan_line_x >= t_vertical_pixel_80+tenths_offset) and --CF
                     (scan_line_y >= t_horizontal_pixel_60) and 
                      (scan_line_x < t_vertical_pixel_100+tenths_offset) and 
                      (scan_line_y < t_horizontal_pixel_96)) and (play_tenths_secs = "0000") then
                             pixel_color <= poly_green;          
           --HUNDREDTHS--
                  --HUNDREDTHS Digit 1--
                   elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                       (scan_line_y >= t_horizontal_pixel_60) and 
                        (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "0001") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                       (scan_line_y >= t_horizontal_pixel_108) and 
                        (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_144)) and  (play_hundredths_secs = "0001") then
                               pixel_color <= poly_green;
                   --HUNDREDTHSDigit 2--
                  elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                       (scan_line_y >= t_horizontal_pixel_48) and 
                        (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                       (scan_line_y >= t_horizontal_pixel_60) and 
                        (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                       (scan_line_y >= t_horizontal_pixel_144) and 
                        (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "0010") then
                               pixel_color <= poly_green;
                  elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CE
                       (scan_line_y >= t_horizontal_pixel_108) and 
                        (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                       (scan_line_y >= t_horizontal_pixel_96) and 
                        (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                        (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "0010") then
                               pixel_color <= poly_green;
                    --HUNDREDTHS Digit 3--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "0011") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 4--
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "0100") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 5--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "0101") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 6--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "0110") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 7--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0111") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "0111") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0111") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 8--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "1000") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 9--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_hundredths_secs = "1001") then
                                 pixel_color <= poly_green;
                    --HUNDREDTHS Digit 0--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+hundredths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+hundredths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+hundredths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+hundredths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_hundredths_secs = "0000") then
                                 pixel_color <= poly_green;   
         --THOUSANDTHS--          
         --THOUSANDTHS Digit 1--
                   elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                       (scan_line_y >= t_horizontal_pixel_60) and 
                        (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "0001") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                       (scan_line_y >= t_horizontal_pixel_108) and 
                        (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_144)) and  (play_thousandths_secs = "0001") then
                               pixel_color <= poly_green;
                   --THOUSANDTHS Digit 2--
                  elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                       (scan_line_y >= t_horizontal_pixel_48) and 
                        (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                       (scan_line_y >= t_horizontal_pixel_60) and 
                        (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                       (scan_line_y >= t_horizontal_pixel_144) and 
                        (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "0010") then
                               pixel_color <= poly_green;
                  elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CE
                       (scan_line_y >= t_horizontal_pixel_108) and 
                        (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0010") then
                               pixel_color <= poly_green;
                   elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                       (scan_line_y >= t_horizontal_pixel_96) and 
                        (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                        (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "0010") then
                               pixel_color <= poly_green;
                    --THOUSANDTHS Digit 3--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "0011") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "0011") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 4--
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "0100") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "0100") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 5--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "0101") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "0101") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 6--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "0110") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 7--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0111") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "0111") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0111") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 8--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "1000") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 9--
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CG
                         (scan_line_y >= t_horizontal_pixel_96) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_108)) and  (play_thousandths_secs = "1001") then
                                 pixel_color <= poly_green;
                    --THOUSANDTHS Digit 0--
                    elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CA
                         (scan_line_y >= t_horizontal_pixel_48) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_60)) and (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CB
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and  (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_160+thousandths_offset) and --CC
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_180+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_100+thousandths_offset) and --CD
                         (scan_line_y >= t_horizontal_pixel_144) and 
                          (scan_line_x < t_vertical_pixel_160+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_156)) and  (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;
                    elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CE
                         (scan_line_y >= t_horizontal_pixel_108) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_144)) and (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;
                     elsif  ((scan_line_x >= t_vertical_pixel_80+thousandths_offset) and --CF
                         (scan_line_y >= t_horizontal_pixel_60) and 
                          (scan_line_x < t_vertical_pixel_100+thousandths_offset) and 
                          (scan_line_y < t_horizontal_pixel_96)) and (play_thousandths_secs = "0000") then
                                 pixel_color <= poly_green;                      
         
         
        --Define cases to draw P1 score here--
           elsif  ((scan_line_x >= vertical_pixel_20) and --Player 1 Box
                (scan_line_y >= horizontal_pixel_192) and 
                 (scan_line_x < vertical_pixel_180) and 
                 (scan_line_y < horizontal_pixel_240)) then
                        pixel_color <= poly_violet;
          elsif((scan_line_x >= vertical_pixel_460) and --Player 2 Box
                (scan_line_y >= horizontal_pixel_192) and 
                (scan_line_x < vertical_pixel_620) and 
                 (scan_line_y < horizontal_pixel_240)) then
                        pixel_color <= poly_yellow;
            
            --Flashing Wait--
             elsif((scan_line_x >= vertical_pixel_244) and --Wait W
                     (scan_line_y >= horizontal_pixel_270) and 
                     (scan_line_x < vertical_pixel_252) and 
                     (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0')) and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta; 
             elsif((scan_line_x >= vertical_pixel_256) and --Wait W
                (scan_line_y >= horizontal_pixel_270) and 
                 (scan_line_x < vertical_pixel_264) and 
                 (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0')) and (play_stimulus_enable = '0') then
                            pixel_color <= poly_magenta;
             elsif((scan_line_x >= vertical_pixel_268) and --Wait W
                (scan_line_y >= horizontal_pixel_270) and 
                (scan_line_x < vertical_pixel_276) and 
                (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta;                                                 
             elsif((scan_line_x >= vertical_pixel_244) and --Wait W
                (scan_line_y >= horizontal_pixel_318) and 
                (scan_line_x < vertical_pixel_276) and 
                (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta; 
             --A--
             elsif((scan_line_x >= vertical_pixel_284) and --Wait A
                  (scan_line_y >= horizontal_pixel_270) and 
                  (scan_line_x < vertical_pixel_292) and 
                  (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta; 
             elsif((scan_line_x >= vertical_pixel_284) and --Wait A
                (scan_line_y >= horizontal_pixel_270) and 
                 (scan_line_x < vertical_pixel_316) and 
                 (scan_line_y < horizontal_pixel_282)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta;
             elsif((scan_line_x >= vertical_pixel_308) and --Wait A
                (scan_line_y >= horizontal_pixel_270) and 
                (scan_line_x < vertical_pixel_316) and 
                (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta;                                                 
             elsif((scan_line_x >= vertical_pixel_284) and --Wait A
                (scan_line_y >= horizontal_pixel_294) and 
                (scan_line_x < vertical_pixel_316) and 
                (scan_line_y < horizontal_pixel_306)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                            pixel_color <= poly_magenta;
            --I--
            elsif((scan_line_x >= vertical_pixel_324) and --Wait I
               (scan_line_y >= horizontal_pixel_270) and 
                (scan_line_x < vertical_pixel_356) and 
                (scan_line_y < horizontal_pixel_282)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                           pixel_color <= poly_magenta;
            elsif((scan_line_x >= vertical_pixel_336) and --Wait I
               (scan_line_y >= horizontal_pixel_270) and 
               (scan_line_x < vertical_pixel_344) and 
               (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                           pixel_color <= poly_magenta;                                                 
            elsif((scan_line_x >= vertical_pixel_324) and --Wait I
               (scan_line_y >= horizontal_pixel_318) and 
               (scan_line_x < vertical_pixel_356) and 
               (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                           pixel_color <= poly_magenta;
           --T--
           elsif((scan_line_x >= vertical_pixel_364) and --Wait T
              (scan_line_y >= horizontal_pixel_270) and 
               (scan_line_x < vertical_pixel_396) and 
               (scan_line_y < horizontal_pixel_282)) and (oneHz_i = '1') and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                          pixel_color <= poly_magenta;
           elsif((scan_line_x >= vertical_pixel_376) and --Wait T
              (scan_line_y >= horizontal_pixel_270) and 
              (scan_line_x < vertical_pixel_384) and 
              (scan_line_y < horizontal_pixel_330)) and (oneHz_i = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))and (play_stimulus_enable = '0')then
                          pixel_color <= poly_magenta;                                                                                             
        
        --Flashing GO!-- --Take out oneHz, win enables--
        elsif((scan_line_x >= vertical_pixel_264) and --GO! G
             (scan_line_y >= horizontal_pixel_270) and 
             (scan_line_x < vertical_pixel_296) and 
             (scan_line_y < horizontal_pixel_282)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black; 
        elsif((scan_line_x >= vertical_pixel_264) and --GO! G
           (scan_line_y >= horizontal_pixel_270) and 
            (scan_line_x < vertical_pixel_272) and 
            (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
        elsif((scan_line_x >= vertical_pixel_264) and --GO! G
           (scan_line_y >= horizontal_pixel_318) and 
           (scan_line_x < vertical_pixel_296) and 
           (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;                                                 
        elsif((scan_line_x >= vertical_pixel_288) and --GO! G
           (scan_line_y >= horizontal_pixel_294) and 
           (scan_line_x < vertical_pixel_296) and 
           (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
        elsif((scan_line_x >= vertical_pixel_280) and --GO! G
           (scan_line_y >= horizontal_pixel_294) and 
           (scan_line_x < vertical_pixel_296) and 
           (scan_line_y < horizontal_pixel_306)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
        --O--
       elsif((scan_line_x >= vertical_pixel_304) and --GO! O
             (scan_line_y >= horizontal_pixel_270) and 
             (scan_line_x < vertical_pixel_312) and 
             (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black; 
        elsif((scan_line_x >= vertical_pixel_304) and --GO! O
           (scan_line_y >= horizontal_pixel_270) and 
            (scan_line_x < vertical_pixel_336) and 
            (scan_line_y < horizontal_pixel_282)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
        elsif((scan_line_x >= vertical_pixel_328) and --GO! O
           (scan_line_y >= horizontal_pixel_270) and 
           (scan_line_x < vertical_pixel_336) and 
           (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;                                                 
        elsif((scan_line_x >= vertical_pixel_304) and --GO! O
           (scan_line_y >= horizontal_pixel_318) and 
           (scan_line_x < vertical_pixel_336) and 
           (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
        --!--
        elsif((scan_line_x >= vertical_pixel_356) and --GO! !
             (scan_line_y >= horizontal_pixel_270) and 
             (scan_line_x < vertical_pixel_364) and 
             (scan_line_y < horizontal_pixel_312)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black; 
        elsif((scan_line_x >= vertical_pixel_356) and --GO! !
           (scan_line_y >= horizontal_pixel_318) and 
            (scan_line_x < vertical_pixel_364) and 
            (scan_line_y < horizontal_pixel_330)) and (play_stimulus_enable = '1')and ((play_player1_win_enable = '0') and (play_player2_win_enable = '0'))then
                       pixel_color <= poly_black;
                                         
        --Flashing WIN!--
        
        --Player 1 Score--
        elsif((scan_line_x >= vertical_pixel_40) and --Point 1 Box
                  (scan_line_y >= horizontal_pixel_264) and 
                  (scan_line_x < vertical_pixel_160) and 
                  (scan_line_y < horizontal_pixel_312)) and (play_player_1_score = "01")then
                        pixel_color <= poly_blue;
        elsif((scan_line_x >= vertical_pixel_40) and --Point 2 Box
              (scan_line_y >= horizontal_pixel_336) and 
              (scan_line_x < vertical_pixel_160) and 
              (scan_line_y < horizontal_pixel_384)) and (play_player_1_score = "10") then
                    pixel_color <= poly_teal;
            elsif((scan_line_x >= vertical_pixel_40) and --Point 1 Box
               (scan_line_y >= horizontal_pixel_264) and 
               (scan_line_x < vertical_pixel_160) and 
               (scan_line_y < horizontal_pixel_312)) and (play_player_1_score = "10")then
                    pixel_color <= poly_blue;
        elsif((scan_line_x >= vertical_pixel_40) and --Point 3 Box
              (scan_line_y >= horizontal_pixel_408) and 
              (scan_line_x < vertical_pixel_160) and 
              (scan_line_y < horizontal_pixel_456)) and (play_player_1_score = "11") then
                    pixel_color <= poly_cyan;
            elsif((scan_line_x >= vertical_pixel_40) and --Point 2 Box
               (scan_line_y >= horizontal_pixel_336) and 
               (scan_line_x < vertical_pixel_160) and 
                (scan_line_y < horizontal_pixel_384)) and (play_player_1_score = "11")then
                    pixel_color <= poly_teal;
            elsif((scan_line_x >= vertical_pixel_40) and --Point 1 Box
                (scan_line_y >= horizontal_pixel_264) and 
                (scan_line_x < vertical_pixel_160) and 
                 (scan_line_y < horizontal_pixel_312)) and (play_player_1_score = "11")then
                    pixel_color <= poly_blue;                    
        --Player 2 Score--
        elsif((scan_line_x >= vertical_pixel_480) and --Point 1 Box
              (scan_line_y >= horizontal_pixel_264) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_312)) and (play_player_2_score = "01")then
                    pixel_color <= poly_blue;
        elsif((scan_line_x >= vertical_pixel_480) and --Point 2 Box
              (scan_line_y >= horizontal_pixel_336) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_384)) and (play_player_2_score = "10")then
                    pixel_color <= poly_teal;
             elsif((scan_line_x >= vertical_pixel_480) and --Point 1 Box
              (scan_line_y >= horizontal_pixel_264) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_312)) and (play_player_2_score = "10")then
                    pixel_color <= poly_blue;
        elsif((scan_line_x >= vertical_pixel_480) and --Point 2 Box
              (scan_line_y >= horizontal_pixel_408) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_456)) and (play_player_2_score = "11") then
                    pixel_color <= poly_cyan;
             elsif((scan_line_x >= vertical_pixel_480) and --Point 2 Box
              (scan_line_y >= horizontal_pixel_336) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_384)) and (play_player_2_score = "11")then
                     pixel_color <= poly_teal;
             elsif((scan_line_x >= vertical_pixel_480) and --Point 1 Box
              (scan_line_y >= horizontal_pixel_264) and 
              (scan_line_x < vertical_pixel_600) and 
              (scan_line_y < horizontal_pixel_312)) and (play_player_2_score = "11")then
                     pixel_color <= poly_blue;                   
       --WIN! P1--
        --W--
        elsif ((scan_line_x >= vertical_pixel_244) and --WIN! W
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_252) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_256) and --WIN! W
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_264) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_268) and --WIN! W
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_276) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_244) and --WIN! W
               (scan_line_y >= horizontal_pixel_414) and 
               (scan_line_x < vertical_pixel_276) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        --I--
       elsif ((scan_line_x >= vertical_pixel_284) and --WIN! I
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_316) and 
               (scan_line_y < horizontal_pixel_378)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_284) and --WIN! I
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_316) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_296) and --WIN! I
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_304) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        --N--
       elsif ((scan_line_x >= vertical_pixel_324) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_332) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_336) and --WIN! N
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_344) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_348) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_356) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
       elsif ((scan_line_x >= vertical_pixel_324) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_336) and 
               (scan_line_y < horizontal_pixel_378)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_336) and --WIN! N
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_356) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        --!--
        elsif ((scan_line_x >= vertical_pixel_376) and --WIN! !
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_384) and 
               (scan_line_y < horizontal_pixel_408)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet;
        elsif ((scan_line_x >= vertical_pixel_376) and --WIN! !
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_384) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player1_win_enable = '1')then
                    pixel_color <= poly_violet; 
        --WIN! P2--
        --W--
        elsif ((scan_line_x >= vertical_pixel_244) and --WIN! W
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_252) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_256) and --WIN! W
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_264) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_268) and --WIN! W
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_276) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_244) and --WIN! W
               (scan_line_y >= horizontal_pixel_414) and 
               (scan_line_x < vertical_pixel_276) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        --I--
       elsif ((scan_line_x >= vertical_pixel_284) and --WIN! I
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_316) and 
               (scan_line_y < horizontal_pixel_378)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_284) and --WIN! I
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_316) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_296) and --WIN! I
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_304) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        --N--
       elsif ((scan_line_x >= vertical_pixel_324) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_332) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_336) and --WIN! N
            (scan_line_y >= horizontal_pixel_366) and 
             (scan_line_x < vertical_pixel_344) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_348) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_356) and 
               (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
       elsif ((scan_line_x >= vertical_pixel_324) and --WIN! N
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_336) and 
               (scan_line_y < horizontal_pixel_378)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_336) and --WIN! N
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_356) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        --!--
        elsif ((scan_line_x >= vertical_pixel_376) and --WIN! !
               (scan_line_y >= horizontal_pixel_366) and 
               (scan_line_x < vertical_pixel_384) and 
               (scan_line_y < horizontal_pixel_408)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;
        elsif ((scan_line_x >= vertical_pixel_376) and --WIN! !
            (scan_line_y >= horizontal_pixel_414) and 
             (scan_line_x < vertical_pixel_384) and 
             (scan_line_y < horizontal_pixel_426)) and (play_player2_win_enable = '1')then
                    pixel_color <= poly_yellow;                   
        else
            if(play_stimulus_enable = '1') then 
                pixel_color <= poly_red;
            else
                pixel_color <= poly_black;
            end if;
        end if;
    
    end process;
    
red <= pixel_color(11 downto 8);
green <= pixel_color(7 downto 4);
blue <= pixel_color(3 downto 0);

end Behavioral;
