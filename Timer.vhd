library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer is
    Port (
        clk, reset, start : in STD_LOGIC;
        timer_out : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Timer;

architecture Behavioral of Timer is
    signal counter : unsigned(4 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
    		counter <= (others => '0');
        elsif rising_edge(clk) then
            if start = '1' then
                if counter = "11111" then  -- Exemplo de condição de parada
                    counter <= (others => '0');
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    timer_out <= std_logic_vector(counter);
end Behavioral;