library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM is
	generic(
		-- Parametros obligatorios
		M_DATA_WIDTH         : integer := 16; --Numero de bits para transmitir DATA (Puertas adentro)
		M_LAST_WIDTH         : integer := 1; --Numero de bits para transmitir LAST
		M_ID_WIDTH           : integer := 4; --Numero de bits para transmitir ID					
		M_FIFO_DEPTH         : integer := 8; --Tamanyo de la FIFO (=< 32)		

		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH : integer := 32 --(Puertas afuera)
	);
	port(
		-- User ports
		beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
		valid_beat     : in  std_logic; --Senal de validacion del beat puesto en beat_in
		fifo_full      : out std_logic; --Senal de aviso de llenado de la FIFO interna. Se puede usar como TREADY hacia la logica de usuario interna del periferico

		-- AXI ports
		M_AXIS_ACLK    : in  std_logic;
		-- 
		M_AXIS_ARESETN : in  std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID  : out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
		-- TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
		M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST   : out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY  : in  std_logic;
		M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
	);
end AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM;

architecture implementation of AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM is

	-- function called clogb2 that returns an integer which has the   
	-- value of the ceiling of the log base 2.                              
	function clogb2(bit_depth : integer) return integer is
		variable depth : integer := bit_depth;
		variable count : integer := 1;
	begin
		for clogb2 in 1 to bit_depth loop -- Works for up to 32 bit integers
			if (bit_depth <= 2) then
				count := 1;
			else
				if (depth <= 1) then
					count := count;
				else
					depth := depth / 2;
					count := count + 1;
				end if;
			end if;
		end loop;
		return (count);
	end;

	-- Definicion de constantes
	constant PTR_LENGTH : integer := clogb2(M_FIFO_DEPTH) - 1; -- Numero de bits necesarios para indexar la FIFO
	constant FIFO_WIDTH : integer := M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH;

	-- Definicion de senales
	type ram_type is array (M_FIFO_DEPTH - 1 downto 0) of std_logic_vector(FIFO_WIDTH - 1 downto 0);
	signal s_fifo            : ram_type := (others => (others => '0'));
	signal s_fifo_ptr        : signed(PTR_LENGTH downto 0); --:= to_signed(-1, PTR_LENGTH + 1);
	signal s_fifo_empty      : boolean;
	signal s_fifo_full       : boolean;
	signal s_fifo_in_enable  : boolean;
	signal s_fifo_out_enable : boolean;
	signal s_data_snd        : std_logic_vector(FIFO_WIDTH - 1 downto 0);

begin
	s_fifo_full  <= (s_fifo_ptr = M_FIFO_DEPTH - 1);
	s_fifo_empty <= (s_fifo_ptr = -1);

	fifo_full     <= '1' when (s_fifo_full) else '0';
	M_AXIS_TVALID <= '1' when (not s_fifo_empty) else '0';

	s_fifo_in_enable  <= (valid_beat = '1') and (not s_fifo_full);
	s_fifo_out_enable <= (M_AXIS_TREADY = '1') and (not s_fifo_empty);

	s_data_snd <= s_fifo(to_integer(unsigned(s_fifo_ptr(PTR_LENGTH - 1 downto 0))));

	M_AXIS_TDATA                            <= std_logic_vector(resize(signed(s_data_snd(M_DATA_WIDTH - 1 downto 0)), C_M_AXIS_TDATA_WIDTH));
	M_AXIS_TLAST                            <= s_data_snd(M_DATA_WIDTH);
	M_AXIS_TID                              <= s_data_snd(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto M_LAST_WIDTH + M_DATA_WIDTH);
	M_AXIS_TSTRB                            <= (others => '1');

	process(M_AXIS_ACLK) is
	begin
		if rising_edge(M_AXIS_ACLK) then
			if (M_AXIS_ARESETN = '0') then
				s_fifo     <= (others => (others => '0'));
				s_fifo_ptr <= to_signed(-1, PTR_LENGTH + 1);
			else
				if s_fifo_in_enable then
					s_fifo(M_FIFO_DEPTH - 1 downto 1) <= s_fifo(M_FIFO_DEPTH - 2 downto 0);
					s_fifo(0)                         <= beat_in;
					if not s_fifo_out_enable then
						s_fifo_ptr <= s_fifo_ptr + 1;
					end if;
				elsif s_fifo_out_enable then
					s_fifo_ptr <= s_fifo_ptr - 1;
				end if;
			end if;
		end if;
	end process;

end implementation;
