library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_5bit_tb is
end Mux_5bit_tb;

architecture Behavioral of Mux_5bit_tb is
    component Mux_5bit
        Port (
            t1, t0 : in STD_LOGIC;
            in0, in1, in2 : in STD_LOGIC_VECTOR(4 downto 0);
            output : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    signal t1, t0 : STD_LOGIC;
    signal in0, in1, in2, output : STD_LOGIC_VECTOR(4 downto 0);
    constant clock_period : time := 10 ns;

begin
    uut: Mux_5bit port map (
        t1 => t1,
        t0 => t0,
        in0 => in0,
        in1 => in1,
        in2 => in2,
        output => output
    );

    stim_proc: process
    begin
        -- Initialize inputs
        in0 <= "00001"; -- 1
        in1 <= "00010"; -- 2
        in2 <= "00100"; -- 4
        
        -- Test case 1: Select in0 (00)
        t1 <= '0'; t0 <= '0';
        wait for clock_period;
        assert output = "00001" 
            report "Test case 1 failed" severity error;
        
        -- Test case 2: Select in1 (01)
        t1 <= '0'; t0 <= '1';
        wait for clock_period;
        assert output = "00010" 
            report "Test case 2 failed" severity error;
        
        -- Test case 3: Select in2 (10)
        t1 <= '1'; t0 <= '0';
        wait for clock_period;
        assert output = "00100" 
            report "Test case 3 failed" severity error;
        
        -- Test case 4: Undefined selection (11) - should output 0
        t1 <= '1'; t0 <= '1';
        wait for clock_period;
        assert output = "00000" 
            report "Test case 4 failed" severity error;
        
        -- Test case 5: Change inputs and verify
        in0 <= "01010"; -- 10
        in1 <= "10100"; -- 20
        in2 <= "11111"; -- 31
        t1 <= '0'; t0 <= '1';
        wait for clock_period;
        assert output = "10100" 
            report "Test case 5 failed" severity error;
        
        report "All test cases completed";
        wait;
    end process;
end Behavioral;
