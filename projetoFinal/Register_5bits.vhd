library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_5bits is
    Port (
        clk, reset, load : in STD_LOGIC;
        d_in  : in  STD_LOGIC_VECTOR(4 downto 0);
        q_out : out STD_LOGIC_VECTOR(4 downto 0)
    );
end Register_5bits;

architecture Behavioral of Register_5bits is
    signal reg : STD_LOGIC_VECTOR(4 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                reg <= d_in;
            end if;
        end if;
    end process;
    q_out <= reg;
end Behavioral;