library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparador_5bits_tb is
end comparador_5bits_tb;

architecture Behavioral of comparador_5bits_tb is
    component comparador_5bits
        Port (
            A, B : in STD_LOGIC_VECTOR(4 downto 0);
            A_maior_B, A_igual_B : out STD_LOGIC
        );
    end component;

    signal A, B : STD_LOGIC_VECTOR(4 downto 0);
    signal A_maior_B, A_igual_B : STD_LOGIC;
    constant clock_period : time := 10 ns;

begin
    uut: comparador_5bits port map (
        A => A,
        B => B,
        A_maior_B => A_maior_B,
        A_igual_B => A_igual_B
    );

    stim_proc: process
    begin
        -- Test case 1: A > B
        A <= "01010"; -- 10
        B <= "00101"; -- 5
        wait for clock_period;
        assert A_maior_B = '1' and A_igual_B = '0' 
            report "Test case 1 failed" severity error;
        
        -- Test case 2: A = B
        A <= "01100"; -- 12
        B <= "01100"; -- 12
        wait for clock_period;
        assert A_maior_B = '0' and A_igual_B = '1' 
            report "Test case 2 failed" severity error;
        
        -- Test case 3: A < B
        A <= "00011"; -- 3
        B <= "00111"; -- 7
        wait for clock_period;
        assert A_maior_B = '0' and A_igual_B = '0' 
            report "Test case 3 failed" severity error;
        
        -- Test case 4: Edge case (max values)
        A <= "11111"; -- 31
        B <= "00000"; -- 0
        wait for clock_period;
        assert A_maior_B = '1' and A_igual_B = '0' 
            report "Test case 4 failed" severity error;
        
        -- Test case 5: Edge case (min values)
        A <= "00000"; -- 0
        B <= "00000"; -- 0
        wait for clock_period;
        assert A_maior_B = '0' and A_igual_B = '1' 
            report "Test case 5 failed" severity error;
        
        report "All test cases completed";
        wait;
    end process;
end Behavioral;
