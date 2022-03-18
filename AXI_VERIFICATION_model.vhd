--NOTA: Programa que implementa un BFM contra el que chequear las transacciones AXI de cualquier
--periferico. Sigue el ejemplo mostrado en el documento "Designing a Custom AXI-Lite Slave Peripheral"
--de SILICA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_VERIFICATION_model is
	generic(
		DATA_SIZE                  : integer := 32; --Tamano del bus de datos y direcciones
		ADDR_SIZE                  : integer := 5; --Numero de registros implementados
		N_REGISTROS                : integer := 4;
		--TODO: Definicion de genericos
		CNT_WIDTH                  : integer := 14; -- Numero de bits del contador
		FRAME_LENGTH               : integer := 4096; -- Longitud del frame
		LAST_WIDTH                 : integer := 1; --Numero de bits de LAST
		ID_WIDTH                   : integer := 4; -- Numero de bits del ID 
		FIFO_DEPTH                 : integer := 8;
		-- Parameters of Axi Master Bus Interface M00_AXI_STREAM
		C_M_AXI_STREAM_TDATA_WIDTH : integer := 32
	);
	port(
		--In ports
		clk                    : in  std_logic; --Reloj
		resetn                 : in  std_logic; --Reset activo a nivel bajo
		go                     : in  std_logic; --Inicio de la operacion en cuestion (R/W)
		rnw                    : in  std_logic; --'1' READ, '0' WRITE
		address                : in  std_logic_vector(ADDR_SIZE - 1 downto 0); --Direccion del registro donde se desea leer o escribir.
		dato_w                 : in  std_logic_vector(DATA_SIZE - 1 downto 0); --Dato a escribir sobre el registro del periferico
		--Out ports
		busy                   : out std_logic; --Operacion R/W en curso
		done                   : out std_logic; --Operacion R/W terminada
		dato_r                 : out std_logic_vector(DATA_SIZE - 1 downto 0); --Dato leido del registro
		resp_r                 : out std_logic_vector(1 downto 0); --Respuesta en lectura del periferico
		resp_w                 : out std_logic_vector(1 downto 0); --Respuesta en escritura del periferico

		--TODO: Definicion de los puertos del periferico AXI que debe ser visibles desde la entidad superior
		--...
		--...
		--...
		-- Users to add ports here
		m00_axi_stream_aclk    : in  std_logic;
		m00_axi_stream_aresetn : in  std_logic;
		m00_axi_stream_tvalid  : out std_logic;
		m00_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m00_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m00_axi_stream_tlast   : out std_logic;
		m00_axi_stream_tready  : in  std_logic;
		m00_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m01_axi_stream_aclk    : in  std_logic;
		m01_axi_stream_aresetn : in  std_logic;
		m01_axi_stream_tvalid  : out std_logic;
		m01_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m01_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m01_axi_stream_tlast   : out std_logic;
		m01_axi_stream_tready  : in  std_logic;
		m01_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m02_axi_stream_aclk    : in  std_logic;
		m02_axi_stream_aresetn : in  std_logic;
		m02_axi_stream_tvalid  : out std_logic;
		m02_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m02_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m02_axi_stream_tlast   : out std_logic;
		m02_axi_stream_tready  : in  std_logic;
		m02_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m03_axi_stream_aclk    : in  std_logic;
		m03_axi_stream_aresetn : in  std_logic;
		m03_axi_stream_tvalid  : out std_logic;
		m03_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m03_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m03_axi_stream_tlast   : out std_logic;
		m03_axi_stream_tready  : in  std_logic;
		m03_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m04_axi_stream_aclk    : in  std_logic;
		m04_axi_stream_aresetn : in  std_logic;
		m04_axi_stream_tvalid  : out std_logic;
		m04_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m04_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m04_axi_stream_tlast   : out std_logic;
		m04_axi_stream_tready  : in  std_logic;
		m04_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m05_axi_stream_aclk    : in  std_logic;
		m05_axi_stream_aresetn : in  std_logic;
		m05_axi_stream_tvalid  : out std_logic;
		m05_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m05_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m05_axi_stream_tlast   : out std_logic;
		m05_axi_stream_tready  : in  std_logic;
		m05_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m06_axi_stream_aclk    : in  std_logic;
		m06_axi_stream_aresetn : in  std_logic;
		m06_axi_stream_tvalid  : out std_logic;
		m06_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m06_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m06_axi_stream_tlast   : out std_logic;
		m06_axi_stream_tready  : in  std_logic;
		m06_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m07_axi_stream_aclk    : in  std_logic;
		m07_axi_stream_aresetn : in  std_logic;
		m07_axi_stream_tvalid  : out std_logic;
		m07_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m07_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m07_axi_stream_tlast   : out std_logic;
		m07_axi_stream_tready  : in  std_logic;
		m07_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m08_axi_stream_aclk    : in  std_logic;
		m08_axi_stream_aresetn : in  std_logic;
		m08_axi_stream_tvalid  : out std_logic;
		m08_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m08_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m08_axi_stream_tlast   : out std_logic;
		m08_axi_stream_tready  : in  std_logic;
		m08_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m09_axi_stream_aclk    : in  std_logic;
		m09_axi_stream_aresetn : in  std_logic;
		m09_axi_stream_tvalid  : out std_logic;
		m09_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m09_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m09_axi_stream_tlast   : out std_logic;
		m09_axi_stream_tready  : in  std_logic;
		m09_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m10_axi_stream_aclk    : in  std_logic;
		m10_axi_stream_aresetn : in  std_logic;
		m10_axi_stream_tvalid  : out std_logic;
		m10_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m10_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m10_axi_stream_tlast   : out std_logic;
		m10_axi_stream_tready  : in  std_logic;
		m10_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m11_axi_stream_aclk    : in  std_logic;
		m11_axi_stream_aresetn : in  std_logic;
		m11_axi_stream_tvalid  : out std_logic;
		m11_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m11_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m11_axi_stream_tlast   : out std_logic;
		m11_axi_stream_tready  : in  std_logic;
		m11_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m12_axi_stream_aclk    : in  std_logic;
		m12_axi_stream_aresetn : in  std_logic;
		m12_axi_stream_tvalid  : out std_logic;
		m12_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m12_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m12_axi_stream_tlast   : out std_logic;
		m12_axi_stream_tready  : in  std_logic;
		m12_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m13_axi_stream_aclk    : in  std_logic;
		m13_axi_stream_aresetn : in  std_logic;
		m13_axi_stream_tvalid  : out std_logic;
		m13_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m13_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m13_axi_stream_tlast   : out std_logic;
		m13_axi_stream_tready  : in  std_logic;
		m13_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m14_axi_stream_aclk    : in  std_logic;
		m14_axi_stream_aresetn : in  std_logic;
		m14_axi_stream_tvalid  : out std_logic;
		m14_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m14_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m14_axi_stream_tlast   : out std_logic;
		m14_axi_stream_tready  : in  std_logic;
		m14_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		m15_axi_stream_aclk    : in  std_logic;
		m15_axi_stream_aresetn : in  std_logic;
		m15_axi_stream_tvalid  : out std_logic;
		m15_axi_stream_tdata   : out std_logic_vector(C_M_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m15_axi_stream_tstrb   : out std_logic_vector((C_M_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m15_axi_stream_tlast   : out std_logic;
		m15_axi_stream_tready  : in  std_logic;
		m15_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0)
		-- User ports ends
		-- Do not modify the ports beyond this line
	);
end AXI_VERIFICATION_model;

architecture Behavioral of AXI_VERIFICATION_model is

	--Declaracion de senales internas
	type main_fsm_type is (reset, idle, start_read, read_transaction, start_write, write_transaction, complete);
	signal current_state, next_state : main_fsm_type := reset;

	signal start_read_transaction, start_write_transaction, read_transaction_finished, write_transaction_finished : std_logic;
	signal done_READ_ADDRESS, done_READ_DATA, done_WRITE_ADDRESS, done_WRITE_DATA, done_WRITE_RESPONSE            : std_logic;

	signal s_AxARREADY : std_logic;
	signal s_AxARADDR  : std_logic_vector(ADDR_SIZE - 1 downto 0);
	signal s_AxARVALID : std_logic;
	signal s_AxRDATA   : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal s_AxRVALID  : std_logic;
	signal s_AxRRESP   : std_logic_vector(1 downto 0);
	signal s_AxRREADY  : std_logic;
	signal s_AxAWREADY : std_logic;
	signal s_AxAWADDR  : std_logic_vector(ADDR_SIZE - 1 downto 0);
	signal s_AxAWVALID : std_logic;
	signal s_AxWREADY  : std_logic;
	signal s_AxWDATA   : std_logic_vector(DATA_SIZE - 1 downto 0);
	signal s_AxWSTRB   : std_logic_vector((DATA_SIZE / 8) - 1 downto 0);
	signal s_AxWVALID  : std_logic;
	signal s_AxBVALID  : std_logic;
	signal s_AxBRESP   : std_logic_vector(1 downto 0);
	signal s_AxBREADY  : std_logic;

	--Declaracion de los canales
	--Canal para escribir la direccion del dato que se desea leer
	component AXI_READ_ADDRESS_CONTROL_CHANNEL_model is
		generic(
			DATA_SIZE : integer;
			ADDR_SIZE : integer
		);
		port(
			-- In signals
			clk       : in  std_logic;  --Desde entidad superior
			resetn    : in  std_logic;  --"
			go        : in  std_logic;  --"
			address   : in  std_logic_vector(ADDR_SIZE - 1 downto 0); --"
			AxARREADY : in  std_logic;  --Desde periferico AXI Lite
			-- Out signals
			done      : out std_logic;  --Hacia entidad superior
			AxARADDR  : out std_logic_vector(ADDR_SIZE - 1 downto 0); --Hacia periferico AXI Lite
			AxARVALID : out std_logic); --"
	end component AXI_READ_ADDRESS_CONTROL_CHANNEL_model;

	--Canal para recibir el dato leido
	component AXI_READ_DATA_CONTROL_CHANNEL_model is
		generic(
			DATA_SIZE : integer;
			ADDR_SIZE : integer
		);
		port(
			-- In signals
			clk      : in  std_logic;   --Desde entidad superior
			resetn   : in  std_logic;   --"
			AxRDATA  : in  std_logic_vector(DATA_SIZE - 1 downto 0); --Desde periferico AXI Lite
			AxRVALID : in  std_logic;   --"
			AxRRESP  : in  std_logic_vector(1 downto 0); --"
			-- Out signals
			dato     : out std_logic_vector(DATA_SIZE - 1 downto 0); --Hacia entidad superior
			done     : out std_logic;   --"
			resp     : out std_logic_vector(1 downto 0); --"
			AxRREADY : out std_logic);  --Hacia periferico AXI Lite
	end component AXI_READ_DATA_CONTROL_CHANNEL_model;

	--Canal para escribir la direccion del dato que se desea escribir
	component AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model is
		generic(
			DATA_SIZE : integer;
			ADDR_SIZE : integer
		);
		port(
			-- In signals
			clk       : in  std_logic;  --Desde entidad superior
			resetn    : in  std_logic;  --"
			go        : in  std_logic;  --"
			address   : in  std_logic_vector(ADDR_SIZE - 1 downto 0); --"
			AxAWREADY : in  std_logic;  --Desde periferico AXI Lite
			-- Out signals
			done      : out std_logic;  --Hacia entidad superior
			AxAWADDR  : out std_logic_vector(ADDR_SIZE - 1 downto 0); --Hacia periferico AXI Lite
			AxAWVALID : out std_logic); --"
	end component AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model;

	--Canal para escribir el dato
	component AXI_WRITE_DATA_CONTROL_CHANNEL_model is
		generic(
			DATA_SIZE : integer;
			ADDR_SIZE : integer
		);
		port(
			-- In signals
			clk      : in  std_logic;   --Desde entidad superior
			resetn   : in  std_logic;   --"
			go       : in  std_logic;   --"
			dato     : in  std_logic_vector(DATA_SIZE - 1 downto 0); --"
			AxWREADY : in  std_logic;   --Desde periferico AXI Lite
			-- Out signals
			done     : out std_logic;   --Hacia entidad superior
			AxWDATA  : out std_logic_vector(DATA_SIZE - 1 downto 0); --Hacia periferico AXI Lite
			AxWSTRB  : out std_logic_vector((DATA_SIZE / 8) - 1 downto 0); --"
			AxWVALID : out std_logic);  --"
	end component AXI_WRITE_DATA_CONTROL_CHANNEL_model;

	--Canal de confirmacion de que el dato se ha escrito correctamente
	component AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model is
		generic(
			DATA_SIZE : integer;
			ADDR_SIZE : integer
		);
		port(
			-- In signals
			clk      : in  std_logic;   --Desde entidad superior
			resetn   : in  std_logic;   --"
			AxBVALID : in  std_logic;   --Desde el periferico AXI Lite
			AxBRESP  : in  std_logic_vector(1 downto 0); --"
			-- Out signals
			resp     : out std_logic_vector(1 downto 0); --Hacia entidad superior
			done     : out std_logic;   --"
			AxBREADY : out std_logic);  --Hacia periferico AXI Lite
	end component AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model;

	--Declaracion del periferico a testear
	--TODO:
	--...
	--...
	--...
	--EJEMPLO:
	component AXI_SourceStrm_Core_v5_0
		generic(
			CNT_WIDTH                    : integer;
			FRAME_LENGTH                 : integer;
			LAST_WIDTH                   : integer;
			ID_WIDTH                     : integer;
			FIFO_DEPTH                   : integer;
			N_REGISTROS                  : integer;
			C_S00_AXI_LITE_DATA_WIDTH    : integer;
			C_S00_AXI_LITE_ADDR_WIDTH    : integer;
			C_M00_AXI_STREAM_TDATA_WIDTH : integer
		);
		port(
			s00_axi_lite_aclk      : in  std_logic;
			s00_axi_lite_aresetn   : in  std_logic;
			s00_axi_lite_awaddr    : in  std_logic_vector(C_S00_AXI_LITE_ADDR_WIDTH - 1 downto 0);
			s00_axi_lite_awprot    : in  std_logic_vector(2 downto 0);
			s00_axi_lite_awvalid   : in  std_logic;
			s00_axi_lite_awready   : out std_logic;
			s00_axi_lite_wdata     : in  std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
			s00_axi_lite_wstrb     : in  std_logic_vector((C_S00_AXI_LITE_DATA_WIDTH / 8) - 1 downto 0);
			s00_axi_lite_wvalid    : in  std_logic;
			s00_axi_lite_wready    : out std_logic;
			s00_axi_lite_bresp     : out std_logic_vector(1 downto 0);
			s00_axi_lite_bvalid    : out std_logic;
			s00_axi_lite_bready    : in  std_logic;
			s00_axi_lite_araddr    : in  std_logic_vector(C_S00_AXI_LITE_ADDR_WIDTH - 1 downto 0);
			s00_axi_lite_arprot    : in  std_logic_vector(2 downto 0);
			s00_axi_lite_arvalid   : in  std_logic;
			s00_axi_lite_arready   : out std_logic;
			s00_axi_lite_rdata     : out std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
			s00_axi_lite_rresp     : out std_logic_vector(1 downto 0);
			s00_axi_lite_rvalid    : out std_logic;
			s00_axi_lite_rready    : in  std_logic;
			m00_axi_stream_aclk    : in  std_logic;
			m00_axi_stream_aresetn : in  std_logic;
			m00_axi_stream_tvalid  : out std_logic;
			m00_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m00_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m00_axi_stream_tlast   : out std_logic;
			m00_axi_stream_tready  : in  std_logic;
			m00_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m01_axi_stream_aclk    : in  std_logic;
			m01_axi_stream_aresetn : in  std_logic;
			m01_axi_stream_tvalid  : out std_logic;
			m01_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m01_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m01_axi_stream_tlast   : out std_logic;
			m01_axi_stream_tready  : in  std_logic;
			m01_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m02_axi_stream_aclk    : in  std_logic;
			m02_axi_stream_aresetn : in  std_logic;
			m02_axi_stream_tvalid  : out std_logic;
			m02_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m02_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m02_axi_stream_tlast   : out std_logic;
			m02_axi_stream_tready  : in  std_logic;
			m02_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m03_axi_stream_aclk    : in  std_logic;
			m03_axi_stream_aresetn : in  std_logic;
			m03_axi_stream_tvalid  : out std_logic;
			m03_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m03_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m03_axi_stream_tlast   : out std_logic;
			m03_axi_stream_tready  : in  std_logic;
			m03_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m04_axi_stream_aclk    : in  std_logic;
			m04_axi_stream_aresetn : in  std_logic;
			m04_axi_stream_tvalid  : out std_logic;
			m04_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m04_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m04_axi_stream_tlast   : out std_logic;
			m04_axi_stream_tready  : in  std_logic;
			m04_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m05_axi_stream_aclk    : in  std_logic;
			m05_axi_stream_aresetn : in  std_logic;
			m05_axi_stream_tvalid  : out std_logic;
			m05_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m05_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m05_axi_stream_tlast   : out std_logic;
			m05_axi_stream_tready  : in  std_logic;
			m05_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m06_axi_stream_aclk    : in  std_logic;
			m06_axi_stream_aresetn : in  std_logic;
			m06_axi_stream_tvalid  : out std_logic;
			m06_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m06_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m06_axi_stream_tlast   : out std_logic;
			m06_axi_stream_tready  : in  std_logic;
			m06_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m07_axi_stream_aclk    : in  std_logic;
			m07_axi_stream_aresetn : in  std_logic;
			m07_axi_stream_tvalid  : out std_logic;
			m07_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m07_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m07_axi_stream_tlast   : out std_logic;
			m07_axi_stream_tready  : in  std_logic;
			m07_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m08_axi_stream_aclk    : in  std_logic;
			m08_axi_stream_aresetn : in  std_logic;
			m08_axi_stream_tvalid  : out std_logic;
			m08_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m08_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m08_axi_stream_tlast   : out std_logic;
			m08_axi_stream_tready  : in  std_logic;
			m08_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m09_axi_stream_aclk    : in  std_logic;
			m09_axi_stream_aresetn : in  std_logic;
			m09_axi_stream_tvalid  : out std_logic;
			m09_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m09_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m09_axi_stream_tlast   : out std_logic;
			m09_axi_stream_tready  : in  std_logic;
			m09_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m10_axi_stream_aclk    : in  std_logic;
			m10_axi_stream_aresetn : in  std_logic;
			m10_axi_stream_tvalid  : out std_logic;
			m10_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m10_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m10_axi_stream_tlast   : out std_logic;
			m10_axi_stream_tready  : in  std_logic;
			m10_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m11_axi_stream_aclk    : in  std_logic;
			m11_axi_stream_aresetn : in  std_logic;
			m11_axi_stream_tvalid  : out std_logic;
			m11_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m11_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m11_axi_stream_tlast   : out std_logic;
			m11_axi_stream_tready  : in  std_logic;
			m11_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m12_axi_stream_aclk    : in  std_logic;
			m12_axi_stream_aresetn : in  std_logic;
			m12_axi_stream_tvalid  : out std_logic;
			m12_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m12_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m12_axi_stream_tlast   : out std_logic;
			m12_axi_stream_tready  : in  std_logic;
			m12_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m13_axi_stream_aclk    : in  std_logic;
			m13_axi_stream_aresetn : in  std_logic;
			m13_axi_stream_tvalid  : out std_logic;
			m13_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m13_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m13_axi_stream_tlast   : out std_logic;
			m13_axi_stream_tready  : in  std_logic;
			m13_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m14_axi_stream_aclk    : in  std_logic;
			m14_axi_stream_aresetn : in  std_logic;
			m14_axi_stream_tvalid  : out std_logic;
			m14_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m14_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m14_axi_stream_tlast   : out std_logic;
			m14_axi_stream_tready  : in  std_logic;
			m14_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
			m15_axi_stream_aclk    : in  std_logic;
			m15_axi_stream_aresetn : in  std_logic;
			m15_axi_stream_tvalid  : out std_logic;
			m15_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
			m15_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
			m15_axi_stream_tlast   : out std_logic;
			m15_axi_stream_tready  : in  std_logic;
			m15_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0;

begin

	--Asignacion de senales internas a la entidad
	--read_transaction_finished <= '1' when (done_READ_ADDRESS and done_READ_DATA) = '1' else '0';
	--write_transaction_finished <= '1' when (done_WRITE_ADDRESS and done_WRITE_DATA and done_WRITE_RESPONSE) = '1' else '0';
	read_transaction_finished  <= '1' when done_READ_DATA = '1' else '0';
	write_transaction_finished <= '1' when done_WRITE_RESPONSE = '1' else '0';

	--Instanciacion de los canales
	Canal_READ_ADDRESS_inst : AXI_READ_ADDRESS_CONTROL_CHANNEL_model
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
		port map(
			--In signals
			clk       => clk,
			resetn    => resetn,
			go        => start_read_transaction,
			address   => address,
			AxARREADY => s_AxARREADY,
			--Out signals
			done      => done_READ_ADDRESS,
			AxARADDR  => s_AxARADDR,
			AxARVALID => s_AxARVALID);

	Canal_READ_DATA_inst : AXI_READ_DATA_CONTROL_CHANNEL_model
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
		port map(
			-- In signals
			clk      => clk,
			resetn   => resetn,
			AxRDATA  => s_AxRDATA,
			AxRVALID => s_AxRVALID,
			AxRRESP  => s_AxRRESP,
			-- Out signals
			dato     => dato_r,
			done     => done_READ_DATA,
			resp     => resp_r,
			AxRREADY => s_AxRREADY);

	Canal_WRITE_ADDRESS_inst : AXI_WRITE_ADDRESS_CONTROL_CHANNEL_model
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
		port map(
			-- In signals	
			clk       => clk,
			resetn    => resetn,
			go        => start_write_transaction,
			address   => address,
			AxAWREADY => s_AxAWREADY,
			-- Out signals
			done      => done_WRITE_ADDRESS,
			AxAWADDR  => s_AxAWADDR,
			AxAWVALID => s_AxAWVALID);

	Canal_WRITE_DATA_inst : AXI_WRITE_DATA_CONTROL_CHANNEL_model
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
		port map(
			-- In signals
			clk      => clk,
			resetn   => resetn,
			go       => start_write_transaction,
			dato     => dato_w,
			AxWREADY => s_AxWREADY,
			-- Out signals
			done     => done_WRITE_DATA,
			AxWDATA  => s_AxWDATA,
			AxWSTRB  => s_AxWSTRB,
			AxWVALID => s_AxWVALID);

	Canal_WRITE_RESPONSE_inst : AXI_WRITE_RESPONSE_CONTROL_CHANNEL_model
		generic map(
			DATA_SIZE => DATA_SIZE,
			ADDR_SIZE => ADDR_SIZE
		)
		port map(
			-- In signals
			clk      => clk,
			resetn   => resetn,
			AxBVALID => s_AxBVALID,
			AxBRESP  => s_AxBRESP,
			-- Out signals
			resp     => resp_w,
			done     => done_WRITE_RESPONSE,
			AxBREADY => s_AxBREADY);

	--TODO: Instanciacion del periferico a testar y asignacion de senales a los puertos
	--...
	--...
	--...
	--EJEMPLO
	DUT_Inst : AXI_SourceStrm_Core_v5_0
		generic map(
			CNT_WIDTH                    => CNT_WIDTH,
			FRAME_LENGTH                 => FRAME_LENGTH,
			LAST_WIDTH                   => LAST_WIDTH,
			ID_WIDTH                     => ID_WIDTH,
			FIFO_DEPTH                   => FIFO_DEPTH,
			N_REGISTROS                  => N_REGISTROS,
			C_S00_AXI_LITE_DATA_WIDTH    => DATA_SIZE,
			C_S00_AXI_LITE_ADDR_WIDTH    => ADDR_SIZE,
			C_M00_AXI_STREAM_TDATA_WIDTH => C_M_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			s00_axi_lite_aclk      => clk,
			s00_axi_lite_aresetn   => resetn,
			s00_axi_lite_awaddr    => s_AxAWADDR,
			s00_axi_lite_awprot    => "000",
			s00_axi_lite_awvalid   => s_AxAWVALID,
			s00_axi_lite_awready   => s_AxAWREADY,
			s00_axi_lite_wdata     => s_AxWDATA,
			s00_axi_lite_wstrb     => s_AxWSTRB,
			s00_axi_lite_wvalid    => s_AxWVALID,
			s00_axi_lite_wready    => s_AxWREADY,
			s00_axi_lite_bresp     => s_AxBRESP,
			s00_axi_lite_bvalid    => s_AxBVALID,
			s00_axi_lite_bready    => s_AxBREADY,
			s00_axi_lite_araddr    => s_AxARADDR,
			s00_axi_lite_arprot    => "000",
			s00_axi_lite_arvalid   => s_AxARVALID,
			s00_axi_lite_arready   => s_AxARREADY,
			s00_axi_lite_rdata     => s_AxRDATA,
			s00_axi_lite_rresp     => s_AxRRESP,
			s00_axi_lite_rvalid    => s_AxRVALID,
			s00_axi_lite_rready    => s_AxRREADY,
			m00_axi_stream_aclk    => m00_axi_stream_aclk,
			m00_axi_stream_aresetn => m00_axi_stream_aresetn,
			m00_axi_stream_tvalid  => m00_axi_stream_tvalid,
			m00_axi_stream_tdata   => m00_axi_stream_tdata,
			m00_axi_stream_tstrb   => m00_axi_stream_tstrb,
			m00_axi_stream_tlast   => m00_axi_stream_tlast,
			m00_axi_stream_tready  => m00_axi_stream_tready,
			m00_axi_stream_tid     => m00_axi_stream_tid,
			m01_axi_stream_aclk    => m01_axi_stream_aclk,
			m01_axi_stream_aresetn => m01_axi_stream_aresetn,
			m01_axi_stream_tvalid  => m01_axi_stream_tvalid,
			m01_axi_stream_tdata   => m01_axi_stream_tdata,
			m01_axi_stream_tstrb   => m01_axi_stream_tstrb,
			m01_axi_stream_tlast   => m01_axi_stream_tlast,
			m01_axi_stream_tready  => m01_axi_stream_tready,
			m01_axi_stream_tid     => m01_axi_stream_tid,
			m02_axi_stream_aclk    => m02_axi_stream_aclk,
			m02_axi_stream_aresetn => m02_axi_stream_aresetn,
			m02_axi_stream_tvalid  => m02_axi_stream_tvalid,
			m02_axi_stream_tdata   => m02_axi_stream_tdata,
			m02_axi_stream_tstrb   => m02_axi_stream_tstrb,
			m02_axi_stream_tlast   => m02_axi_stream_tlast,
			m02_axi_stream_tready  => m02_axi_stream_tready,
			m02_axi_stream_tid     => m02_axi_stream_tid,
			m03_axi_stream_aclk    => m03_axi_stream_aclk,
			m03_axi_stream_aresetn => m03_axi_stream_aresetn,
			m03_axi_stream_tvalid  => m03_axi_stream_tvalid,
			m03_axi_stream_tdata   => m03_axi_stream_tdata,
			m03_axi_stream_tstrb   => m03_axi_stream_tstrb,
			m03_axi_stream_tlast   => m03_axi_stream_tlast,
			m03_axi_stream_tready  => m03_axi_stream_tready,
			m03_axi_stream_tid     => m03_axi_stream_tid,
			m04_axi_stream_aclk    => m04_axi_stream_aclk,
			m04_axi_stream_aresetn => m04_axi_stream_aresetn,
			m04_axi_stream_tvalid  => m04_axi_stream_tvalid,
			m04_axi_stream_tdata   => m04_axi_stream_tdata,
			m04_axi_stream_tstrb   => m04_axi_stream_tstrb,
			m04_axi_stream_tlast   => m04_axi_stream_tlast,
			m04_axi_stream_tready  => m04_axi_stream_tready,
			m04_axi_stream_tid     => m04_axi_stream_tid,
			m05_axi_stream_aclk    => m05_axi_stream_aclk,
			m05_axi_stream_aresetn => m05_axi_stream_aresetn,
			m05_axi_stream_tvalid  => m05_axi_stream_tvalid,
			m05_axi_stream_tdata   => m05_axi_stream_tdata,
			m05_axi_stream_tstrb   => m05_axi_stream_tstrb,
			m05_axi_stream_tlast   => m05_axi_stream_tlast,
			m05_axi_stream_tready  => m05_axi_stream_tready,
			m05_axi_stream_tid     => m05_axi_stream_tid,
			m06_axi_stream_aclk    => m06_axi_stream_aclk,
			m06_axi_stream_aresetn => m06_axi_stream_aresetn,
			m06_axi_stream_tvalid  => m06_axi_stream_tvalid,
			m06_axi_stream_tdata   => m06_axi_stream_tdata,
			m06_axi_stream_tstrb   => m06_axi_stream_tstrb,
			m06_axi_stream_tlast   => m06_axi_stream_tlast,
			m06_axi_stream_tready  => m06_axi_stream_tready,
			m06_axi_stream_tid     => m06_axi_stream_tid,
			m07_axi_stream_aclk    => m07_axi_stream_aclk,
			m07_axi_stream_aresetn => m07_axi_stream_aresetn,
			m07_axi_stream_tvalid  => m07_axi_stream_tvalid,
			m07_axi_stream_tdata   => m07_axi_stream_tdata,
			m07_axi_stream_tstrb   => m07_axi_stream_tstrb,
			m07_axi_stream_tlast   => m07_axi_stream_tlast,
			m07_axi_stream_tready  => m07_axi_stream_tready,
			m07_axi_stream_tid     => m07_axi_stream_tid,
			m08_axi_stream_aclk    => m08_axi_stream_aclk,
			m08_axi_stream_aresetn => m08_axi_stream_aresetn,
			m08_axi_stream_tvalid  => m08_axi_stream_tvalid,
			m08_axi_stream_tdata   => m08_axi_stream_tdata,
			m08_axi_stream_tstrb   => m08_axi_stream_tstrb,
			m08_axi_stream_tlast   => m08_axi_stream_tlast,
			m08_axi_stream_tready  => m08_axi_stream_tready,
			m08_axi_stream_tid     => m08_axi_stream_tid,
			m09_axi_stream_aclk    => m09_axi_stream_aclk,
			m09_axi_stream_aresetn => m09_axi_stream_aresetn,
			m09_axi_stream_tvalid  => m09_axi_stream_tvalid,
			m09_axi_stream_tdata   => m09_axi_stream_tdata,
			m09_axi_stream_tstrb   => m09_axi_stream_tstrb,
			m09_axi_stream_tlast   => m09_axi_stream_tlast,
			m09_axi_stream_tready  => m09_axi_stream_tready,
			m09_axi_stream_tid     => m09_axi_stream_tid,
			m10_axi_stream_aclk    => m10_axi_stream_aclk,
			m10_axi_stream_aresetn => m10_axi_stream_aresetn,
			m10_axi_stream_tvalid  => m10_axi_stream_tvalid,
			m10_axi_stream_tdata   => m10_axi_stream_tdata,
			m10_axi_stream_tstrb   => m10_axi_stream_tstrb,
			m10_axi_stream_tlast   => m10_axi_stream_tlast,
			m10_axi_stream_tready  => m10_axi_stream_tready,
			m10_axi_stream_tid     => m10_axi_stream_tid,
			m11_axi_stream_aclk    => m11_axi_stream_aclk,
			m11_axi_stream_aresetn => m11_axi_stream_aresetn,
			m11_axi_stream_tvalid  => m11_axi_stream_tvalid,
			m11_axi_stream_tdata   => m11_axi_stream_tdata,
			m11_axi_stream_tstrb   => m11_axi_stream_tstrb,
			m11_axi_stream_tlast   => m11_axi_stream_tlast,
			m11_axi_stream_tready  => m11_axi_stream_tready,
			m11_axi_stream_tid     => m11_axi_stream_tid,
			m12_axi_stream_aclk    => m12_axi_stream_aclk,
			m12_axi_stream_aresetn => m12_axi_stream_aresetn,
			m12_axi_stream_tvalid  => m12_axi_stream_tvalid,
			m12_axi_stream_tdata   => m12_axi_stream_tdata,
			m12_axi_stream_tstrb   => m12_axi_stream_tstrb,
			m12_axi_stream_tlast   => m12_axi_stream_tlast,
			m12_axi_stream_tready  => m12_axi_stream_tready,
			m12_axi_stream_tid     => m12_axi_stream_tid,
			m13_axi_stream_aclk    => m13_axi_stream_aclk,
			m13_axi_stream_aresetn => m13_axi_stream_aresetn,
			m13_axi_stream_tvalid  => m13_axi_stream_tvalid,
			m13_axi_stream_tdata   => m13_axi_stream_tdata,
			m13_axi_stream_tstrb   => m13_axi_stream_tstrb,
			m13_axi_stream_tlast   => m13_axi_stream_tlast,
			m13_axi_stream_tready  => m13_axi_stream_tready,
			m13_axi_stream_tid     => m13_axi_stream_tid,
			m14_axi_stream_aclk    => m14_axi_stream_aclk,
			m14_axi_stream_aresetn => m14_axi_stream_aresetn,
			m14_axi_stream_tvalid  => m14_axi_stream_tvalid,
			m14_axi_stream_tdata   => m14_axi_stream_tdata,
			m14_axi_stream_tstrb   => m14_axi_stream_tstrb,
			m14_axi_stream_tlast   => m14_axi_stream_tlast,
			m14_axi_stream_tready  => m14_axi_stream_tready,
			m14_axi_stream_tid     => m14_axi_stream_tid,
			m15_axi_stream_aclk    => m15_axi_stream_aclk,
			m15_axi_stream_aresetn => m15_axi_stream_aresetn,
			m15_axi_stream_tvalid  => m15_axi_stream_tvalid,
			m15_axi_stream_tdata   => m15_axi_stream_tdata,
			m15_axi_stream_tstrb   => m15_axi_stream_tstrb,
			m15_axi_stream_tlast   => m15_axi_stream_tlast,
			m15_axi_stream_tready  => m15_axi_stream_tready,
			m15_axi_stream_tid     => m15_axi_stream_tid
		);

	--Maquina de estados que controla los procesos de lectura y escritura
	--Next State Function
	stage_1 : process(current_state, read_transaction_finished, write_transaction_finished, go, rnw)
	begin
		case current_state is
			when reset =>
				next_state <= idle;
			when idle =>
				next_state <= idle;
				if go = '1' then
					case rnw is
						when '1'    => next_state <= start_read;
						when '0'    => next_state <= start_write;
						when others => NULL;
					end case;
				end if;
			when start_read =>
				next_state <= read_transaction;
			when read_transaction =>
				next_state <= read_transaction;
				if read_transaction_finished = '1' then
					next_state <= complete;
				end if;
			when start_write =>
				next_state <= write_transaction;
			when write_transaction =>
				next_state <= write_transaction;
				if write_transaction_finished = '1' then
					next_state <= complete;
				end if;
			when complete =>
				next_state <= complete;
				if go = '0' then
					next_state <= idle;
				end if;
			when others =>
				next_state <= reset;
		end case;
	end process;

	--State Register
	stage_2 : process(clk, resetn)
	begin
		if (resetn = '0') then
			current_state <= reset;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;

	--Output Function
	stage_3 : process(current_state)
	begin
		start_read_transaction  <= '0';
		start_write_transaction <= '0';
		done                    <= '0';
		busy                    <= '0';
		case current_state is
			when reset => NULL;
			when idle  => NULL;
			when start_read =>
				start_read_transaction <= '1';
				busy                   <= '1';
			when read_transaction =>
				busy <= '1';
			when start_write =>
				start_write_transaction <= '1';
				busy                    <= '1';
			when write_transaction =>
				busy <= '1';
			when complete =>
				done <= '1';
		end case;
	end process;
end Behavioral;
