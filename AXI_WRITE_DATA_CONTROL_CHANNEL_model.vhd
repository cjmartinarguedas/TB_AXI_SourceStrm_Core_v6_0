--WRITE DATA CHANNEL (El master pone en el bus el dato a escribir sobre periferico, y espera a que el periferico la capture)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_WRITE_DATA_CONTROL_CHANNEL_model is
    generic (
        DATA_SIZE    :   integer := 32;
        ADDR_SIZE    :   integer :=  4
    );
	port (
		-- In signals
		clk			:	in std_logic;						        --Desde entidad superior
		resetn		:	in std_logic;						        --"
		go			:	in std_logic;						        --"
		dato	 	:	in std_logic_vector(DATA_SIZE-1 downto 0);	--"
		AxWREADY	:	in std_logic;						        --Desde periferico AXI Lite
		-- Out signals
		done		:	out std_logic;						        --Hacia entidad superior
		AxWDATA		:	out std_logic_vector(DATA_SIZE-1 downto 0);	--Hacia periferico AXI Lite
		AxWSTRB		:	out std_logic_vector((DATA_SIZE/8)-1 downto 0);	--"
		AxWVALID	:	out std_logic						            --"
	);
end AXI_WRITE_DATA_CONTROL_CHANNEL_model;

architecture Behavioral of AXI_WRITE_DATA_CONTROL_CHANNEL_model is
	
	type main_fsm_type is (reset, idle, running, complete);
	signal current_state, next_state : main_fsm_type := reset;
	signal dato_enable, strb_enable : std_logic;

	begin
		--Activacion del bus de direcciones
		AxWDATA <= dato when dato_enable = '1' else (others => '0');
		AxWSTRB <= "1111" when strb_enable = '1' else (others => '0');	--Asumimos que todos los bytes son validos
		
		--Maquina de estados (Next State Function)
stage_1:process (current_state, go, AxWREADY)
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
					if (AxWREADY = '1') then
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
			dato_enable <= '0';
			strb_enable <= '0';
			AxWVALID <= '0';
			case current_state is
				when reset => NULL;
				when idle => NULL;
				when running =>
					dato_enable <= '1';
					strb_enable <= '1';
					AxWVALID <= '1';
				when complete =>
					done <= '1';
			end case;
		end process;				
end Behavioral;

