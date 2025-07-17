library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sistema_tb is
end sistema_tb;

architecture Behavioral of sistema_tb is
    -- Component declaration
    component Sistema is
        port (
            CLOCK, reset, start, Auto   : in  std_logic;
            A, B                        : in  std_logic;
            A_5bit, B_5bit              : in  std_logic_vector(4 downto 0);
            d_in                        : in  std_logic_vector(4 downto 0);
            in0, in1, in2               : in  std_logic_vector(4 downto 0);
            ns_ped, ew_ped              : in  std_logic;
            ns_sensor, ew_sensor        : in  std_logic;
            emr_btn                     : in  std_logic;
            ew_red, ew_yellow, ew_green : out std_logic;
            ns_red, ns_yellow, ns_green : out std_logic
        );
    end component;

    -- Input signals
    signal CLOCK      : std_logic := '0';
    signal reset      : std_logic := '0';
    signal start      : std_logic := '0';
    signal Auto       : std_logic := '0';
    signal A, B       : std_logic := '0';
    signal A_5bit     : std_logic_vector(4 downto 0) := (others => '0');
    signal B_5bit     : std_logic_vector(4 downto 0) := (others => '0');
    signal d_in       : std_logic_vector(4 downto 0) := (others => '0');
    signal in0        : std_logic_vector(4 downto 0) := "00100"; -- 4
    signal in1        : std_logic_vector(4 downto 0) := "00010"; -- 2
    signal in2        : std_logic_vector(4 downto 0) := "00001"; -- 1
    signal ns_ped     : std_logic := '0';
    signal ew_ped     : std_logic := '0';
    signal ns_sensor  : std_logic := '0';
    signal ew_sensor  : std_logic := '0';
    signal emr_btn    : std_logic := '0';

    -- Output signals
    signal ew_red, ew_yellow, ew_green : std_logic;
    signal ns_red, ns_yellow, ns_green : std_logic;

    -- Clock period definition
    constant CLOCK_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: Sistema port map (
        CLOCK => CLOCK,
        reset => reset,
        start => start,
        Auto => Auto,
        A => A,
        B => B,
        A_5bit => A_5bit,
        B_5bit => B_5bit,
        d_in => d_in,
        in0 => in0,
        in1 => in1,
        in2 => in2,
        ns_ped => ns_ped,
        ew_ped => ew_ped,
        ns_sensor => ns_sensor,
        ew_sensor => ew_sensor,
        emr_btn => emr_btn,
        ew_red => ew_red,
        ew_yellow => ew_yellow,
        ew_green => ew_green,
        ns_red => ns_red,
        ns_yellow => ns_yellow,
        ns_green => ns_green
    );

    -- Clock process definitions
    CLOCK_process : process
    begin
        CLOCK <= '0';
        wait for CLOCK_period/2;
        CLOCK <= '1';
        wait for CLOCK_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        reset <= '1';
        wait for CLOCK_period*2;
        reset <= '0';
        start <= '1';
        Auto <= '1';
        
        -- Test normal operation cycle
        report "Starting normal operation test";
        wait for CLOCK_period*10;
        
        -- Activate North-South sensor
        ns_sensor <= '1';
        wait for CLOCK_period*20;
        ns_sensor <= '0';
        
        -- Activate East-West pedestrian button
        ew_ped <= '1';
        wait for CLOCK_period*10;
        ew_ped <= '0';
        
        -- Test emergency button
        report "Testing emergency mode";
        emr_btn <= '1';
        wait for CLOCK_period*10;
        emr_btn <= '0';
        
        -- Continue normal operation
        wait for CLOCK_period*30;
        
        -- Test with different timer values
        report "Testing with different timer values";
        in0 <= "01010"; -- 10
        in1 <= "00101"; -- 5
        in2 <= "00011"; -- 3
        wait for CLOCK_period*50;
        
        -- End simulation
        report "Test completed";
        wait;
    end process;

    -- Monitor process to display state changes
    monitor_proc: process
    begin
        wait until rising_edge(CLOCK);
        report "EW Lights: R=" & std_logic'image(ew_red) & 
               " Y=" & std_logic'image(ew_yellow) & 
               " G=" & std_logic'image(ew_green) &
               " | NS Lights: R=" & std_logic'image(ns_red) & 
               " Y=" & std_logic'image(ns_yellow) & 
               " G=" & std_logic'image(ns_green);
    end process;

end Behavioral;
