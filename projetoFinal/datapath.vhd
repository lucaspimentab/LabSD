library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    port(
        CLOCK, Auto                 : in  std_logic;
        A, B                        : in  std_logic;
        A_5bit, B_5bit             : in  std_logic_vector(4 downto 0);
        reset, start, load          : in  std_logic;
        d_in                       : in  std_logic_vector(4 downto 0);
        t1, t0                        : in  std_logic;
        in0, in1, in2                   : in  std_logic_vector(4 downto 0);
        
        A_maior_B, A_igual_B : out std_logic;
        timer_out                  : out std_logic_vector(4 downto 0);
        q_out                     : out std_logic_vector(4 downto 0);
        mux_out                   : out std_logic_vector(4 downto 0)
    );
end datapath;

architecture Main of datapath is

    component comparador_5bits is
        Port (
            A, B : in STD_LOGIC_VECTOR(4 downto 0);
            A_maior_B, A_igual_B : out STD_LOGIC
        );
    end component;

    component Timer is
        Port (
            clk, reset, start : in STD_LOGIC;
            timer_out : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    component Register_5bits is
        Port (
            clk, reset, load : in STD_LOGIC;
            d_in  : in  STD_LOGIC_VECTOR(4 downto 0);
            q_out : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    component Mux_5bit is
        Port (
            t1, t0 : in STD_LOGIC;
            in0, in1, in2 : in STD_LOGIC_VECTOR(4 downto 0);
            output   : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

begin

    u_comp: comparador_5bits
        port map (
            A => A_5bit,
            B => B_5bit,
            A_maior_B => A_maior_B,
            A_igual_B => A_igual_B
        );

    u_timer: Timer port map (
        clk => CLOCK,
        reset => reset,
        start => start,
        timer_out => timer_out
    );

    u_reg: Register_5bits 
        port map (
            clk => CLOCK,
            reset => reset,
            load => load,
            d_in => d_in,
            q_out => q_out
        );

    u_mux: Mux_5bit port map (
        t1 => t1,
        t0 => t0,
        in0 => in0,
        in1 => in1,
        in2 => in2,
        output => mux_out
    );
end Main;