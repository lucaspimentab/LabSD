-- Divisor de clock com entrada de 50MHz e saída de 1Hz
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DivisorClock is
port ( clk50MHz : in std_logic;
       reset : in std_logic;
       clk1Hz : out std_logic
     );
end DivisorClock;

architecture Behavioral of DivisorClock is

--signal count : integer := 0;
signal b : std_logic := '0';
begin

-- Geração do Clock. Para um clock de 50MHz esse process gera um sinal de clock de 1Hz.
process(clk50MHz, b)
	variable cnt : integer range 0 to 2**26-1;
	begin
		if(rising_edge(clk50MHz)) then
		   if(reset = '1') then
			   cnt := 0;
			else
			   cnt := cnt + 1;
         end if;
			if(cnt = 24999999) then
				b <= not b;
				cnt := 0;
			end if;
		end if;
		clk1Hz <= b;
	end process;
end;