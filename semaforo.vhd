library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity semaforo is
    port (
        -- Entradas globais
        CLOCK, reset, start, Auto   : in  std_logic;
        A, B                        : in  std_logic;
        A_5bit, B_5bit              : in  std_logic_vector(4 downto 0);
        d_in                        : in  std_logic_vector(4 downto 0);
        in0, in1, in2               : in  std_logic_vector(4 downto 0);
        
        -- Entradas da FSM (sensores e botões)
        ns_ped, ew_ped              : in  std_logic;
        ns_sensor, ew_sensor        : in  std_logic;
        emr_btn                     : in  std_logic;
        
        -- Saídas da FSM (semáforos)
        ew_red, ew_yellow, ew_green : out std_logic;
        ns_red, ns_yellow, ns_green : out std_logic
    );
end entity;

architecture Main of semaforo is

    -- Componente da FSM
    component fsm is
        port (
            CLK         : in  std_logic;
            reset       : in  std_logic;
            ns_ped      : in  std_logic;
            ew_ped      : in  std_logic;
            ns_sensor   : in  std_logic;
            ew_sensor   : in  std_logic;
            emr_btn     : in  std_logic;
            tempoIgual  : in  std_logic;
            tempoMaior  : in  std_logic;
            
            -- Sinais de controle para o datapath
            t1, t0      : out std_logic;
            load        : out std_logic;
				start        : out std_logic;
				reset_out    : out std_logic;
            
            -- Saídas dos semáforos
            ew_red      : out std_logic;
            ew_yellow   : out std_logic;
            ew_green    : out std_logic;
            ns_red      : out std_logic;
            ns_yellow   : out std_logic;
            ns_green    : out std_logic
        );
    end component;

    -- Componente do Datapath
    component Datapath is
        port (
            CLOCK, reset, Auto  : in  std_logic;
            A, B               : in  std_logic;
            A_5bit, B_5bit     : in  std_logic_vector(4 downto 0);
            d_in               : in  std_logic_vector(4 downto 0);
            in0, in1, in2      : in  std_logic_vector(4 downto 0);
            
            -- Sinais de controle da FSM
            t1, t0             : in  std_logic;
            load               : in  std_logic;
            start              : in  std_logic;
            
            -- Saídas para a FSM
            A_maior_B          : out std_logic;
            A_igual_B          : out std_logic;
            
            timer_out          : out std_logic_vector(4 downto 0);
            q_out              : out std_logic_vector(4 downto 0);
            mux_out            : out std_logic_vector(4 downto 0)
        );
    end component;

    -- Componente do divisor de clock
    component DivisorClock is
        port (
            clk50MHz : in  std_logic;
            reset    : in  std_logic;
            clk1Hz   : out std_logic
        );
    end component;

    -- Sinais de interconexão
    signal fio_t1, fio_t0         : std_logic;
    signal fio_load, fio_start    : std_logic;
    signal fio_tempoIgual         : std_logic;
    signal fio_tempoMaior         : std_logic;
	 signal fio_reset         : std_logic;
	 signal fio_mux         : std_logic_vector(4 downto 0);
	 signal fio_timer         : std_logic_vector(4 downto 0);
	 signal fio_reg         : std_logic_vector(4 downto 0);
    signal clk_1Hz                : std_logic;

begin

    -- Instância do Divisor de Clock
    instancia_DivisorClock: DivisorClock
        port map (
            clk50MHz => CLOCK,
            reset    => reset,
            clk1Hz   => clk_1Hz
        );

    -- Instância do Datapath
    instancia_Datapath: Datapath
        port map (
            CLOCK      => clk_1Hz,
            reset      => fio_tempoMaior,
            Auto       => Auto,
				mux_out    => fio_mux, -- saida do mux
				timer_out  => fio_timer, -- saida do timer
				d_in       => fio_mux, -- entrada do registrador
				q_out      => fio_reg, -- saida do registrador
            A          => A,
            B          => B, 
            A_5bit     => fio_timer, -- entrada do comparador
            B_5bit     => fio_reg,  -- entrada do comparador
            
            in0        => in0,
            in1        => in1,
            in2        => in2,
            
            -- Controle da FSM
            t1         => fio_t1,
            t0         => fio_t0,
            load       => fio_load,
            start      => fio_start,
            
            -- Feedback para a FSM
            A_igual_B  => fio_tempoIgual,
            A_maior_B  => fio_tempoMaior
            
        );

    -- Instância da FSM (Controladora)
    instancia_Controladora: fsm
        port map (
            CLK        => clk_1Hz,
            reset      => reset,
            ns_ped     => ns_ped,
            ew_ped     => ew_ped,
            ns_sensor  => ns_sensor,
            ew_sensor  => ew_sensor,
            emr_btn    => emr_btn,
            tempoIgual => fio_tempoIgual,
            tempoMaior => fio_tempoMaior,
            
            -- Controle do Datapath
            t1         => fio_t1,
            t0         => fio_t0,
            load       => fio_load,
            
            -- Saídas dos semáforos
            ew_red     => ew_red,
            ew_yellow  => ew_yellow,
            ew_green   => ew_green,
            ns_red     => ns_red,
            ns_yellow  => ns_yellow,
            ns_green   => ns_green,
				start      => fio_start,
				reset_out  => fio_reset
        );

end Main;
