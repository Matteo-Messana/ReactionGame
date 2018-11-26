library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity settableDowncounter_FSM is
  Generic ( period : integer:= 4;       
            WIDTH  : integer:= 3
		  );
    PORT ( clk    : in  STD_LOGIC;
           reset  : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           set_digit: in STD_LOGIC_VECTOR(3 downto 0);
           zero   : out STD_LOGIC
         );
end settableDowncounter_FSM;

architecture Behavioral of settableDowncounter_FSM is
  signal current_count : STD_LOGIC_VECTOR(WIDTH-1 downto 0);

  signal zero_i        : STD_LOGIC; 
  
  --constant max_count   : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := 
                         --STD_LOGIC_VECTOR(to_unsigned(period-1, WIDTH));
  constant zeros       : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
  
BEGIN
   
   count: process(clk,reset) begin
     if (rising_edge(clk)) then 
       if (reset = '1') then --this is going to need to be some soft reset from the FSM at the beginning of each game
          current_count <= set_digit; 
          zero_i        <= '0';
       elsif (enable = '1') then 
          if (current_count = zeros) then
            zero_i        <= '1';
          else 
            current_count <= current_count - '1'; -- continue counting down
            zero_i        <= '0';
          end if;
       else 
          zero_i <= '0';
       end if;
     end if;
   end process;
   
   zero  <= zero_i; 
   
END Behavioral;
