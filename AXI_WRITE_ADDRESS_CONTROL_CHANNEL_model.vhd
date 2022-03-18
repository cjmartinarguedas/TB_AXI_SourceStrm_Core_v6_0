--WRITE ADDRESS CHANNEL (El master pone la direccion sobre la que se desea escribir en el bus, y espera a que el periferico la capture)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model is
    generic (
        DATA_SIZE    :   integer := 32;
        ADDR_SIZE     :   integer :=  4
    );
	port (
		-- In signals
		clk			:	in std_logic;						         --Desde entidad superior
		resetn		:	in std_logic;						         --"
		go			:	in std_logic;					 	         --"
		address 	:	in std_logic_vector(ADDR_SIZE-1 downto 0);   --"
		AxAWREADY	:	in std_logic;						         --Desde periferico AXI Lite
		-- Out signals
		done		:	out std_logic;						         --Hacia entidad superior
		AxAWADDR	:	out std_logic_vector (ADDR_SIZE-1 downto 0); --Hacia periferico AXI Lite
		AxAWVALID	:	out std_logic						         --"
	);
end AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model;

architecture Behavioral of AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model is
	
	type main_fsm_type is (reset, idle, running, complete);
	signal current_state, next_state : main_fsm_type := reset;
	signal address_enable : std_logic;

	begin
		--Activacion del bus de direcciones
		AxAWADDR <= address when address_enable = '1' else (others => '0');
		
		--Maquina de estados (Next State Function)
stage_1:process (current_state, go, AxAWREADY)
		begin
			case current_state is
				when reset =>
					next_state <= idle;
				when idle =>
					next_state <= idle;
					if (go = '1') then
						next_state <= running; 
					end if;
				when running =>
					next_state <= running;
					if (AxAWREADY = '1') then
						next_state <= complete;
					end if;
				when complete =>
					next_state <= idle;
			end case;
		end process;
				
		--Maquina de estados (State Register)
stage_2:process (clk)
		begin
			if (resetn = '0') then
				current_state <= reset;
			elsif rising_edge(clk) then
				current_state <= next_state;
			end if;
		end process;
		
		--Maquina de estados (Output Function)
stage_3:process (current_state)
		begin
			done <= '0';
			address_enable <= '0';
			AxAWVALID <= '0';
			case current_state is
				when reset => NULL;
				when idle => NULL;
				when running =>
					address_enable <= '1';
					AxAWVALID <= '1';
				when complete =>
					done <= '1';
			end case;
		end process;				
end Behavioral;

