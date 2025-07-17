library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity comparador_5bits is
    Port (
        A, B : in STD_LOGIC_VECTOR(4 downto 0);
        A_maior_B, A_igual_B : out STD_LOGIC
    );
end comparador_5bits;

architecture Behavioral of comparador_5bits is
begin
    process(A, B)
    begin
        if unsigned(A) > unsigned(B) then
            A_maior_B <= '1';
            A_igual_B <= '0';
        elsif unsigned(A) = unsigned(B) then
            A_maior_B <= '0';
            A_igual_B <= '1';
        else
            A_maior_B <= '0';
            A_igual_B <= '0';
        end if;
    end process;
end Behavioral;