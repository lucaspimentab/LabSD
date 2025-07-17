library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer_tb is
end Timer_tb;

architecture Behavioral of Timer_tb is
    component Timer
        Port (
            clk, reset, start : in STD_LOGIC;
            timer_out : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    signal clk, reset, start : STD_LOGIC;
    signal timer_out : STD_LOGIC_VECTOR(4 downto 0);
    constant clock_period : time := 10 ns;

begin
    uut: Timer port map (
        clk => clk,
        reset => reset,
        start => start,
        timer_out => timer_out
    );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;

    stim_proc: process
    begin
        -- Initialize
        reset <= '1';
        start <= '0';
        wait for clock_period;
        
        -- Test case 1: Reset functionality
        assert unsigned(timer_out) = 0 
            report "Test case 1 (reset) failed" severity error;
        
        -- Test case 2: Start counting
        reset <= '0';
        start <= '1';
        wait for clock_period*5;
        assert unsigned(timer_out) = 5 
            report "Test case 2 (counting) failed" severity error;
        
        -- Test case 3: Stop counting
        start <= '0';
        wait for clock_period*3;
        assert unsigned(timer_out) = 5 
            report "Test case 3 (stopped) failed" severity error;
        
        -- Test case 4: Resume counting
        start <= '1';
        wait for clock_period*2;
        assert unsigned(timer_out) = 7 
            report "Test case 4 (resumed) failed" severity error;
        
        -- Test case 5: Reset while counting
        reset <= '1';
        wait for clock_period;
        assert unsigned(timer_out) = 0 
            report "Test case 5 (reset while counting) failed" severity error;
        
        -- Test case 6: Count to max value (31)
        reset <= '0';
        start <= '1';
        wait for clock_period*31;
        assert unsigned(timer_out) = 31 
            report "Test case 6 (max value) failed" severity error;
        
        -- Test case 7: Overflow (should wrap around)
        wait for clock_period;
        assert unsigned(timer_out) = 0 
            report "Test case 7 (overflow) failed" severity error;
        
        report "All test cases completed";
        wait;
    end process;
end Behavioral;
