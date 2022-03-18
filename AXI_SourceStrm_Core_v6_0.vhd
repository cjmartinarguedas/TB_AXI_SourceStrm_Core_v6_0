library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_SourceStrm_Core_v5_0 is
	generic(
		-- Users to add parameters here
		-- Parametros del Usr_Logic
		CNT_WIDTH                    : integer := 16; -- Numero de bits del contador
		FRAME_LENGTH                 : integer := 4096; -- Longitud del frame
		LAST_WIDTH                   : integer := 1; -- Numero de bits de LAST
		ID_WIDTH                     : integer := 4; -- Numero de bits del ID
		FIFO_DEPTH                   : integer := 8;
		N_REGISTROS                  : integer := 4;
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Parameters of Axi Slave Bus Interface S00_AXI_LITE
		C_S00_AXI_LITE_DATA_WIDTH    : integer := 32;
		C_S00_AXI_LITE_ADDR_WIDTH    : integer := 4;
		-- Parameters of Axi Master Bus Interface M00_AXI_STREAM
		C_M00_AXI_STREAM_TDATA_WIDTH : integer := 32
	);
	port(
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Ports of Axi Slave Bus Interface S00_AXI_LITE
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
		-- Ports of Axi Master Bus Interface M00_AXI_STREAM
		m00_axi_stream_aclk    : in  std_logic;
		m00_axi_stream_aresetn : in  std_logic;
		m00_axi_stream_tvalid  : out std_logic;
		m00_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m00_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m00_axi_stream_tlast   : out std_logic;
		m00_axi_stream_tready  : in  std_logic;
		m00_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M01_AXI_STREAM
		m01_axi_stream_aclk    : in  std_logic;
		m01_axi_stream_aresetn : in  std_logic;
		m01_axi_stream_tvalid  : out std_logic;
		m01_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m01_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m01_axi_stream_tlast   : out std_logic;
		m01_axi_stream_tready  : in  std_logic;
		m01_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M02_AXI_STREAM
		m02_axi_stream_aclk    : in  std_logic;
		m02_axi_stream_aresetn : in  std_logic;
		m02_axi_stream_tvalid  : out std_logic;
		m02_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m02_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m02_axi_stream_tlast   : out std_logic;
		m02_axi_stream_tready  : in  std_logic;
		m02_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M03_AXI_STREAM
		m03_axi_stream_aclk    : in  std_logic;
		m03_axi_stream_aresetn : in  std_logic;
		m03_axi_stream_tvalid  : out std_logic;
		m03_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m03_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m03_axi_stream_tlast   : out std_logic;
		m03_axi_stream_tready  : in  std_logic;
		m03_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M04_AXI_STREAM
		m04_axi_stream_aclk    : in  std_logic;
		m04_axi_stream_aresetn : in  std_logic;
		m04_axi_stream_tvalid  : out std_logic;
		m04_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m04_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m04_axi_stream_tlast   : out std_logic;
		m04_axi_stream_tready  : in  std_logic;
		m04_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M05_AXI_STREAM
		m05_axi_stream_aclk    : in  std_logic;
		m05_axi_stream_aresetn : in  std_logic;
		m05_axi_stream_tvalid  : out std_logic;
		m05_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m05_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m05_axi_stream_tlast   : out std_logic;
		m05_axi_stream_tready  : in  std_logic;
		m05_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M06_AXI_STREAM
		m06_axi_stream_aclk    : in  std_logic;
		m06_axi_stream_aresetn : in  std_logic;
		m06_axi_stream_tvalid  : out std_logic;
		m06_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m06_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m06_axi_stream_tlast   : out std_logic;
		m06_axi_stream_tready  : in  std_logic;
		m06_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M07_AXI_STREAM
		m07_axi_stream_aclk    : in  std_logic;
		m07_axi_stream_aresetn : in  std_logic;
		m07_axi_stream_tvalid  : out std_logic;
		m07_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m07_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m07_axi_stream_tlast   : out std_logic;
		m07_axi_stream_tready  : in  std_logic;
		m07_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M08_AXI_STREAM
		m08_axi_stream_aclk    : in  std_logic;
		m08_axi_stream_aresetn : in  std_logic;
		m08_axi_stream_tvalid  : out std_logic;
		m08_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m08_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m08_axi_stream_tlast   : out std_logic;
		m08_axi_stream_tready  : in  std_logic;
		m08_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M09_AXI_STREAM
		m09_axi_stream_aclk    : in  std_logic;
		m09_axi_stream_aresetn : in  std_logic;
		m09_axi_stream_tvalid  : out std_logic;
		m09_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m09_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m09_axi_stream_tlast   : out std_logic;
		m09_axi_stream_tready  : in  std_logic;
		m09_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M10_AXI_STREAM
		m10_axi_stream_aclk    : in  std_logic;
		m10_axi_stream_aresetn : in  std_logic;
		m10_axi_stream_tvalid  : out std_logic;
		m10_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m10_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m10_axi_stream_tlast   : out std_logic;
		m10_axi_stream_tready  : in  std_logic;
		m10_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M11_AXI_STREAM
		m11_axi_stream_aclk    : in  std_logic;
		m11_axi_stream_aresetn : in  std_logic;
		m11_axi_stream_tvalid  : out std_logic;
		m11_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m11_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m11_axi_stream_tlast   : out std_logic;
		m11_axi_stream_tready  : in  std_logic;
		m11_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M12_AXI_STREAM
		m12_axi_stream_aclk    : in  std_logic;
		m12_axi_stream_aresetn : in  std_logic;
		m12_axi_stream_tvalid  : out std_logic;
		m12_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m12_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m12_axi_stream_tlast   : out std_logic;
		m12_axi_stream_tready  : in  std_logic;
		m12_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M13_AXI_STREAM
		m13_axi_stream_aclk    : in  std_logic;
		m13_axi_stream_aresetn : in  std_logic;
		m13_axi_stream_tvalid  : out std_logic;
		m13_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m13_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m13_axi_stream_tlast   : out std_logic;
		m13_axi_stream_tready  : in  std_logic;
		m13_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M14_AXI_STREAM
		m14_axi_stream_aclk    : in  std_logic;
		m14_axi_stream_aresetn : in  std_logic;
		m14_axi_stream_tvalid  : out std_logic;
		m14_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m14_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m14_axi_stream_tlast   : out std_logic;
		m14_axi_stream_tready  : in  std_logic;
		m14_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0);
		-- Ports of Axi Master Bus Interface M15_AXI_STREAM
		m15_axi_stream_aclk    : in  std_logic;
		m15_axi_stream_aresetn : in  std_logic;
		m15_axi_stream_tvalid  : out std_logic;
		m15_axi_stream_tdata   : out std_logic_vector(C_M00_AXI_STREAM_TDATA_WIDTH - 1 downto 0);
		m15_axi_stream_tstrb   : out std_logic_vector((C_M00_AXI_STREAM_TDATA_WIDTH / 8) - 1 downto 0);
		m15_axi_stream_tlast   : out std_logic;
		m15_axi_stream_tready  : in  std_logic;
		m15_axi_stream_tid     : out std_logic_vector(ID_WIDTH - 1 downto 0)
	);
end AXI_SourceStrm_Core_v5_0;

architecture arch_imp of AXI_SourceStrm_Core_v5_0 is

	--(CJ) MODIFICACION 7: Declaracion de las senales externas accesibles desde USR_LOGIC
	signal datain0  : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal datain1  : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal datain2  : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal datain3  : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal dataout0 : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal dataout1 : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal dataout2 : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);
	signal dataout3 : std_logic_vector(C_S00_AXI_LITE_DATA_WIDTH - 1 downto 0);

	--(CJ) MODIFICACION 11: Declaracion de las senales internas que conectan con el USR_LOGIC (todas llevan el prefijo s_ para identificarlas)
	signal s_start     : std_logic;
	signal s_init_cnt  : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal s_cnt       : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal s_data      : std_logic_vector(CNT_WIDTH - 1 downto 0) := (others => '0');
	signal s_valid     : std_logic;
	signal s_last      : std_logic;

	signal s_id0  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id1  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id2  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id3  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id4  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id5  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id6  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id7  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id8  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id9  : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id10 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id11 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id12 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id13 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id14 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');
	signal s_id15 : std_logic_vector(ID_WIDTH - 1 downto 0) := (others => '0');

	signal s_beat_in0  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in1  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in2  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in3  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in4  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in5  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in6  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in7  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in8  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in9  : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in10 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in11 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in12 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in13 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in14 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	signal s_beat_in15 : std_logic_vector(ID_WIDTH + LAST_WIDTH + CNT_WIDTH - 1 downto 0);
	
	signal s_fifo_full_0 : std_logic;
	signal s_fifo_full_1 : std_logic;
	signal s_fifo_full_2 : std_logic;
	signal s_fifo_full_3 : std_logic;
	signal s_fifo_full_4 : std_logic;
	signal s_fifo_full_5 : std_logic;
	signal s_fifo_full_6 : std_logic;
	signal s_fifo_full_7 : std_logic;
	signal s_fifo_full_8 : std_logic;
	signal s_fifo_full_9 : std_logic;
	signal s_fifo_full_10 : std_logic;
	signal s_fifo_full_11 : std_logic;
	signal s_fifo_full_12 : std_logic;
	signal s_fifo_full_13 : std_logic;
	signal s_fifo_full_14 : std_logic;
	signal s_fifo_full_15 : std_logic;

	signal s_reg_we  : std_logic_vector(N_REGISTROS - 1 downto 0);
	signal s_reg0_we : std_logic;
	signal s_reg1_we : std_logic;
	signal s_reg2_we : std_logic;
	signal s_reg3_we : std_logic;

	-- component declaration
	component AXI_SourceStrm_Core_v5_0_S00_AXI_LITE
		generic(
			C_S_AXI_DATA_WIDTH : integer := 32;
			C_S_AXI_ADDR_WIDTH : integer := 4
		);
		port(
			datain0       : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			datain1       : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			datain2       : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			datain3       : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			dataout0      : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			dataout1      : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			dataout2      : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			dataout3      : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			reg0_we       : out std_logic;
			reg1_we       : out std_logic;
			reg2_we       : out std_logic;
			reg3_we       : out std_logic;
			S_AXI_ACLK    : in  std_logic;
			S_AXI_ARESETN : in  std_logic;
			S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
			S_AXI_AWVALID : in  std_logic;
			S_AXI_AWREADY : out std_logic;
			S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
			S_AXI_WVALID  : in  std_logic;
			S_AXI_WREADY  : out std_logic;
			S_AXI_BRESP   : out std_logic_vector(1 downto 0);
			S_AXI_BVALID  : out std_logic;
			S_AXI_BREADY  : in  std_logic;
			S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
			S_AXI_ARVALID : in  std_logic;
			S_AXI_ARREADY : out std_logic;
			S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			S_AXI_RRESP   : out std_logic_vector(1 downto 0);
			S_AXI_RVALID  : out std_logic;
			S_AXI_RREADY  : in  std_logic
		);
	end component AXI_SourceStrm_Core_v5_0_S00_AXI_LITE;

	component AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M01_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M01_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M02_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M02_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M03_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M03_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M04_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M04_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M05_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M05_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M06_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M06_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M07_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M07_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M08_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M08_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M09_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M09_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M10_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M10_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M11_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M11_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M12_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M12_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M13_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M13_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M14_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M14_AXI_STREAM;

	component AXI_SourceStrm_Core_v5_0_M15_AXI_STREAM
		generic(
			M_DATA_WIDTH         : integer;
			M_LAST_WIDTH         : integer;
			M_ID_WIDTH           : integer;
			M_FIFO_DEPTH         : integer;
			C_M_AXIS_TDATA_WIDTH : integer
		);
		port(
			beat_in        : in  std_logic_vector(M_ID_WIDTH + M_LAST_WIDTH + M_DATA_WIDTH - 1 downto 0);
			valid_beat     : in  std_logic;
			fifo_full      : out std_logic;
			M_AXIS_ACLK    : in  std_logic;
			M_AXIS_ARESETN : in  std_logic;
			M_AXIS_TVALID  : out std_logic;
			M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			M_AXIS_TLAST   : out std_logic;
			M_AXIS_TREADY  : in  std_logic;
			M_AXIS_TID     : out std_logic_vector(M_ID_WIDTH - 1 downto 0)
		);
	end component AXI_SourceStrm_Core_v5_0_M15_AXI_STREAM;

	--(CJ) MODIFICACION 9: Instanciacion del Usr_Logic
	component SourceStrm_Usr_Logic_5
		generic(
			CNT_WIDTH    : integer;
			FRAME_LENGTH : integer
		);
		port(
			clk      : in  std_logic;
			rstn     : in  std_logic;
			start    : in  std_logic;
			init_cnt : in  std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt      : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			last     : out std_logic;
			valid    : out std_logic
		);
	end component SourceStrm_Usr_Logic_5;

begin

	-- Asignacion de senales internas
	s_data(CNT_WIDTH - 1 downto 0) <= s_cnt;
	--s_id(ID_WIDTH - 1 downto 0)     <= s_id_short;
	s_id0(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(0, ID_WIDTH));
	s_id1(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(1, ID_WIDTH));
	s_id2(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(2, ID_WIDTH));
	s_id3(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(3, ID_WIDTH));
	s_id4(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(4, ID_WIDTH));
	s_id5(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(5, ID_WIDTH));
	s_id6(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(6, ID_WIDTH));
	s_id7(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(7, ID_WIDTH));
	s_id8(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(8, ID_WIDTH));
	s_id9(ID_WIDTH - 1 downto 0)   <= std_logic_vector(to_unsigned(9, ID_WIDTH));
	s_id10(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(10, ID_WIDTH));
	s_id11(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(11, ID_WIDTH));
	s_id12(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(12, ID_WIDTH));
	s_id13(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(13, ID_WIDTH));
	s_id14(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(14, ID_WIDTH));
	s_id15(ID_WIDTH - 1 downto 0)  <= std_logic_vector(to_unsigned(15, ID_WIDTH));
	--s_beat_in                       <= s_id & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in0                     <= s_id0 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in1                     <= s_id1 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in2                     <= s_id2 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in3                     <= s_id3 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in4                     <= s_id4 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in5                     <= s_id5 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in6                     <= s_id6 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in7                     <= s_id7 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in8                     <= s_id8 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in9                     <= s_id9 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in10                    <= s_id10 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in11                    <= s_id11 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in12                    <= s_id12 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in13                    <= s_id13 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in14                    <= s_id14 & s_last & s_data; --TID & TLAST & TDATA
	s_beat_in15                    <= s_id15 & s_last & s_data; --TID & TLAST & TDATA
	s_reg_we                       <= s_reg3_we & s_reg2_we & s_reg1_we & s_reg0_we;
	s_init_cnt                     <= dataout1(CNT_WIDTH - 1 downto 0);

	datain0(31) <= s_valid;             --VALID actua tambien como BUSY
	--datain0(30) <= s_fifo_full;
    datain0(30) <= s_fifo_full_0 or s_fifo_full_1 or s_fifo_full_2 or s_fifo_full_3 or s_fifo_full_4 or s_fifo_full_5 or s_fifo_full_6 or s_fifo_full_7 or s_fifo_full_8 or s_fifo_full_9 or s_fifo_full_10 or s_fifo_full_11 or s_fifo_full_12 or s_fifo_full_13 or s_fifo_full_14 or s_fifo_full_15;

	-- Instantiation of Axi Bus Interface S00_AXI_LITE
	AXI_SourceStrm_Core_v3_0_S00_AXI_LITE_inst : AXI_SourceStrm_Core_v5_0_S00_AXI_LITE
		generic map(
			C_S_AXI_DATA_WIDTH => C_S00_AXI_LITE_DATA_WIDTH,
			C_S_AXI_ADDR_WIDTH => C_S00_AXI_LITE_ADDR_WIDTH
		)
		port map(
			datain0       => datain0,
			datain1       => datain1,
			datain2       => datain2,
			datain3       => datain3,
			dataout0      => dataout0,
			dataout1      => dataout1,
			dataout2      => dataout2,
			dataout3      => dataout3,
			reg0_we       => s_reg0_we,
			reg1_we       => s_reg1_we,
			reg2_we       => s_reg2_we,
			reg3_we       => s_reg3_we,
			S_AXI_ACLK    => s00_axi_lite_aclk,
			S_AXI_ARESETN => s00_axi_lite_aresetn,
			S_AXI_AWADDR  => s00_axi_lite_awaddr,
			S_AXI_AWPROT  => s00_axi_lite_awprot,
			S_AXI_AWVALID => s00_axi_lite_awvalid,
			S_AXI_AWREADY => s00_axi_lite_awready,
			S_AXI_WDATA   => s00_axi_lite_wdata,
			S_AXI_WSTRB   => s00_axi_lite_wstrb,
			S_AXI_WVALID  => s00_axi_lite_wvalid,
			S_AXI_WREADY  => s00_axi_lite_wready,
			S_AXI_BRESP   => s00_axi_lite_bresp,
			S_AXI_BVALID  => s00_axi_lite_bvalid,
			S_AXI_BREADY  => s00_axi_lite_bready,
			S_AXI_ARADDR  => s00_axi_lite_araddr,
			S_AXI_ARPROT  => s00_axi_lite_arprot,
			S_AXI_ARVALID => s00_axi_lite_arvalid,
			S_AXI_ARREADY => s00_axi_lite_arready,
			S_AXI_RDATA   => s00_axi_lite_rdata,
			S_AXI_RRESP   => s00_axi_lite_rresp,
			S_AXI_RVALID  => s00_axi_lite_rvalid,
			S_AXI_RREADY  => s00_axi_lite_rready
		);

	-- Instantiation of Axi Bus Interface M00_AXI_STREAM
	AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M00_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in0,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_0,
			M_AXIS_ACLK    => m00_axi_stream_aclk,
			M_AXIS_ARESETN => m00_axi_stream_aresetn,
			M_AXIS_TVALID  => m00_axi_stream_tvalid,
			M_AXIS_TDATA   => m00_axi_stream_tdata,
			M_AXIS_TSTRB   => m00_axi_stream_tstrb,
			M_AXIS_TLAST   => m00_axi_stream_tlast,
			M_AXIS_TREADY  => m00_axi_stream_tready,
			M_AXIS_TID     => m00_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M01_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M01_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in1,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_1,
			M_AXIS_ACLK    => m01_axi_stream_aclk,
			M_AXIS_ARESETN => m01_axi_stream_aresetn,
			M_AXIS_TVALID  => m01_axi_stream_tvalid,
			M_AXIS_TDATA   => m01_axi_stream_tdata,
			M_AXIS_TSTRB   => m01_axi_stream_tstrb,
			M_AXIS_TLAST   => m01_axi_stream_tlast,
			M_AXIS_TREADY  => m01_axi_stream_tready,
			M_AXIS_TID     => m01_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M02_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M02_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in2,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_2,
			M_AXIS_ACLK    => m02_axi_stream_aclk,
			M_AXIS_ARESETN => m02_axi_stream_aresetn,
			M_AXIS_TVALID  => m02_axi_stream_tvalid,
			M_AXIS_TDATA   => m02_axi_stream_tdata,
			M_AXIS_TSTRB   => m02_axi_stream_tstrb,
			M_AXIS_TLAST   => m02_axi_stream_tlast,
			M_AXIS_TREADY  => m02_axi_stream_tready,
			M_AXIS_TID     => m02_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M03_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M03_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in3,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_3,
			M_AXIS_ACLK    => m03_axi_stream_aclk,
			M_AXIS_ARESETN => m03_axi_stream_aresetn,
			M_AXIS_TVALID  => m03_axi_stream_tvalid,
			M_AXIS_TDATA   => m03_axi_stream_tdata,
			M_AXIS_TSTRB   => m03_axi_stream_tstrb,
			M_AXIS_TLAST   => m03_axi_stream_tlast,
			M_AXIS_TREADY  => m03_axi_stream_tready,
			M_AXIS_TID     => m03_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M04_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M04_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in4,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_4,
			M_AXIS_ACLK    => m04_axi_stream_aclk,
			M_AXIS_ARESETN => m04_axi_stream_aresetn,
			M_AXIS_TVALID  => m04_axi_stream_tvalid,
			M_AXIS_TDATA   => m04_axi_stream_tdata,
			M_AXIS_TSTRB   => m04_axi_stream_tstrb,
			M_AXIS_TLAST   => m04_axi_stream_tlast,
			M_AXIS_TREADY  => m04_axi_stream_tready,
			M_AXIS_TID     => m04_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M05_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M05_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in5,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_5,
			M_AXIS_ACLK    => m05_axi_stream_aclk,
			M_AXIS_ARESETN => m05_axi_stream_aresetn,
			M_AXIS_TVALID  => m05_axi_stream_tvalid,
			M_AXIS_TDATA   => m05_axi_stream_tdata,
			M_AXIS_TSTRB   => m05_axi_stream_tstrb,
			M_AXIS_TLAST   => m05_axi_stream_tlast,
			M_AXIS_TREADY  => m05_axi_stream_tready,
			M_AXIS_TID     => m05_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M06_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M06_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in6,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_6,
			M_AXIS_ACLK    => m06_axi_stream_aclk,
			M_AXIS_ARESETN => m06_axi_stream_aresetn,
			M_AXIS_TVALID  => m06_axi_stream_tvalid,
			M_AXIS_TDATA   => m06_axi_stream_tdata,
			M_AXIS_TSTRB   => m06_axi_stream_tstrb,
			M_AXIS_TLAST   => m06_axi_stream_tlast,
			M_AXIS_TREADY  => m06_axi_stream_tready,
			M_AXIS_TID     => m06_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M07_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M07_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in7,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_7,
			M_AXIS_ACLK    => m07_axi_stream_aclk,
			M_AXIS_ARESETN => m07_axi_stream_aresetn,
			M_AXIS_TVALID  => m07_axi_stream_tvalid,
			M_AXIS_TDATA   => m07_axi_stream_tdata,
			M_AXIS_TSTRB   => m07_axi_stream_tstrb,
			M_AXIS_TLAST   => m07_axi_stream_tlast,
			M_AXIS_TREADY  => m07_axi_stream_tready,
			M_AXIS_TID     => m07_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M08_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M08_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in8,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_8,
			M_AXIS_ACLK    => m08_axi_stream_aclk,
			M_AXIS_ARESETN => m08_axi_stream_aresetn,
			M_AXIS_TVALID  => m08_axi_stream_tvalid,
			M_AXIS_TDATA   => m08_axi_stream_tdata,
			M_AXIS_TSTRB   => m08_axi_stream_tstrb,
			M_AXIS_TLAST   => m08_axi_stream_tlast,
			M_AXIS_TREADY  => m08_axi_stream_tready,
			M_AXIS_TID     => m08_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M09_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M09_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in9,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_9,
			M_AXIS_ACLK    => m09_axi_stream_aclk,
			M_AXIS_ARESETN => m09_axi_stream_aresetn,
			M_AXIS_TVALID  => m09_axi_stream_tvalid,
			M_AXIS_TDATA   => m09_axi_stream_tdata,
			M_AXIS_TSTRB   => m09_axi_stream_tstrb,
			M_AXIS_TLAST   => m09_axi_stream_tlast,
			M_AXIS_TREADY  => m09_axi_stream_tready,
			M_AXIS_TID     => m09_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M10_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M10_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in10,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_10,
			M_AXIS_ACLK    => m10_axi_stream_aclk,
			M_AXIS_ARESETN => m10_axi_stream_aresetn,
			M_AXIS_TVALID  => m10_axi_stream_tvalid,
			M_AXIS_TDATA   => m10_axi_stream_tdata,
			M_AXIS_TSTRB   => m10_axi_stream_tstrb,
			M_AXIS_TLAST   => m10_axi_stream_tlast,
			M_AXIS_TREADY  => m10_axi_stream_tready,
			M_AXIS_TID     => m10_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M11_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M11_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in11,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_11,
			M_AXIS_ACLK    => m11_axi_stream_aclk,
			M_AXIS_ARESETN => m11_axi_stream_aresetn,
			M_AXIS_TVALID  => m11_axi_stream_tvalid,
			M_AXIS_TDATA   => m11_axi_stream_tdata,
			M_AXIS_TSTRB   => m11_axi_stream_tstrb,
			M_AXIS_TLAST   => m11_axi_stream_tlast,
			M_AXIS_TREADY  => m11_axi_stream_tready,
			M_AXIS_TID     => m11_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M12_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M12_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in12,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_12,
			M_AXIS_ACLK    => m12_axi_stream_aclk,
			M_AXIS_ARESETN => m12_axi_stream_aresetn,
			M_AXIS_TVALID  => m12_axi_stream_tvalid,
			M_AXIS_TDATA   => m12_axi_stream_tdata,
			M_AXIS_TSTRB   => m12_axi_stream_tstrb,
			M_AXIS_TLAST   => m12_axi_stream_tlast,
			M_AXIS_TREADY  => m12_axi_stream_tready,
			M_AXIS_TID     => m12_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M13_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M13_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in13,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_13,
			M_AXIS_ACLK    => m13_axi_stream_aclk,
			M_AXIS_ARESETN => m13_axi_stream_aresetn,
			M_AXIS_TVALID  => m13_axi_stream_tvalid,
			M_AXIS_TDATA   => m13_axi_stream_tdata,
			M_AXIS_TSTRB   => m13_axi_stream_tstrb,
			M_AXIS_TLAST   => m13_axi_stream_tlast,
			M_AXIS_TREADY  => m13_axi_stream_tready,
			M_AXIS_TID     => m13_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M14_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M14_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in14,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_14,
			M_AXIS_ACLK    => m14_axi_stream_aclk,
			M_AXIS_ARESETN => m14_axi_stream_aresetn,
			M_AXIS_TVALID  => m14_axi_stream_tvalid,
			M_AXIS_TDATA   => m14_axi_stream_tdata,
			M_AXIS_TSTRB   => m14_axi_stream_tstrb,
			M_AXIS_TLAST   => m14_axi_stream_tlast,
			M_AXIS_TREADY  => m14_axi_stream_tready,
			M_AXIS_TID     => m14_axi_stream_tid
		);

	AXI_SourceStrm_Core_v5_0_M15_AXI_STREAM_inst : AXI_SourceStrm_Core_v5_0_M15_AXI_STREAM
		generic map(
			M_DATA_WIDTH         => CNT_WIDTH,
			M_LAST_WIDTH         => LAST_WIDTH,
			M_ID_WIDTH           => ID_WIDTH,
			M_FIFO_DEPTH         => FIFO_DEPTH,
			C_M_AXIS_TDATA_WIDTH => C_M00_AXI_STREAM_TDATA_WIDTH
		)
		port map(
			beat_in        => s_beat_in15,
			valid_beat     => s_valid,
			fifo_full      => s_fifo_full_15,
			M_AXIS_ACLK    => m15_axi_stream_aclk,
			M_AXIS_ARESETN => m15_axi_stream_aresetn,
			M_AXIS_TVALID  => m15_axi_stream_tvalid,
			M_AXIS_TDATA   => m15_axi_stream_tdata,
			M_AXIS_TSTRB   => m15_axi_stream_tstrb,
			M_AXIS_TLAST   => m15_axi_stream_tlast,
			M_AXIS_TREADY  => m15_axi_stream_tready,
			M_AXIS_TID     => m15_axi_stream_tid
		);

	--(CJ) MODIFICACION 10: Mapeo de los puertos del Usr_Logic hacia fuera de la entidad superior y hacia las senales internas
	SourceStrm_Usr_Logic_5_inst : SourceStrm_Usr_Logic_5
		generic map(
			CNT_WIDTH    => CNT_WIDTH,
			FRAME_LENGTH => FRAME_LENGTH
		)
		port map(
			clk      => s00_axi_lite_aclk,
			rstn     => s00_axi_lite_aresetn,
			start    => s_start,
			init_cnt => s_init_cnt,
			cnt      => s_cnt,
			last     => s_last,
			valid    => s_valid
		);

	-- Add user logic here
	--(CJ) Prueba de escritura y lectura desde el bus AXI
	--datain0 <= dataout1;
	--datain1 <= dataout0;
	--datain2 <= X"00000003";
	--datain3 <= X"00000004";

	--(CJ) MODIFICACION 12: Programacion de logica que permite generar los pulsos de activacion de los procesos de lectura y escritura en el USR_LOGIC
	--NOTA: En este caso en particular s00_axi_lite_aclk es igual que FCLK
	process(s00_axi_lite_aclk)
		variable loc_addr : std_logic_vector(N_REGISTROS - 1 downto 0);
	begin
		if rising_edge(s00_axi_lite_aclk) then
			--Inicializamos una variable para simplificar el codigo
			loc_addr := s_reg_we;
			--Reseteamos las senales con cada ciclo de reloj
			s_start  <= '0';
			case loc_addr is
				when b"0001" =>         --Escritura AXI sobre dataout0
					if dataout0(31) = '1' then --Peticion de START del CORE (Mas prioritaria)
						s_start <= '1'; --Generamos el pulso de un ciclo de duracion que activa el estado adecuado en la FSM del Usr_Logic
					end if;
				when b"0010" =>         --Escritura AXI sobre dataout1
				when b"0100" =>         --Escritura AXI sobre dataout2
				when b"1000" =>         --Escritura AXI sobre dataout3
				when others => NULL;
					--            s_rst_spi <=  s_rst_spi;
					--            s_we      <=  s_we;
					--            s_re      <=  s_re;
			end case;
		end if;
	end process;

	-- User logic ends

end arch_imp;
