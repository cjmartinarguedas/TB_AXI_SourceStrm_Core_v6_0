--WRITE RESPONSE CHANNEL (El master escucha la respuesta el periferico indicandole que la escritura se produjo correctamente)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model is
    generic (
        DATA_SIZE    :   integer := 32;
        ADDR_SIZE    :   integer :=  4
    );
	port (
		-- In signals
		clk			:	in std_logic;						--Desde entidad superior
		resetn		:	in std_logic;						--"
		AxBVALID	:	in std_logic;						--Desde el periferico AXI Lite
		AxBRESP		:	in std_logic_vector(1 downto 0);	--"
		-- Out signals
		resp 		:	out std_logic_vector(1 downto 0);	--Hacia entidad superior
		done		:	out std_logic;						--"
		AxBREADY	:	out std_logic						--Hacia periferico AXI Lite
	);
end AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model;

architecture Behavioral of AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model is
	
	type main_fsm_type is (reset, idle, running, complete);
	signal current_state, next_state : main_fsm_type := reset;
	signal resp_enable : std_logic;

	begin
		--Latcheo del canal BRESP
		resp <= AxBRESP when resp_enable = '1' else (others => '0');
		
		--Maquina de estados (Next State Function)
stage_1:process (current_state, AxBVALID)
		begin
			case current_state is
				when reset =>
					next_state <= idle;
				when idle =>
					next_state <= idle;
					if (AxBVALID = '1') then
						next_state <= running; 
					end if;
				when running =>
					next_state <= complete;
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
			resp_enable <= '0';
			AxBREADY <= '0';
			case current_state is
				when reset => NULL;
				when idle =>
					AxBREADY <= '1';	--OJO, en este canal se pone primero READY activo, y despues se espera la activacion de VALID para capturar la respuesta
				when running =>
					AxBREADY <= '1';
					resp_enable <= '1';
				when complete =>
					done <= '1';
			end case;
		end process;				
end Behavioral;

