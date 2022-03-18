--READ DATA CHANNEL (El master recibe del periferico el dato contenido en el registro previamente direccionado)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_READ_DATA_CONTROL_CHANNEL_model is
    generic (
        DATA_SIZE    :   integer := 32;
        ADDR_SIZE     :   integer :=  4
    );
	port (
		-- In signals
		clk			:	in std_logic;						        --Desde entidad superior
		resetn		:	in std_logic;						        --"
		AxRDATA 	:	in std_logic_vector(DATA_SIZE-1 downto 0);  --Desde periferico AXI Lite
		AxRVALID	:	in std_logic;						        --"
		AxRRESP		:	in std_logic_vector(1 downto 0);	        --"
		-- Out signals
		dato 		:	out std_logic_vector(DATA_SIZE-1 downto 0); --Hacia entidad superior
		done		:	out std_logic;						        --"
		resp		:	out std_logic_vector(1 downto 0);	        --"
		AxRREADY	:	out std_logic						        --Hacia periferico AXI Lite
	);
end AXI_READ_DATA_CONTROL_CHANNEL_model;

architecture Behavioral of AXI_READ_DATA_CONTROL_CHANNEL_model is
	
	type main_fsm_type is (reset, idle, running, complete);
	signal current_state, next_state : main_fsm_type := reset;
	signal dato_enable, resp_enable : std_logic;

	begin
		--Latcheo del dato leido
		--dato <= AxRDATA when dato_enable = '1' else (others => '0');
		--resp <= AxRRESP when resp_enable = '1' else (others => '0');
        dato <= AxRDATA when dato_enable = '1';
        resp <= AxRRESP when resp_enable = '1';        
        
 		--Maquina de estados (Next State Function)
stage_1:process (current_state, AxRVALID)
		begin
			case current_state is
				when reset =>
					next_state <= idle;
				when idle =>
					next_state <= idle;
					if (AxRVALID = '1') then
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
			dato_enable <= '0';
			resp_enable <= '0';
			AxRREADY <= '0';
			case current_state is
				when reset => NULL;
				when idle => 
					AxRREADY <= '1';
				when running =>
					AxRREADY <= '1';
					dato_enable <= '1';
					resp_enable <= '1';
				when complete =>
					done <= '1';
			end case;
		end process;				
end Behavioral;

