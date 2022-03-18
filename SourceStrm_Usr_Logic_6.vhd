--SourceStrm_Usr_Logic_4: Entidad que implementa 16 contadores, a modo de generadores de flujo, para el testeo de interfaces AXI Stream Slaves.
--Por defecto la cuenta empieza en 0, aunque se puede elegir un valor por medio de la senal INIT_CNT. La longitud del frame se selecciona
--por medio de un generico (FRAME_LENGTH), y cuando el contador ha avanzado tantas veces como marca ese valor entonces el core activa la
--senal de LAST. Una vez terminada la cuenta el contador se detiene y el core queda a la espera de recibir una nueva orden de activacion
--por medio de la senal START. La senal VALID indica que el contador esta activo, y que los datos de salida pueden ser tenidos en
--consideracion por la logic conectada a continuacion.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SourceStrm_Usr_Logic_5 is
	generic(
		CNT_WIDTH    : integer := 14;   -- Numero de bits del contador (incluido el bit de signo, en caso de usar datos con signo) 
		FRAME_LENGTH : integer := 4096  -- Longitud del frame
	);
	port(
		-- Inputs
		clk      : in  std_logic;       -- Reloj del timer
		rstn     : in  std_logic;       -- Reset del perifico
		start    : in  std_logic;       -- Senal de arranque de cuenta
		init_cnt : in  std_logic_vector(CNT_WIDTH - 1 downto 0); -- Valor inicial de cuenta
		-- Outputs
		cnt      : out std_logic_vector(CNT_WIDTH - 1 downto 0); -- Salida del contador
		last     : out std_logic;       -- Senal de ultimo beat
		valid    : out std_logic        -- Senal de cuenta valida
	);
end entity SourceStrm_Usr_Logic_5;

architecture behavioral of SourceStrm_Usr_Logic_5 is

	-- Definicion de senales
	signal s_cnt   : integer;
	signal s_idx   : integer;
	signal s_last  : std_logic;
	signal s_valid : std_logic;

	type tipo_state is (idle, running_count, running_last);
	signal state : tipo_state;

begin

	-- In2Out
	cnt   <= std_logic_vector(to_signed(s_cnt, CNT_WIDTH));
	last  <= s_last;
	valid <= s_valid;

	-- s_cnt	
	timer : process(clk) is
	begin
		if rising_edge(clk) then
			if (rstn = '0') then
				s_cnt   <= 0;
				s_idx   <= 0;
				s_last  <= '0';
				s_valid <= '0';
				state   <= idle;
			else
				s_last  <= '0';
				s_valid <= '0';
				s_idx   <= 0;
				case state is
					when idle =>
						state <= idle;
						if (start = '1') then
							s_idx   <= 1;
							s_cnt   <= to_integer(signed(init_cnt));
							s_valid <= '1';
							state   <= running_count;
						end if;
					when running_count =>
						s_cnt   <= s_cnt + 1;
						s_idx   <= s_idx + 1;
						s_valid <= '1';
						state   <= running_count;
						if (s_idx = FRAME_LENGTH - 1) then
							s_last <= '1';
							state  <= running_last;
						end if;
					when running_last =>
						state <= idle;
				end case;
			end if;
		end if;
	end process timer;

end architecture behavioral;
