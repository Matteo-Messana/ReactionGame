----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2018 07:23:39 PM
-- Design Name: 
-- Module Name: text_display - Behavioral
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

entity text_display is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       scan_line_x : in STD_LOGIC_VECTOR(10 downto 0);
       scan_line_y : in STD_LOGIC_VECTOR(10 downto 0);
       oneHz : in STD_LOGIC;
       red : out STD_LOGIC_VECTOR(3 downto 0);
       green : out STD_LOGIC_VECTOR(3 downto 0);
       blue : out STD_LOGIC_VECTOR(3 downto 0) 
     );
end text_display;

architecture Behavioral of text_display is

--signals
signal D: STD_LOGIC;
signal Q: STD_LOGIC;
signal oneHz_i: STD_LOGIC;

--Constants for spelling out the word REACTION--

constant x_min: std_logic_vector(9 downto 0) := (others => '0');
constant y_min: std_logic_vector(9 downto 0) := (others => '0');

--Commonly re-used horizontal pixel axis values for REACTION--
constant horizontal_pixel_100: std_logic_vector(9 downto 0) := "0001100100"; --Horizontal value 100
constant horizontal_pixel_108: std_logic_vector(9 downto 0) := "0001101100"; --Horizontal value 108
constant horizontal_pixel_116: std_logic_vector(9 downto 0) := "0001110100"; --Horizontal value 116
constant horizontal_pixel_124: std_logic_vector(9 downto 0) := "0001111100"; --Horizontal value 124
constant horizontal_pixel_132: std_logic_vector(9 downto 0) := "0010000100"; --Horizontal value 132
constant horizontal_pixel_140: std_logic_vector(9 downto 0) := "0010001100"; --Horizontal value 140

--Commonly re-used horizontal pixel axis values for THE GAME--
constant horizontal_pixel_205: std_logic_vector(9 downto 0) := "0011001101"; --Horizontal value 205
constant horizontal_pixel_215: std_logic_vector(9 downto 0) := "0011010111"; --Horizontal value 215
constant horizontal_pixel_235: std_logic_vector(9 downto 0) := "0011101011"; --Horizontal value 235
constant horizontal_pixel_245: std_logic_vector(9 downto 0) := "0011110101"; --Horizontal value 245
constant horizontal_pixel_255: std_logic_vector(9 downto 0) := "0011111111"; --Horizontal value 255
constant horizontal_pixel_290: std_logic_vector(9 downto 0) := "0100100010"; --Horizontal value 290
constant horizontal_pixel_300: std_logic_vector(9 downto 0) := "0100101100"; --Horizontal value 300

--Commonly re-used horizontal pixel axis values for INSERT--
constant horizontal_pixel_388: std_logic_vector(9 downto 0) := "0110000100"; --Horizontal value 388
constant horizontal_pixel_396: std_logic_vector(9 downto 0) := "0110001100"; --Horizontal value 396
constant horizontal_pixel_400: std_logic_vector(9 downto 0) := "0110010000"; --Horizontal value 400
constant horizontal_pixel_404: std_logic_vector(9 downto 0) := "0110010100"; --Horizontal value 404
constant horizontal_pixel_412: std_logic_vector(9 downto 0) := "0110011100"; --Horizontal value 412
constant horizontal_pixel_416: std_logic_vector(9 downto 0) := "0110100000"; --Horizontal value 205
constant horizontal_pixel_420: std_logic_vector(9 downto 0) := "0110100100"; --Horizontal value 205
constant horizontal_pixel_428: std_logic_vector(9 downto 0) := "0110101100"; --Horizontal value 205

--General horizontal pixel axis--
constant horizontal_pixel_144: std_logic_vector(9 downto 0) := "0010010000"; --Horizontal value 412
constant horizontal_pixel_156: std_logic_vector(9 downto 0) := "0010011100"; --Horizontal value 205
constant horizontal_pixel_384: std_logic_vector(9 downto 0) := "0110000000"; --Horizontal value 412
constant horizontal_pixel_392: std_logic_vector(9 downto 0) := "0110001000"; --Horizontal value 205
constant horizontal_pixel_424: std_logic_vector(9 downto 0) := "0110101000"; --Horizontal value 205
constant horizontal_pixel_432: std_logic_vector(9 downto 0) := "0110110000"; --Horizontal value 205

--General vertical pixel axis--
constant vertical_pixel_60: std_logic_vector(9 downto 0) := "0000111100"; --Vertical value 64
constant vertical_pixel_580: std_logic_vector(9 downto 0) := "1001000100"; --Vertical value 72
constant vertical_pixel_80: std_logic_vector(9 downto 0) := "0001010000"; --Vertical value 76
--constant vertical_pixel_88: std_logic_vector(9 downto 0) := "0001010100"; --Vertical value 84
constant vertical_pixel_100: std_logic_vector(9 downto 0) := "0001100100"; --Vertical value 88
constant vertical_pixel_540: std_logic_vector(9 downto 0) := "1000011100"; --Vertical value 76
--constant vertical_pixel_552: std_logic_vector(9 downto 0) := "1000101000"; --Vertical value 84
constant vertical_pixel_560: std_logic_vector(9 downto 0) := "1000110000"; --Vertical value 88

--Vertical axis signals for REACTION letter R--
constant vertical_pixel_64: std_logic_vector(9 downto 0) := "0001000000"; --Vertical value 64
constant vertical_pixel_72: std_logic_vector(9 downto 0) := "0001001000"; --Vertical value 72
constant vertical_pixel_76: std_logic_vector(9 downto 0) := "0001001100"; --Vertical value 76
constant vertical_pixel_84: std_logic_vector(9 downto 0) := "0001010100"; --Vertical value 84
constant vertical_pixel_88: std_logic_vector(9 downto 0) := "0001011000"; --Vertical value 88
constant vertical_pixel_96: std_logic_vector(9 downto 0) := "0001100000"; --Vertical value 96
--Vertical axis signals for REACTION letter E--
constant vertical_pixel_104: std_logic_vector(9 downto 0) := "0001101000"; --Vertical value 104
constant vertical_pixel_112: std_logic_vector(9 downto 0) := "0001110000"; --Vertical value 112
constant vertical_pixel_136: std_logic_vector(9 downto 0) := "0010001000"; --Vertical value 136
--Vertical axis signals for REACTION letter A--
constant vertical_pixel_144: std_logic_vector(9 downto 0) := "0010010000"; --Vertical value 144
constant vertical_pixel_152: std_logic_vector(9 downto 0) := "0010011000"; --Vertical value 152
constant vertical_pixel_168: std_logic_vector(9 downto 0) := "0010101000"; --Vertical value 168
constant vertical_pixel_176: std_logic_vector(9 downto 0) := "0010110000"; --Vertical value 176
--Vertical axis signals for REACTION letter C--
constant vertical_pixel_184: std_logic_vector(9 downto 0) := "0010111000"; --Vertical value 184
constant vertical_pixel_192: std_logic_vector(9 downto 0) := "0011000000"; --Vertical value 192
constant vertical_pixel_208: std_logic_vector(9 downto 0) := "0011010000"; --Vertical value 208
constant vertical_pixel_216: std_logic_vector(9 downto 0) := "0011011000"; --Vertical value 216
--Vertical axis signals for REACTION letter T--
constant vertical_pixel_224: std_logic_vector(9 downto 0) := "0011100000"; --Vertical value 224
constant vertical_pixel_236: std_logic_vector(9 downto 0) := "0011101100"; --Vertical value 236
constant vertical_pixel_244: std_logic_vector(9 downto 0) := "0011110100"; --Vertical value 244
constant vertical_pixel_256: std_logic_vector(9 downto 0) := "0100000000"; --Vertical value 256
--Vertical axis signals for REACTION letter I--
constant vertical_pixel_264: std_logic_vector(9 downto 0) := "0100001000"; --Vertical value 264
constant vertical_pixel_276: std_logic_vector(9 downto 0) := "0100010100"; --Vertical value 276
constant vertical_pixel_284: std_logic_vector(9 downto 0) := "0100011100"; --Vertical value 284
constant vertical_pixel_296: std_logic_vector(9 downto 0) := "0100101000"; --Vertical value 296
--Vertical axis signals for REACTION letter O--
constant vertical_pixel_304: std_logic_vector(9 downto 0) := "0100110000"; --Vertical value 304
constant vertical_pixel_312: std_logic_vector(9 downto 0) := "0100111000"; --Vertical value 312
constant vertical_pixel_328: std_logic_vector(9 downto 0) := "0101001000"; --Vertical value 328
constant vertical_pixel_336: std_logic_vector(9 downto 0) := "0101010000"; --Vertical value 336
--Vertical axis signals for REACTION letter N--
constant vertical_pixel_344: std_logic_vector(9 downto 0) := "0101011000"; --Vertical value 344
constant vertical_pixel_352: std_logic_vector(9 downto 0) := "0101100000"; --Vertical value 352
constant vertical_pixel_356: std_logic_vector(9 downto 0) := "0101100100"; --Vertical value 356
constant vertical_pixel_364: std_logic_vector(9 downto 0) := "0101101100"; --Vertical value 364
constant vertical_pixel_368: std_logic_vector(9 downto 0) := "0101110000"; --Vertical value 368
constant vertical_pixel_376: std_logic_vector(9 downto 0) := "0101111000"; --Vertical value 376

--Vertical axis signals for GAME letter G--
constant vertical_pixel_424: std_logic_vector(9 downto 0) := "0110101000"; --Vertical value 344
constant vertical_pixel_432: std_logic_vector(9 downto 0) := "0110110000"; --Vertical value 352
constant vertical_pixel_440: std_logic_vector(9 downto 0) := "0110111000"; --Vertical value 356
constant vertical_pixel_448: std_logic_vector(9 downto 0) := "0111000000"; --Vertical value 364
constant vertical_pixel_456: std_logic_vector(9 downto 0) := "0111001000"; --Vertical value 368
--Vertical axis signals for GAME letter A--
constant vertical_pixel_464: std_logic_vector(9 downto 0) := "0111010000"; --Vertical value 352
constant vertical_pixel_472: std_logic_vector(9 downto 0) := "0111011000"; --Vertical value 356
constant vertical_pixel_488: std_logic_vector(9 downto 0) := "0111101000"; --Vertical value 364
constant vertical_pixel_496: std_logic_vector(9 downto 0) := "0111110000"; --Vertical value 368
--Vertical axis signals for GAME letter M--
constant vertical_pixel_504: std_logic_vector(9 downto 0) := "0111111000"; --Vertical value 344
constant vertical_pixel_512: std_logic_vector(9 downto 0) := "1000000000"; --Vertical value 352
constant vertical_pixel_516: std_logic_vector(9 downto 0) := "1000000100"; --Vertical value 356
constant vertical_pixel_524: std_logic_vector(9 downto 0) := "1000001100"; --Vertical value 364
constant vertical_pixel_528: std_logic_vector(9 downto 0) := "1000010000"; --Vertical value 368
constant vertical_pixel_536: std_logic_vector(9 downto 0) := "1000011000"; --Vertical value 376
--Vertical axis signals for GAME letter E--
constant vertical_pixel_544: std_logic_vector(9 downto 0) := "1000100000"; --Vertical value 364
constant vertical_pixel_552: std_logic_vector(9 downto 0) := "1000101000"; --Vertical value 368
constant vertical_pixel_576: std_logic_vector(9 downto 0) := "1001000000"; --Vertical value 376


--Vertical axis signals for THE letter T--
constant vertical_pixel_85: std_logic_vector(9 downto 0) := "0001010101"; --Vertical value 85
constant vertical_pixel_105: std_logic_vector(9 downto 0) := "0001101001"; --Vertical value 105
constant vertical_pixel_115: std_logic_vector(9 downto 0) := "0001110011"; --Vertical value 115
constant vertical_pixel_135: std_logic_vector(9 downto 0) := "0010000111"; --Vertical value 135
--Vertical axis signals for THE letter H--
constant vertical_pixel_145: std_logic_vector(9 downto 0) := "0010010001"; --Vertical value 145
constant vertical_pixel_155: std_logic_vector(9 downto 0) := "0010011011"; --Vertical value 155
constant vertical_pixel_185: std_logic_vector(9 downto 0) := "0010111001"; --Vertical value 185
constant vertical_pixel_195: std_logic_vector(9 downto 0) := "0011000011"; --Vertical value 195
--Vertical axis signals for THE letter E--
constant vertical_pixel_205: std_logic_vector(9 downto 0) := "0011001101"; --Vertical value 205
constant vertical_pixel_215: std_logic_vector(9 downto 0) := "0011010111"; --Vertical value 215
constant vertical_pixel_255: std_logic_vector(9 downto 0) := "0011111111"; --Vertical value 255


--Vertical axis signals for GAME letter G--
constant vertical_pixel_325: std_logic_vector(9 downto 0) := "0101000101"; --Vertical value 325
constant vertical_pixel_335: std_logic_vector(9 downto 0) := "0101001111"; --Vertical value 335
constant vertical_pixel_350: std_logic_vector(9 downto 0) := "0101011110"; --Vertical value 350
constant vertical_pixel_365: std_logic_vector(9 downto 0) := "0101101101"; --Vertical value 365
constant vertical_pixel_375: std_logic_vector(9 downto 0) := "0101110111"; --Vertical value 375
--Vertical axis signals for GAME letter A--
constant vertical_pixel_385: std_logic_vector(9 downto 0) := "0110000001"; --Vertical value 385
constant vertical_pixel_395: std_logic_vector(9 downto 0) := "0110001011"; --Vertical value 395
constant vertical_pixel_425: std_logic_vector(9 downto 0) := "0110101001"; --Vertical value 425
constant vertical_pixel_435: std_logic_vector(9 downto 0) := "0110110011"; --Vertical value 435
--Vertical axis signals for GAME letter M--
constant vertical_pixel_445: std_logic_vector(9 downto 0) := "0110111101"; --Vertical value 445
constant vertical_pixel_455: std_logic_vector(9 downto 0) := "0111000111"; --Vertical value 455
constant vertical_pixel_465: std_logic_vector(9 downto 0) := "0111010001"; --Vertical value 465
constant vertical_pixel_475: std_logic_vector(9 downto 0) := "0111011011"; --Vertical value 475
constant vertical_pixel_485: std_logic_vector(9 downto 0) := "0111100101"; --Vertical value 485
constant vertical_pixel_495: std_logic_vector(9 downto 0) := "0111101111"; --Vertical value 495
--Vertical axis signals for GAME letter E--
constant vertical_pixel_505: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_515: std_logic_vector(9 downto 0) := "1000000011"; --Vertical value 515
constant vertical_pixel_555: std_logic_vector(9 downto 0) := "1000101011"; --Vertical value 555

--INSERT--
--Vertical axis signals for INSERT letter I--
--constant vertical_pixel_104: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_116: std_logic_vector(9 downto 0) := "0001110100"; --Vertical value 515
constant vertical_pixel_124: std_logic_vector(9 downto 0) := "0001111100"; --Vertical value 555
--constant vertical_pixel_136: std_logic_vector(9 downto 0) := "0010001000"; --Vertical value 555
--Vertical axis signals for INSERT letter N--
--constant vertical_pixel_144: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
--constant vertical_pixel_152: std_logic_vector(9 downto 0) := "0001110100"; --Vertical value 515
constant vertical_pixel_156: std_logic_vector(9 downto 0) := "0010011100"; --Vertical value 555
constant vertical_pixel_164: std_logic_vector(9 downto 0) := "0010100100"; --Vertical value 555
--constant vertical_pixel_168: std_logic_vector(9 downto 0) := "0010001000"; --Vertical value 555
--constant vertical_pixel_176: std_logic_vector(9 downto 0) := "0010001000"; --Vertical value 555
--Vertical axis signals for INSERT letter S--
--constant vertical_pixel_184: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
--constant vertical_pixel_192: std_logic_vector(9 downto 0) := "0001110100"; --Vertical value 515
--constant vertical_pixel_208: std_logic_vector(9 downto 0) := "0010011100"; --Vertical value 555
--constant vertical_pixel_216: std_logic_vector(9 downto 0) := "0010100100"; --Vertical value 555
--Vertical axis signals for INSERT letter E--
--constant vertical_pixel_224: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_232: std_logic_vector(9 downto 0) := "0011101000"; --Vertical value 515
--constant vertical_pixel_256: std_logic_vector(9 downto 0) := "1000101011"; --Vertical value 555
--Vertical axis signals for INSERT letter R--
--constant vertical_pixel_264: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_272: std_logic_vector(9 downto 0) := "0100010000"; --Vertical value 515
--constant vertical_pixel_276: std_logic_vector(9 downto 0) := "1000101011"; --Vertical value 555
--constant vertical_pixel_284: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_288: std_logic_vector(9 downto 0) := "0100100000"; --Vertical value 515
--constant vertical_pixel_296: std_logic_vector(9 downto 0) := "1000101011"; --Vertical value 555
--Vertical axis signals for INSERT letter T--
--constant vertical_pixel_304: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505
constant vertical_pixel_316: std_logic_vector(9 downto 0) := "0100111100"; --Vertical value 515
constant vertical_pixel_324: std_logic_vector(9 downto 0) := "0101000100"; --Vertical value 555
--constant vertical_pixel_336: std_logic_vector(9 downto 0) := "0111111001"; --Vertical value 505

--COIN--
--Vertical axis signals for COIN letter C--
constant vertical_pixel_384: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 555
constant vertical_pixel_392: std_logic_vector(9 downto 0) := "0110001000"; --Vertical value 555
constant vertical_pixel_408: std_logic_vector(9 downto 0) := "0110011000"; --Vertical value 555
constant vertical_pixel_416: std_logic_vector(9 downto 0) := "0110100000"; --Vertical value 555
--Vertical axis signals for COIN letter O--
--constant vertical_pixel_424: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 555
--constant vertical_pixel_432: std_logic_vector(9 downto 0) := "0110001000"; --Vertical value 555
--constant vertical_pixel_448: std_logic_vector(9 downto 0) := "0110011000"; --Vertical value 555
--constant vertical_pixel_456: std_logic_vector(9 downto 0) := "0110100000"; --Vertical value 555
--Vertical axis signals for COIN letter I--
--constant vertical_pixel_464: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 555
constant vertical_pixel_476: std_logic_vector(9 downto 0) := "0111011100"; --Vertical value 555
constant vertical_pixel_484: std_logic_vector(9 downto 0) := "0111100100"; --Vertical value 555
--constant vertical_pixel_496: std_logic_vector(9 downto 0) := "0110100000"; --Vertical value 555
--Vertical axis signals for COIN letter N--
--constant vertical_pixel_504: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 555
--constant vertical_pixel_512: std_logic_vector(9 downto 0) := "0110001000"; --Vertical value 555
--constant vertical_pixel_516: std_logic_vector(9 downto 0) := "0110011000"; --Vertical value 555
--constant vertical_pixel_524: std_logic_vector(9 downto 0) := "0110100000"; --Vertical value 555
--constant vertical_pixel_528: std_logic_vector(9 downto 0) := "0110000000"; --Vertical value 555
--constant vertical_pixel_536: std_logic_vector(9 downto 0) := "0110001000"; --Vertical value 555

--Constants to define pixel colors--
constant poly_color: std_logic_vector(11 downto 0) := "000000000000";
constant poly_white: std_logic_vector(11 downto 0) := "111111111111";
constant poly_red: std_logic_vector(11 downto 0) := "111100000000";
signal pixel_color: std_logic_vector(11 downto 0);

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

DISPLAY: process(clk,oneHz_i, scan_line_x, scan_line_y) 
begin 
            --POLYGONS/LINE SEGMENTS FOR THE LETTERS OF REACTION--
            --R--
            if  ((scan_line_x >= vertical_pixel_64) and --R1
                (scan_line_y >= horizontal_pixel_100) and 
                 (scan_line_x < vertical_pixel_72) and 
                 (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;
            elsif ((scan_line_x >= vertical_pixel_64) and --R2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_96) and 
                  (scan_line_y < horizontal_pixel_108)) then
                        pixel_color <= poly_color;
            elsif ((scan_line_x >= vertical_pixel_88) and --R3
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_96) and 
                  (scan_line_y < horizontal_pixel_124)) then
                        pixel_color <= poly_color;
            elsif ((scan_line_x >= vertical_pixel_76) and --R4
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_96) and 
                  (scan_line_y < horizontal_pixel_124)) then
                        pixel_color <= poly_color;
            elsif ((scan_line_x >= vertical_pixel_76) and --R5 
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_84) and 
                  (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;       
            elsif ((scan_line_x >= vertical_pixel_76) and --R6
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_96) and 
                  (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;   
           --E--
            elsif ((scan_line_x >= vertical_pixel_104) and --E1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_112) and 
                  (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;           
            elsif ((scan_line_x >= vertical_pixel_104) and --E2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_136) and 
                  (scan_line_y < horizontal_pixel_108)) then
                        pixel_color <= poly_color;                
            elsif ((scan_line_x >= vertical_pixel_104) and --E3
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_136) and 
                  (scan_line_y < horizontal_pixel_124)) then
                        pixel_color <= poly_color;                                          
            elsif ((scan_line_x >= vertical_pixel_104) and --E4
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_136) and 
                  (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;
            --A--           
            elsif ((scan_line_x >= vertical_pixel_144) and --A1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_152) and 
                   (scan_line_y < horizontal_pixel_140)) then
                        pixel_color <= poly_color;                          
            elsif ((scan_line_x >= vertical_pixel_144) and --A2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_176) and 
                  (scan_line_y < horizontal_pixel_108)) then
                         pixel_color <= poly_color;                       
            elsif ((scan_line_x >= vertical_pixel_168) and --A3
                   (scan_line_y >= horizontal_pixel_100) and 
                   (scan_line_x < vertical_pixel_176) and 
                   (scan_line_y < horizontal_pixel_140)) then
                         pixel_color <= poly_color;                                                      
            elsif ((scan_line_x >= vertical_pixel_144) and --A4
                   (scan_line_y >= horizontal_pixel_116) and 
                   (scan_line_x < vertical_pixel_176) and 
                   (scan_line_y < horizontal_pixel_124)) then
                          pixel_color <= poly_color;   
            --C--              
            elsif ((scan_line_x >= vertical_pixel_184) and --C1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_192) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                               
            elsif ((scan_line_x >= vertical_pixel_184) and --C2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_216) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_208) and --C3
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_216) and 
                  (scan_line_y < horizontal_pixel_116)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_184) and --C4
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_216) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                     
            elsif ((scan_line_x >= vertical_pixel_208) and --C5
                  (scan_line_y >= horizontal_pixel_124) and 
                  (scan_line_x < vertical_pixel_216) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                                                                                               
            --T--
            elsif ((scan_line_x >= vertical_pixel_224) and --C3
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_256) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_236) and --C4
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_244) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;  
            --I--
            elsif ((scan_line_x >= vertical_pixel_264) and --I1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_296) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_276) and --I2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_284) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;  
             elsif ((scan_line_x >= vertical_pixel_264) and --I3
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_296) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                                           
            --O--
           elsif ((scan_line_x >= vertical_pixel_304) and --O1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_336) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                               
            elsif ((scan_line_x >= vertical_pixel_304) and --O2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_312) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_304) and --O3
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_336) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_328) and --O4
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_336) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                     
            --N--
            elsif ((scan_line_x >= vertical_pixel_344) and --C1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_352) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                               
            elsif ((scan_line_x >= vertical_pixel_344) and --C2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_364) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_356) and --C3
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_364) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_356) and --C4
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_376) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                     
            elsif ((scan_line_x >= vertical_pixel_368) and --C5
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_376) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;   
            --GAME-- 
            --G--
            elsif ((scan_line_x >= vertical_pixel_424) and --G1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_432) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                               
            elsif ((scan_line_x >= vertical_pixel_424) and --G2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_456) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_424) and --G3
                  (scan_line_y >= horizontal_pixel_132) and 
                  (scan_line_x < vertical_pixel_456) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_448) and --G4
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_456) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                     
            elsif ((scan_line_x >= vertical_pixel_440) and --G5
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_456) and 
                  (scan_line_y < horizontal_pixel_124)) then
                          pixel_color <= poly_color;
            --A--
           elsif ((scan_line_x >= vertical_pixel_464) and --A1
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_472) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_488) and --A2
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_496) and 
                  (scan_line_y < horizontal_pixel_140)) then
                          pixel_color <= poly_color;                                                           
            elsif ((scan_line_x >= vertical_pixel_464) and --A3
                  (scan_line_y >= horizontal_pixel_100) and 
                  (scan_line_x < vertical_pixel_496) and 
                  (scan_line_y < horizontal_pixel_108)) then
                          pixel_color <= poly_color;                     
            elsif ((scan_line_x >= vertical_pixel_464) and --A4
                  (scan_line_y >= horizontal_pixel_116) and 
                  (scan_line_x < vertical_pixel_496) and 
                  (scan_line_y < horizontal_pixel_124)) then
                          pixel_color <= poly_color;
            --M--
            elsif ((scan_line_x >= vertical_pixel_504) and --M1
                   (scan_line_y >= horizontal_pixel_100) and 
                   (scan_line_x < vertical_pixel_512) and 
                   (scan_line_y < horizontal_pixel_140)) then
                           pixel_color <= poly_color;                              
             elsif ((scan_line_x >= vertical_pixel_516) and --M2
                   (scan_line_y >= horizontal_pixel_100) and 
                   (scan_line_x < vertical_pixel_524) and 
                   (scan_line_y < horizontal_pixel_140)) then
                           pixel_color <= poly_color;                                                           
             elsif ((scan_line_x >= vertical_pixel_528) and --M3
                   (scan_line_y >= horizontal_pixel_100) and 
                   (scan_line_x < vertical_pixel_536) and 
                   (scan_line_y < horizontal_pixel_140)) then
                           pixel_color <= poly_color;                     
             elsif ((scan_line_x >= vertical_pixel_504) and --M4
                   (scan_line_y >= horizontal_pixel_100) and 
                   (scan_line_x < vertical_pixel_536) and 
                   (scan_line_y < horizontal_pixel_108)) then
                           pixel_color <= poly_color;
             --E--
             elsif ((scan_line_x >= vertical_pixel_544) and --E1
                    (scan_line_y >= horizontal_pixel_100) and 
                    (scan_line_x < vertical_pixel_552) and 
                    (scan_line_y < horizontal_pixel_140)) then
                            pixel_color <= poly_color;                              
              elsif ((scan_line_x >= vertical_pixel_544) and --E2
                    (scan_line_y >= horizontal_pixel_100) and 
                    (scan_line_x < vertical_pixel_576) and 
                    (scan_line_y < horizontal_pixel_108)) then
                            pixel_color <= poly_color;                                                           
              elsif ((scan_line_x >= vertical_pixel_544) and --E3
                    (scan_line_y >= horizontal_pixel_116) and 
                    (scan_line_x < vertical_pixel_576) and 
                    (scan_line_y < horizontal_pixel_124)) then
                            pixel_color <= poly_color;                     
              elsif ((scan_line_x >= vertical_pixel_544) and --E4
                    (scan_line_y >= horizontal_pixel_132) and 
                    (scan_line_x < vertical_pixel_576) and 
                    (scan_line_y < horizontal_pixel_140)) then
                            pixel_color <= poly_color;
                            
                            
                            
              --T--
              elsif ((scan_line_x >= vertical_pixel_85) and --T1
                    (scan_line_y >= horizontal_pixel_205) and 
                    (scan_line_x < vertical_pixel_135) and 
                    (scan_line_y < horizontal_pixel_215)) then
                    pixel_color <= poly_color;                              
              elsif ((scan_line_x >= vertical_pixel_105) and --T2
                    (scan_line_y >= horizontal_pixel_215) and 
                    (scan_line_x < vertical_pixel_115) and 
                    (scan_line_y < horizontal_pixel_300)) then
                    pixel_color <= poly_color;    
                    
             --H--
              elsif ((scan_line_x >= vertical_pixel_145) and --H1
                     (scan_line_y >= horizontal_pixel_205) and 
                     (scan_line_x < vertical_pixel_155) and 
                     (scan_line_y < horizontal_pixel_300)) then
                     pixel_color <= poly_color;                              
              elsif ((scan_line_x >= vertical_pixel_155) and --H2
                     (scan_line_y >= horizontal_pixel_245) and 
                     (scan_line_x < vertical_pixel_185) and 
                     (scan_line_y < horizontal_pixel_255)) then
                      pixel_color <= poly_color;    
              elsif ((scan_line_x >= vertical_pixel_185) and --H3
                     (scan_line_y >= horizontal_pixel_205) and 
                     (scan_line_x < vertical_pixel_195) and 
                     (scan_line_y < horizontal_pixel_300)) then
                     pixel_color <= poly_color;
            --E--
               elsif ((scan_line_x >= vertical_pixel_205) and --E1
                   (scan_line_y >= horizontal_pixel_205) and 
                   (scan_line_x < vertical_pixel_215) and 
                   (scan_line_y < horizontal_pixel_300)) then
                   pixel_color <= poly_color;                              
            elsif ((scan_line_x >= vertical_pixel_205) and --E2
                   (scan_line_y >= horizontal_pixel_205) and 
                   (scan_line_x < vertical_pixel_255) and 
                   (scan_line_y < horizontal_pixel_215)) then
                    pixel_color <= poly_color;    
            elsif ((scan_line_x >= vertical_pixel_205) and --E3
                   (scan_line_y >= horizontal_pixel_245) and 
                   (scan_line_x < vertical_pixel_255) and 
                   (scan_line_y < horizontal_pixel_255)) then
                   pixel_color <= poly_color;   
            elsif ((scan_line_x >= vertical_pixel_205) and --E4
                   (scan_line_y >= horizontal_pixel_290) and 
                   (scan_line_x < vertical_pixel_255) and 
                   (scan_line_y < horizontal_pixel_300)) then
                    pixel_color <= poly_color;
           --G--
                    elsif ((scan_line_x >= vertical_pixel_325) and --G1
                          (scan_line_y >= horizontal_pixel_205) and 
                          (scan_line_x < vertical_pixel_335) and 
                          (scan_line_y < horizontal_pixel_300)) then
                          pixel_color <= poly_color;                              
                    elsif ((scan_line_x >= vertical_pixel_325) and --G2
                            (scan_line_y >= horizontal_pixel_205) and 
                            (scan_line_x < vertical_pixel_375) and 
                            (scan_line_y < horizontal_pixel_215)) then
                            pixel_color <= poly_color;    
                   elsif ((scan_line_x >= vertical_pixel_335) and --G3
                            (scan_line_y >= horizontal_pixel_290) and 
                            (scan_line_x < vertical_pixel_375) and 
                            (scan_line_y < horizontal_pixel_300)) then
                            pixel_color <= poly_color;   
                   elsif ((scan_line_x >= vertical_pixel_365) and --G4
                            (scan_line_y >= horizontal_pixel_245) and 
                            (scan_line_x < vertical_pixel_375) and 
                            (scan_line_y < horizontal_pixel_300)) then
                             pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_350) and --G5
                             (scan_line_y >= horizontal_pixel_245) and 
                             (scan_line_x < vertical_pixel_365) and 
                             (scan_line_y < horizontal_pixel_255)) then
                             pixel_color <= poly_color;

                   --A--
                   elsif ((scan_line_x >= vertical_pixel_385) and --A1
                            (scan_line_y >= horizontal_pixel_205) and 
                            (scan_line_x < vertical_pixel_395) and 
                            (scan_line_y < horizontal_pixel_300)) then
                            pixel_color <= poly_color;    
                   elsif ((scan_line_x >= vertical_pixel_385) and --A2
                            (scan_line_y >= horizontal_pixel_205) and 
                            (scan_line_x < vertical_pixel_435) and 
                            (scan_line_y < horizontal_pixel_215)) then
                            pixel_color <= poly_color;   
                   elsif ((scan_line_x >= vertical_pixel_395) and --A3
                            (scan_line_y >= horizontal_pixel_235) and 
                            (scan_line_x < vertical_pixel_425) and 
                            (scan_line_y < horizontal_pixel_245)) then
                             pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_425) and --A4
                             (scan_line_y >= horizontal_pixel_205) and 
                             (scan_line_x < vertical_pixel_435) and 
                             (scan_line_y < horizontal_pixel_300)) then
                             pixel_color <= poly_color;

                    --M--
                   elsif ((scan_line_x >= vertical_pixel_445) and --M1
                            (scan_line_y >= horizontal_pixel_205) and 
                            (scan_line_x < vertical_pixel_495) and 
                            (scan_line_y < horizontal_pixel_215)) then
                            pixel_color <= poly_color;    
                   elsif ((scan_line_x >= vertical_pixel_445) and --M2
                            (scan_line_y >= horizontal_pixel_205) and 
                            (scan_line_x < vertical_pixel_455) and 
                            (scan_line_y < horizontal_pixel_300)) then
                            pixel_color <= poly_color;   
                   elsif ((scan_line_x >= vertical_pixel_465) and --M3
                            (scan_line_y >= horizontal_pixel_215) and 
                            (scan_line_x < vertical_pixel_475) and 
                            (scan_line_y < horizontal_pixel_300)) then
                             pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_485) and --M4
                             (scan_line_y >= horizontal_pixel_205) and 
                             (scan_line_x < vertical_pixel_495) and 
                             (scan_line_y < horizontal_pixel_300)) then
                             pixel_color <= poly_color;

                    --E--
                   elsif ((scan_line_x >= vertical_pixel_505) and --E1
                       (scan_line_y >= horizontal_pixel_205) and 
                       (scan_line_x < vertical_pixel_515) and 
                       (scan_line_y < horizontal_pixel_300)) then
                       pixel_color <= poly_color;                              
                  elsif ((scan_line_x >= vertical_pixel_505) and --E2
                       (scan_line_y >= horizontal_pixel_205) and 
                       (scan_line_x < vertical_pixel_555) and 
                       (scan_line_y < horizontal_pixel_215)) then
                        pixel_color <= poly_color;    
                    elsif ((scan_line_x >= vertical_pixel_505) and --E3
                       (scan_line_y >= horizontal_pixel_245) and 
                       (scan_line_x < vertical_pixel_555) and 
                       (scan_line_y < horizontal_pixel_255)) then
                       pixel_color <= poly_color;   
                 elsif ((scan_line_x >= vertical_pixel_505) and --E4
                       (scan_line_y >= horizontal_pixel_290) and 
                       (scan_line_x < vertical_pixel_555) and 
                       (scan_line_y < horizontal_pixel_300)) then
                        pixel_color <= poly_color;
                 -- Underline --
                 elsif ((scan_line_x >= vertical_pixel_60) and --E4
                       (scan_line_y >= horizontal_pixel_144) and 
                       (scan_line_x < vertical_pixel_580) and 
                       (scan_line_y < horizontal_pixel_156)) then
                        pixel_color <= poly_color;
                        
                   elsif(oneHz_i = '1') then
                     --INSERT--
                          --I--
                     if((scan_line_x >= vertical_pixel_104) and --I1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_136) and 
                           (scan_line_y < horizontal_pixel_396)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_116) and --I2
                           (scan_line_y >= horizontal_pixel_396) and 
                           (scan_line_x < vertical_pixel_124) and 
                           (scan_line_y < horizontal_pixel_420)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_104) and --I3
                           (scan_line_y >= horizontal_pixel_420) and 
                           (scan_line_x < vertical_pixel_136) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                        --N--
                     elsif ((scan_line_x >= vertical_pixel_144) and --N1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_152) and 
                           (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_144) and --N2
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_164) and 
                           (scan_line_y < horizontal_pixel_396)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_156) and --N3
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_164) and 
                           (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_156) and --N4
                           (scan_line_y >= horizontal_pixel_420) and 
                           (scan_line_x < vertical_pixel_176) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_168) and --N4
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_176) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;

                            --S--
                     elsif ((scan_line_x >= vertical_pixel_184) and --S1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_216) and 
                           (scan_line_y < horizontal_pixel_396)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_208) and --S2
                           (scan_line_y >= horizontal_pixel_396) and 
                           (scan_line_x < vertical_pixel_216) and 
                           (scan_line_y < horizontal_pixel_400)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_184) and --S3
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_192) and 
                           (scan_line_y < horizontal_pixel_412)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_184) and --S4
                           (scan_line_y >= horizontal_pixel_404) and 
                           (scan_line_x < vertical_pixel_216) and 
                           (scan_line_y < horizontal_pixel_412)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_208) and --S5
                           (scan_line_y >= horizontal_pixel_412) and 
                           (scan_line_x < vertical_pixel_216) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_184) and --S6
                           (scan_line_y >= horizontal_pixel_420) and 
                           (scan_line_x < vertical_pixel_216) and 
                           (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_184) and --S7
                           (scan_line_y >= horizontal_pixel_416) and 
                           (scan_line_x < vertical_pixel_192) and 
                           (scan_line_y < horizontal_pixel_420)) then
                            pixel_color <= poly_color;
                     --E--
                     elsif ((scan_line_x >= vertical_pixel_224) and --S1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_256) and 
                           (scan_line_y < horizontal_pixel_396)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_224) and --S2
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_232) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_224) and --S3
                           (scan_line_y >= horizontal_pixel_404) and 
                           (scan_line_x < vertical_pixel_256) and 
                           (scan_line_y < horizontal_pixel_412)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_224) and --S4
                           (scan_line_y >= horizontal_pixel_420) and 
                           (scan_line_x < vertical_pixel_256) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                     --R--
                     elsif ((scan_line_x >= vertical_pixel_264) and --R1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_272) and 
                           (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_264) and --R2
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_296) and 
                           (scan_line_y < horizontal_pixel_396)) then
                            pixel_color <= poly_color;
                    elsif ((scan_line_x >= vertical_pixel_288) and --R3
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_296) and 
                           (scan_line_y < horizontal_pixel_412)) then
                           pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_276) and --R4
                           (scan_line_y >= horizontal_pixel_404) and 
                           (scan_line_x < vertical_pixel_296) and 
                           (scan_line_y < horizontal_pixel_412)) then
                            pixel_color <= poly_color;
                     elsif ((scan_line_x >= vertical_pixel_276) and --R5
                            (scan_line_y >= horizontal_pixel_404) and 
                            (scan_line_x < vertical_pixel_284) and 
                            (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_276) and --R6
                            (scan_line_y >= horizontal_pixel_420) and 
                            (scan_line_x < vertical_pixel_296) and 
                            (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                    --T--
                    elsif ((scan_line_x >= vertical_pixel_304) and --T1
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_336) and 
                          (scan_line_y < horizontal_pixel_396)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_316) and --T2
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_324) and 
                          (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;                       
                    --COIN--
                    --C--
                    elsif ((scan_line_x >= vertical_pixel_384) and --S1
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_392) and 
                          (scan_line_y < horizontal_pixel_428)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_384) and --S2
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_416) and 
                          (scan_line_y < horizontal_pixel_396)) then
                           pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_408) and --S3
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_416) and 
                          (scan_line_y < horizontal_pixel_404)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_384) and --S4
                          (scan_line_y >= horizontal_pixel_420) and 
                          (scan_line_x < vertical_pixel_416) and 
                          (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_408) and --S5
                          (scan_line_y >= horizontal_pixel_412) and 
                          (scan_line_x < vertical_pixel_416) and 
                          (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;
                    --O--
                    elsif ((scan_line_x >= vertical_pixel_424) and --S1
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_432) and 
                          (scan_line_y < horizontal_pixel_428)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_424) and --S2
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_456) and 
                          (scan_line_y < horizontal_pixel_396)) then
                           pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_448) and --S3
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_456) and 
                          (scan_line_y < horizontal_pixel_428)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_424) and --S4
                          (scan_line_y >= horizontal_pixel_420) and 
                          (scan_line_x < vertical_pixel_456) and 
                          (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;
                    --I--
                    elsif ((scan_line_x >= vertical_pixel_464) and --S1
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_496) and 
                          (scan_line_y < horizontal_pixel_396)) then
                          pixel_color <= poly_color;   
                    elsif ((scan_line_x >= vertical_pixel_464) and --S2
                          (scan_line_y >= horizontal_pixel_420) and 
                          (scan_line_x < vertical_pixel_496) and 
                          (scan_line_y < horizontal_pixel_428)) then
                           pixel_color <= poly_color;
                   elsif ((scan_line_x >= vertical_pixel_476) and --S3
                          (scan_line_y >= horizontal_pixel_388) and 
                          (scan_line_x < vertical_pixel_484) and 
                          (scan_line_y < horizontal_pixel_428)) then
                          pixel_color <= poly_color;
                          --N--
                     elsif ((scan_line_x >= vertical_pixel_504) and --S1
                           (scan_line_y >= horizontal_pixel_388) and 
                           (scan_line_x < vertical_pixel_512) and 
                           (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_504) and --S2
                            (scan_line_y >= horizontal_pixel_388) and 
                            (scan_line_x < vertical_pixel_524) and 
                            (scan_line_y < horizontal_pixel_396)) then
                             pixel_color <= poly_color;
                     elsif ((scan_line_x >= vertical_pixel_516) and --S3
                            (scan_line_y >= horizontal_pixel_388) and 
                            (scan_line_x < vertical_pixel_524) and 
                            (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_516) and --S4
                            (scan_line_y >= horizontal_pixel_420) and 
                            (scan_line_x < vertical_pixel_536) and 
                            (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;
                     elsif ((scan_line_x >= vertical_pixel_528) and --S5
                            (scan_line_y >= horizontal_pixel_388) and 
                            (scan_line_x < vertical_pixel_536) and 
                            (scan_line_y < horizontal_pixel_428)) then
                            pixel_color <= poly_color;                              
                   --Right Brace [--
                    elsif ((scan_line_x >= vertical_pixel_80) and --S1
                           (scan_line_y >= horizontal_pixel_384) and 
                           (scan_line_x < vertical_pixel_100) and 
                           (scan_line_y < horizontal_pixel_392)) then
                            pixel_color <= poly_color;   
                     elsif ((scan_line_x >= vertical_pixel_80) and --S2
                           (scan_line_y >= horizontal_pixel_384) and 
                           (scan_line_x < vertical_pixel_88) and 
                           (scan_line_y < horizontal_pixel_432)) then
                            pixel_color <= poly_color;
                     elsif ((scan_line_x >= vertical_pixel_80) and --S3
                           (scan_line_y >= horizontal_pixel_424) and 
                            (scan_line_x < vertical_pixel_100) and 
                            (scan_line_y < horizontal_pixel_432)) then
                            pixel_color <= poly_color;
                     --Left Brace ]--
                    elsif ((scan_line_x >= vertical_pixel_540) and --S1
                            (scan_line_y >= horizontal_pixel_384) and 
                            (scan_line_x < vertical_pixel_560) and 
                            (scan_line_y < horizontal_pixel_392)) then
                             pixel_color <= poly_color;   
                      elsif ((scan_line_x >= vertical_pixel_552) and --S2
                            (scan_line_y >= horizontal_pixel_384) and 
                            (scan_line_x < vertical_pixel_560) and 
                            (scan_line_y < horizontal_pixel_432)) then
                             pixel_color <= poly_color;
                      elsif ((scan_line_x >= vertical_pixel_540) and --S3
                            (scan_line_y >= horizontal_pixel_424) and 
                             (scan_line_x < vertical_pixel_560) and 
                             (scan_line_y < horizontal_pixel_432)) then
                             pixel_color <= poly_color;
                     else
                                 pixel_color <= poly_red; 
                        end if;
            else
                   --// if(oneHz_i = '1') then
                       pixel_color <= poly_red;
                   -- else 
                    --   pixel_color <= poly_white;
                    --end if;
        end if;
   
end process;

red <= pixel_color(11 downto 8);
green <= pixel_color(7 downto 4);
blue <= pixel_color(3 downto 0);

end Behavioral;
