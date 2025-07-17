library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_5bits_tb is
end Register_5bits_tb;

architecture Behavioral of Register_5bits_tb is
    component Register_5bits
        Port (
            clk, reset, load : in STD_LOGIC;
            d_in  : in  STD_LOGIC_VECTOR(4 downto 0);
            q_out : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    signal clk, reset, load : STD_LOGIC;
    signal d_in, q_out : STD_LOGIC_VECTOR(4 downto 0);
    constant clock_period : time := 10 ns;

begin
    uut: Register_5bits port map (
        clk => clk,
        reset => reset,
        load => load,
        d_in => d_in,
        q_out => q_out
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
        load <= '0';
        d_in <= "00000";
        wait for clock_period;
        
        -- Test case 1: Reset functionality
        assert q_out = "00000" 
            report "Test case 1 (reset) failed" severity error;
        
        -- Test case 2: Load data
        reset <= '0';
        load <= '1';
        d_in <= "01010"; -- 10
        wait for clock_period;
        assert q_out = "01010" 
            report "Test case 2 (load) failed" severity error;
        
        -- Test case 3: No load - output should remain
        load <= '0';
        d_in <= "11111"; -- 31
        wait for clock_period;
        assert q_out = "01010" 
            report "Test case 3 (no load) failed" severity error;
        
        -- Test case 4: Load new data
        load <= '1';
        wait for clock_period;
        assert q_out = "11111" 
            report "Test case 4 (new load) failed" severity error;
        
        -- Test case 5: Reset again
        reset <= '1';
        wait for clock_period;
        assert q_out = "00000" 
            report "Test case 5 (reset again) failed" severity error;
        
        report "All test cases completed";
        wait;
    end process;
end Behavioral;
