library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_5bit is
    Port (
        t1, t0 : in STD_LOGIC;
        in0, in1, in2 : in STD_LOGIC_VECTOR(4 downto 0);
        output : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Mux_5bit;

architecture Behavioral of Mux_5bit is
signal sel : STD_LOGIC_VECTOR(1 downto 0);
begin
	sel <= t1 & t0;
    process(in0, in1, in2, sel)
	begin
    	case sel is
        	when "00" =>
            	output <= "00010";
            when "01" =>
            	output <= "01010";
			when "10" =>
            	output <= "11100";
            when others => output <= (others => '0');  -- Valor padrão seguro
       end case;
   end process;
    
end Behavioral;