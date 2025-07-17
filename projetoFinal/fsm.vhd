library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        ns_ped      : in STD_LOGIC;
        ew_ped      : in STD_LOGIC;
        ns_sensor : in STD_LOGIC;
        ew_sensor : in STD_LOGIC;
        emr_btn   : in  STD_LOGIC;
        tempoIgual   : in  STD_LOGIC;  
        tempoMaior   : in  STD_LOGIC;  
        
        t1, t0      : out STD_LOGIC;
        load        : out STD_LOGIC;
		  start        : out STD_LOGIC;
		  reset_out    : out STD_LOGIC;
        
        ew_red      : out STD_LOGIC;
        ew_yellow   : out STD_LOGIC;
        ew_green    : out STD_LOGIC;
        ns_red      : out STD_LOGIC;
        ns_yellow   : out STD_LOGIC;
        ns_green    : out STD_LOGIC
    );
end fsm;

architecture Behavioral of fsm is
    type StateType is (
        EWR_NSG,   -- Leste-Oeste Vermelho, Norte-Sul Verde
        EWR_NSY,   -- Leste-Oeste Vermelho, Norte-Sul Amarelo
        EWG_NSR,   -- Leste-Oeste Verde, Norte-Sul Vermelho
        EWY_NSR,   -- Leste-Oeste Amarelo, Norte-Sul Vermelho
        EMERGENCY  -- Estado de emergência
    );
    
    signal current_state, next_state : StateType := EWR_NSG;
	 signal timer_reset : STD_LOGIC := '0';
    
begin
    -- Processo para sincronização e reset
    sync_process: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= EWY_NSR;
			
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process sync_process;
    
    -- Processo de transição de estados (baseado nos comparadores)
    state_transition: process(current_state, timer_reset, emr_btn, tempoMaior, tempoIgual)
    begin
        case current_state is
            when EWR_NSG =>
                if emr_btn = '1' then
                    next_state <= EMERGENCY;
                elsif tempoMaior = '1' or tempoIgual = '1' then
							timer_reset <= '1';
                    next_state <= EWR_NSY;
                else
							timer_reset <= '0';
                    next_state <= EWR_NSG;
                end if;
                
            when EWR_NSY =>
                if emr_btn = '1' then
                    next_state <= EMERGENCY;
                elsif tempoMaior = '1' or tempoIgual = '1' then
							timer_reset <= '1';
                    next_state <= EWG_NSR;
                else
							timer_reset <= '0';
                    next_state <= EWR_NSY;
                end if;
                
            when EWG_NSR =>
                if emr_btn = '1' then
                    next_state <= EMERGENCY;
                elsif tempoMaior = '1' or tempoIgual = '1' then
							timer_reset <= '1';
                    next_state <= EWY_NSR;
                else
							timer_reset <= '0';
                    next_state <= EWG_NSR;
                end if;
                
            when EWY_NSR =>
                if emr_btn = '1' then
                    next_state <= EMERGENCY;
                elsif tempoIgual = '1' or tempoMaior = '1' then
							timer_reset <= '1';
                    next_state <= EWR_NSG;  -- Completa o ciclo
                else
							timer_reset <= '0';
                    next_state <= EWY_NSR;
                end if;
                
            when EMERGENCY =>
                if emr_btn = '0' then
                    next_state <= EWR_NSG;  -- Retorna ao estado inicial
                else
                    next_state <= EMERGENCY;
                end if;
        end case;
    end process state_transition;
    
    -- Processo de saída simplificado
    output_process: process(current_state, timer_reset, ns_sensor,ew_sensor,ew_ped,ns_ped) -- depender do bot do pedestre tbm
    begin
        -- Valores padrão (todos desligados)
        ew_red <= '0';
        ew_yellow <= '0';
        ew_green <= '0';
        ns_red <= '0';
        ns_yellow <= '0';
        ns_green <= '0';
        
        case current_state is
            when EWR_NSG =>
					
                ew_red <= '1';
                ns_green <= '1';
                
					if (ns_sensor = '0' and ew_ped = '0') then
                	t1 <= '0';
                  t0 <= '1';
                else
                	t1 <= '1';
                  t0 <= '0';
                end if;
                
            
               load <='1';
					start <= '1';
              
					ew_yellow <= '0';
					ew_green <= '0';
					ns_red <= '0';
					ns_yellow <= '0';
					reset_out <= timer_reset;
                
                
            when EWR_NSY =>
                ew_red <= '1';
                ns_yellow <= '1';
                t0 <= '0';
                t1 <= '0';
                load <='1'; --implementar load nas mudanças de tempo do mux

					 start <= '1';
					 
					 ew_yellow <= '0';
                ew_green <= '0';
                ns_red <= '0';
                ns_green <= '0';
					 reset_out <= timer_reset;
                
            when EWG_NSR =>
                ew_green <= '1';
                ns_red <= '1';
                
                if (ew_sensor = '0' and ns_ped = '0') then
                	t1 <= '0';
                  t0 <= '1';
                else
                	t1 <= '1';
                  t0 <= '0';
                end if;
                load <='1';
					 start <= '1';
                
              ew_red <= '0';
              ew_yellow <= '0';
              ns_yellow <= '0';
              ns_green <= '0';
				  reset_out <= timer_reset;
                
            when EWY_NSR =>
                ew_yellow <= '1';--inferencia de registrador!! o valor deve ser reescrito manualmente
                ns_red <= '1';
                t0 <= '0';
                t1 <= '0';
                
                ew_red <= '0';
                ew_green <= '0';
                ns_yellow <= '0';
                ns_green <= '0';
                load <='1';
					 start <= '1';
					 reset_out <= timer_reset;
                
            when EMERGENCY =>
                ew_red <= '1';
                ns_red <= '1';
                ew_yellow  <='0';
                ew_green <= '0';
                ns_yellow <= '0';
                ns_green <= '0';
                load <='0';
					 
        end case;
    end process output_process;
    
end Behavioral;