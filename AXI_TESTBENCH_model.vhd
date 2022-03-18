--NOTA: Testbench que ejecuta operacion de lectura y escritura sobre un periferico generico con un bus AXI Lite.
--Sigue el ejemplo mostrado en el documento "Designing a Custom AXI-Lite Slave Peripheral" de SILICA.

--NOTA: La forma de direccionar los registos a bajo nivel en el bus AXIs sigue la siguiente forma
-- Example-specific design signals
-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
-- ADDR_LSB is used for addressing 32/64 bit registers/memories
-- ADDR_LSB = 2 for 32 bits (n downto 2)
-- ADDR_LSB = 3 for 64 bits (n downto 3)
-- loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_TESTBENCH_model is
	generic(
		TB_DATA_SIZE     : integer := 32; --Tamano de los registros AXIS
		TB_ADDR_SIZE     : integer := 4; --Tamano del bus de durecciones
		TB_N_REGISTROS   : integer := 4;
		TB_CNT_WIDTH     : integer := 16; --Numero de bits del contador
		TB_FRAME_LENGTH  : integer := 8; --Longitud del frame
		TB_FIFO_DEPTH    : integer := 8;
		TB_M_TDATA_WIDTH : integer := 32; --Numero de bits del campo TDATA del interfaz Master Stream 
		TB_M_TLAST_WIDTH : integer := 1; --Numero de bits del campo TLAST del interfaz Master Stream
		TB_M_TID_WIDTH   : integer := 5 --Numero de bits del campo TID del interfaz Master Stream
	);
end AXI_TESTBENCH_model;

architecture Behavioral of AXI_TESTBENCH_model is

	--Declaracion de constantes
	constant CLK_PERIOD : time                                        := 5 ns; --Periodo del reloj
	constant REG0       : std_logic_vector(TB_ADDR_SIZE - 1 downto 0) := b"0000";
	constant REG1       : std_logic_vector(TB_ADDR_SIZE - 1 downto 0) := b"0100";
	constant REG2       : std_logic_vector(TB_ADDR_SIZE - 1 downto 0) := b"1000";
	constant REG3       : std_logic_vector(TB_ADDR_SIZE - 1 downto 0) := b"1100";

	--Declaracion de señales internas
	signal tb_clk      : std_logic;     --Reloj
	signal tb_resetn   : std_logic;     --Reset del bus, activo a nivel bajo
	signal tb_go       : std_logic;     --Inicio de la operacion en cuestion (R/W)
	signal tb_rnw      : std_logic;     --'1' Operacion de lectura de registro, '0' Operacion de escritura en registro
	signal tb_address  : std_logic_vector(TB_ADDR_SIZE - 1 downto 0); --Direccion del registro donde se desea leer o escribir
	signal tb_dato_w   : std_logic_vector(TB_DATA_SIZE - 1 downto 0); --Dato a escribir sobre el registro del periferico
	signal tb_busy     : std_logic;     --Operacion R/W en curso
	signal tb_done     : std_logic;     --Operacion R/W terminada
	signal tb_dato_r   : std_logic_vector(TB_DATA_SIZE - 1 downto 0); --Dato leido del registro
	signal tb_resp_r   : std_logic_vector(1 downto 0); --Respuesta en lectura del periferico
	signal tb_resp_w   : std_logic_vector(1 downto 0); --Respuesta en escritura del periferico
	--TODO: Declaracion de las senales del periferico
	--con interfaz AXI Lite que se desea testar
	--...
	--...
	--...
	signal tb_tvalid0  : std_logic;
	signal tb_tvalid1  : std_logic;
	signal tb_tvalid2  : std_logic;
	signal tb_tvalid3  : std_logic;
	signal tb_tvalid4  : std_logic;
	signal tb_tvalid5  : std_logic;
	signal tb_tvalid6  : std_logic;
	signal tb_tvalid7  : std_logic;
	signal tb_tvalid8  : std_logic;
	signal tb_tvalid9  : std_logic;
	signal tb_tvalid10 : std_logic;
	signal tb_tvalid11 : std_logic;
	signal tb_tvalid12 : std_logic;
	signal tb_tvalid13 : std_logic;
	signal tb_tvalid14 : std_logic;
	signal tb_tvalid15 : std_logic;
	
	signal tb_tdata0   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata1   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata2   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata3   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata4   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata5   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata6   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata7   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata8   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata9   : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata10  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata11  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata12  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata13  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata14  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	signal tb_tdata15  : std_logic_vector(TB_M_TDATA_WIDTH - 1 downto 0);
	
	--signal tb_tstrb   : std_logic_vector((TB_M_TDATA_WIDTH / 8) - 1 downto 0);
	
	signal tb_tlast0   : std_logic;
	signal tb_tlast1   : std_logic;
	signal tb_tlast2   : std_logic;
	signal tb_tlast3   : std_logic;
	signal tb_tlast4   : std_logic;
	signal tb_tlast5   : std_logic;
	signal tb_tlast6   : std_logic;
	signal tb_tlast7   : std_logic;
	signal tb_tlast8   : std_logic;
	signal tb_tlast9   : std_logic;
	signal tb_tlast10  : std_logic;
	signal tb_tlast11  : std_logic;
	signal tb_tlast12  : std_logic;
	signal tb_tlast13  : std_logic;
	signal tb_tlast14  : std_logic;
	signal tb_tlast15  : std_logic;
	
	signal tb_tready0  : std_logic;
	signal tb_tready1  : std_logic;
	signal tb_tready2  : std_logic;
	signal tb_tready3  : std_logic;
	signal tb_tready4  : std_logic;
	signal tb_tready5  : std_logic;
	signal tb_tready6  : std_logic;
	signal tb_tready7  : std_logic;
	signal tb_tready8  : std_logic;
	signal tb_tready9  : std_logic;
	signal tb_tready10 : std_logic;
	signal tb_tready11 : std_logic;
	signal tb_tready12 : std_logic;
	signal tb_tready13 : std_logic;
	signal tb_tready14 : std_logic;
	signal tb_tready15 : std_logic;
	
	signal tb_tid0     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid1     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid2     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid3     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid4     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid5     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid6     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid7     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid8     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid9     : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid10    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid11    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid12    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid13    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid14    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);
	signal tb_tid15    : std_logic_vector(TB_M_TID_WIDTH - 1 downto 0);

	--Declaracion de componentes
	component AXI_VERIFICATION_model
		generic(
			DATA_SIZE                  : integer;
			ADDR_SIZE                  : integer;
			N_REGISTROS                : integer;
			CNT_WIDTH                  : integer;
			FRAME_LENGTH               : integer;
			LAST_WIDTH                 : integer;
			ID_WIDTH                   : integer;
			FIFO_DEPTH                 : integer;
			C_M_AXI_STREAM_TDATA_WIDTH : integer
		);
		port(
			clk                    : in  std_logic;
			resetn                 : in  std_logic;
			go                     : in  std_logic;
			rnw                    : in  std_logic;
			address                : in  std_logic_vector(ADDR_SIZE - 1 downto 0);
			dato_w                 : in  std_logic_vector(DATA_SIZE - 1 downto 0);
			busy                   : out std_logic;
			done                   : out std_logic;
			dato_r                 : out std_logic_vector(DATA_SIZE - 1 downto 0);
			resp_r                 : out std_logic_vector(1 downto 0);
			resp_w                 : out std_logic_vector(1 downto 0);
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
		);
	end component AXI_VERIFICATION_model;

begin

	--Instanciacion de los componentes
	AXI_VERIFICATION_model_Inst : AXI_VERIFICATION_model
		generic map(
			DATA_SIZE                  => TB_DATA_SIZE,
			ADDR_SIZE                  => TB_ADDR_SIZE,
			N_REGISTROS                => TB_N_REGISTROS,
			CNT_WIDTH                  => TB_CNT_WIDTH,
			FRAME_LENGTH               => TB_FRAME_LENGTH,
			LAST_WIDTH                 => TB_M_TLAST_WIDTH,
			ID_WIDTH                   => TB_M_TID_WIDTH,
			FIFO_DEPTH                 => TB_FIFO_DEPTH,
			C_M_AXI_STREAM_TDATA_WIDTH => TB_M_TDATA_WIDTH
		)
		port map(
			clk                    => tb_clk,
			resetn                 => tb_resetn,
			go                     => tb_go,
			rnw                    => tb_rnw,
			address                => tb_address,
			dato_w                 => tb_dato_w,
			busy                   => tb_busy,
			done                   => tb_done,
			dato_r                 => tb_dato_r,
			resp_r                 => tb_resp_r,
			resp_w                 => tb_resp_w,
			m00_axi_stream_aclk    => tb_clk,
			m00_axi_stream_aresetn => tb_resetn,
			m00_axi_stream_tvalid  => tb_tvalid0,
			m00_axi_stream_tdata   => tb_tdata0,
			m00_axi_stream_tstrb   => open,
			m00_axi_stream_tlast   => tb_tlast0,
			m00_axi_stream_tready  => tb_tready0,
			m00_axi_stream_tid     => tb_tid0,
			m01_axi_stream_aclk    => tb_clk,
			m01_axi_stream_aresetn => tb_resetn,
			m01_axi_stream_tvalid  => tb_tvalid1,
			m01_axi_stream_tdata   => tb_tdata1,
			m01_axi_stream_tstrb   => open,
			m01_axi_stream_tlast   => tb_tlast1,
			m01_axi_stream_tready  => tb_tready1,
			m01_axi_stream_tid     => tb_tid1,
			m02_axi_stream_aclk    => tb_clk,
			m02_axi_stream_aresetn => tb_resetn,
			m02_axi_stream_tvalid  => tb_tvalid2,
			m02_axi_stream_tdata   => tb_tdata2,
			m02_axi_stream_tstrb   => open,
			m02_axi_stream_tlast   => tb_tlast2,
			m02_axi_stream_tready  => tb_tready2,
			m02_axi_stream_tid     => tb_tid2,
			m03_axi_stream_aclk    => tb_clk,
			m03_axi_stream_aresetn => tb_resetn,
			m03_axi_stream_tvalid  => tb_tvalid3,
			m03_axi_stream_tdata   => tb_tdata3,
			m03_axi_stream_tstrb   => open,
			m03_axi_stream_tlast   => tb_tlast3,
			m03_axi_stream_tready  => tb_tready3,
			m03_axi_stream_tid     => tb_tid3,
			m04_axi_stream_aclk    => tb_clk,
			m04_axi_stream_aresetn => tb_resetn,
			m04_axi_stream_tvalid  => tb_tvalid4,
			m04_axi_stream_tdata   => tb_tdata4,
			m04_axi_stream_tstrb   => open,
			m04_axi_stream_tlast   => tb_tlast4,
			m04_axi_stream_tready  => tb_tready4,
			m04_axi_stream_tid     => tb_tid4,
			m05_axi_stream_aclk    => tb_clk,
			m05_axi_stream_aresetn => tb_resetn,
			m05_axi_stream_tvalid  => tb_tvalid5,
			m05_axi_stream_tdata   => tb_tdata5,
			m05_axi_stream_tstrb   => open,
			m05_axi_stream_tlast   => tb_tlast5,
			m05_axi_stream_tready  => tb_tready5,
			m05_axi_stream_tid     => tb_tid5,
			m06_axi_stream_aclk    => tb_clk,
			m06_axi_stream_aresetn => tb_resetn,
			m06_axi_stream_tvalid  => tb_tvalid6,
			m06_axi_stream_tdata   => tb_tdata6,
			m06_axi_stream_tstrb   => open,
			m06_axi_stream_tlast   => tb_tlast6,
			m06_axi_stream_tready  => tb_tready6,
			m06_axi_stream_tid     => tb_tid6,
			m07_axi_stream_aclk    => tb_clk,
			m07_axi_stream_aresetn => tb_resetn,
			m07_axi_stream_tvalid  => tb_tvalid7,
			m07_axi_stream_tdata   => tb_tdata7,
			m07_axi_stream_tstrb   => open,
			m07_axi_stream_tlast   => tb_tlast7,
			m07_axi_stream_tready  => tb_tready7,
			m07_axi_stream_tid     => tb_tid7,
			m08_axi_stream_aclk    => tb_clk,
			m08_axi_stream_aresetn => tb_resetn,
			m08_axi_stream_tvalid  => tb_tvalid8,
			m08_axi_stream_tdata   => tb_tdata8,
			m08_axi_stream_tstrb   => open,
			m08_axi_stream_tlast   => tb_tlast8,
			m08_axi_stream_tready  => tb_tready8,
			m08_axi_stream_tid     => tb_tid8,
			m09_axi_stream_aclk    => tb_clk,
			m09_axi_stream_aresetn => tb_resetn,
			m09_axi_stream_tvalid  => tb_tvalid9,
			m09_axi_stream_tdata   => tb_tdata9,
			m09_axi_stream_tstrb   => open,
			m09_axi_stream_tlast   => tb_tlast9,
			m09_axi_stream_tready  => tb_tready9,
			m09_axi_stream_tid     => tb_tid9,
			m10_axi_stream_aclk    => tb_clk,
			m10_axi_stream_aresetn => tb_resetn,
			m10_axi_stream_tvalid  => tb_tvalid10,
			m10_axi_stream_tdata   => tb_tdata10,
			m10_axi_stream_tstrb   => open,
			m10_axi_stream_tlast   => tb_tlast10,
			m10_axi_stream_tready  => tb_tready10,
			m10_axi_stream_tid     => tb_tid10,
			m11_axi_stream_aclk    => tb_clk,
			m11_axi_stream_aresetn => tb_resetn,
			m11_axi_stream_tvalid  => tb_tvalid11,
			m11_axi_stream_tdata   => tb_tdata11,
			m11_axi_stream_tstrb   => open,
			m11_axi_stream_tlast   => tb_tlast11,
			m11_axi_stream_tready  => tb_tready11,
			m11_axi_stream_tid     => tb_tid11,
			m12_axi_stream_aclk    => tb_clk,
			m12_axi_stream_aresetn => tb_resetn,
			m12_axi_stream_tvalid  => tb_tvalid12,
			m12_axi_stream_tdata   => tb_tdata12,
			m12_axi_stream_tstrb   => open,
			m12_axi_stream_tlast   => tb_tlast12,
			m12_axi_stream_tready  => tb_tready12,
			m12_axi_stream_tid     => tb_tid12,
			m13_axi_stream_aclk    => tb_clk,
			m13_axi_stream_aresetn => tb_resetn,
			m13_axi_stream_tvalid  => tb_tvalid13,
			m13_axi_stream_tdata   => tb_tdata13,
			m13_axi_stream_tstrb   => open,
			m13_axi_stream_tlast   => tb_tlast13,
			m13_axi_stream_tready  => tb_tready13,
			m13_axi_stream_tid     => tb_tid13,
			m14_axi_stream_aclk    => tb_clk,
			m14_axi_stream_aresetn => tb_resetn,
			m14_axi_stream_tvalid  => tb_tvalid14,
			m14_axi_stream_tdata   => tb_tdata14,
			m14_axi_stream_tstrb   => open,
			m14_axi_stream_tlast   => tb_tlast14,
			m14_axi_stream_tready  => tb_tready14,
			m14_axi_stream_tid     => tb_tid14,
			m15_axi_stream_aclk    => tb_clk,
			m15_axi_stream_aresetn => tb_resetn,
			m15_axi_stream_tvalid  => tb_tvalid15,
			m15_axi_stream_tdata   => tb_tdata15,
			m15_axi_stream_tstrb   => open,
			m15_axi_stream_tlast   => tb_tlast15,
			m15_axi_stream_tready  => tb_tready15,
			m15_axi_stream_tid     => tb_tid15
		);

	--PROCESO CLK: Generacion de reloj
	ref_clk : process
	begin
		while true loop
			tb_clk <= '1';
			wait for (CLK_PERIOD / 2);
			tb_clk <= '0';
			wait for (CLK_PERIOD / 2);
		end loop;
	end process;

	--Generacion de los estimulos
	process
	begin
		--Inicializacion de senales AXI STREAM
		tb_tready0  <= '1';
		tb_tready1  <= '1';
		tb_tready2  <= '1';
		tb_tready3  <= '1';
		tb_tready4  <= '1';
		tb_tready5  <= '1';
		tb_tready6  <= '1';
		tb_tready7  <= '1';
		tb_tready8  <= '1';
		tb_tready9  <= '1';
		tb_tready10 <= '1';
		tb_tready11 <= '1';
		tb_tready12 <= '1';
		tb_tready13 <= '1';
		tb_tready14 <= '1';
		tb_tready15 <= '1';

		--Inicializacion de senales AXI LITE
		tb_go      <= '0';
		tb_resetn  <= '1';
		tb_rnw     <= '0';
		tb_address <= REG0;
		tb_dato_w  <= X"00000000";
		wait for 6 * CLK_PERIOD;

		--Reseteo del periferico
		wait until falling_edge(tb_clk);
		tb_resetn <= '0';               --NOTA: SUPER IMPORTANTE ESTA ACTIVACION. SI SE HACE EN FASE CON EL FLANCO DE SUBIDA LA SIMULACION NO LO DETECTA
		wait for CLK_PERIOD;
		tb_resetn <= '1';               --      CORRECTAMENTE Y TANTO EL CIRCUITO DE RESET DE INTERFAZ AXI STREAM COMO DEL USR_LOGIC NO SE ENTERAN.
		wait until rising_edge(tb_clk);
		wait for 6 * CLK_PERIOD;

		--Establecimiento de valor inicial del contador
		wait until rising_edge(tb_clk);
		tb_address <= REG1;
		tb_dato_w  <= X"00000027";      -- CONTADOR INICIAL = 39
		tb_rnw     <= '0';
		tb_go      <= '1';
		wait for CLK_PERIOD;
		tb_go      <= '0';
		wait until tb_done = '1';
		wait for 10 * CLK_PERIOD;

		--Activacion del contador
		wait until rising_edge(tb_clk);
		tb_address <= REG0;
		tb_dato_w  <= X"80000000";      -- RUN
		tb_rnw     <= '0';
		tb_go      <= '1';
		wait for CLK_PERIOD;
		tb_go      <= '0';
		wait until tb_done = '1';
		wait for 50 * CLK_PERIOD;

		-- Generamos error de FIFO_FULL
		tb_tready0  <= '0';
		tb_tready1  <= '0';
		tb_tready2  <= '0';
		tb_tready3  <= '0';
		tb_tready4  <= '0';
		tb_tready5  <= '0';
		tb_tready6  <= '0';
		tb_tready7  <= '0';
		tb_tready8  <= '0';
		tb_tready9  <= '0';
		tb_tready10 <= '0';
		tb_tready11 <= '0';
		tb_tready12 <= '0';
		tb_tready13 <= '0';
		tb_tready14 <= '0';
		tb_tready15 <= '0';

		wait for 20 * CLK_PERIOD;

		--Establecimiento de un nuevo valor inicial del contador
		wait until rising_edge(tb_clk);
		tb_address <= REG1;
		tb_dato_w  <= X"FFFFFFAA";      -- CONTADOR INICIAL = -86
		tb_rnw     <= '0';
		tb_go      <= '1';
		wait for CLK_PERIOD;
		tb_go      <= '0';
		wait until tb_done = '1';
		wait for 10 * CLK_PERIOD;

		--Activacion del contador
		wait until rising_edge(tb_clk);
		tb_address <= REG0;
		tb_dato_w  <= X"80000000";      -- RUN
		tb_rnw     <= '0';
		tb_go      <= '1';
		wait for CLK_PERIOD;
		tb_go      <= '0';
		wait until tb_done = '1';
		wait for 50 * CLK_PERIOD;

		--Anulamos error de FIFO_FULL
		tb_tready0  <= '1';
		tb_tready1  <= '1';
		tb_tready2  <= '1';
		tb_tready3  <= '1';
		tb_tready4  <= '1';
		tb_tready5  <= '1';
		tb_tready6  <= '1';
		tb_tready7  <= '1';
		tb_tready8  <= '1';
		tb_tready9  <= '1';
		tb_tready10 <= '1';
		tb_tready11 <= '1';
		tb_tready12 <= '1';
		tb_tready13 <= '1';
		tb_tready14 <= '1';
		tb_tready15 <= '1';
		wait for 50 * CLK_PERIOD;

	end process;
end Behavioral;
