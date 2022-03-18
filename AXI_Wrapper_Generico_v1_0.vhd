library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI_Wrapper_Generico_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXI_FULL
		C_M00_AXI_FULL_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M00_AXI_FULL_BURST_LEN	: integer	:= 16;
		C_M00_AXI_FULL_ID_WIDTH	: integer	:= 1;
		C_M00_AXI_FULL_ADDR_WIDTH	: integer	:= 32;
		C_M00_AXI_FULL_DATA_WIDTH	: integer	:= 32;
		C_M00_AXI_FULL_AWUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_FULL_ARUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_FULL_WUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_FULL_RUSER_WIDTH	: integer	:= 0;
		C_M00_AXI_FULL_BUSER_WIDTH	: integer	:= 0;

		-- Parameters of Axi Slave Bus Interface S00_AXI_FULL
		C_S00_AXI_FULL_ID_WIDTH	: integer	:= 1;
		C_S00_AXI_FULL_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_FULL_ADDR_WIDTH	: integer	:= 6;
		C_S00_AXI_FULL_AWUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_FULL_ARUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_FULL_WUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_FULL_RUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_FULL_BUSER_WIDTH	: integer	:= 0
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Master Bus Interface M00_AXI_FULL
		m00_axi_full_init_axi_txn	: in std_logic;
		m00_axi_full_txn_done	: out std_logic;
		m00_axi_full_error	: out std_logic;
		m00_axi_full_aclk	: in std_logic;
		m00_axi_full_aresetn	: in std_logic;
		m00_axi_full_awid	: out std_logic_vector(C_M00_AXI_FULL_ID_WIDTH-1 downto 0);
		m00_axi_full_awaddr	: out std_logic_vector(C_M00_AXI_FULL_ADDR_WIDTH-1 downto 0);
		m00_axi_full_awlen	: out std_logic_vector(7 downto 0);
		m00_axi_full_awsize	: out std_logic_vector(2 downto 0);
		m00_axi_full_awburst	: out std_logic_vector(1 downto 0);
		m00_axi_full_awlock	: out std_logic;
		m00_axi_full_awcache	: out std_logic_vector(3 downto 0);
		m00_axi_full_awprot	: out std_logic_vector(2 downto 0);
		m00_axi_full_awqos	: out std_logic_vector(3 downto 0);
		m00_axi_full_awuser	: out std_logic_vector(C_M00_AXI_FULL_AWUSER_WIDTH-1 downto 0);
		m00_axi_full_awvalid	: out std_logic;
		m00_axi_full_awready	: in std_logic;
		m00_axi_full_wdata	: out std_logic_vector(C_M00_AXI_FULL_DATA_WIDTH-1 downto 0);
		m00_axi_full_wstrb	: out std_logic_vector(C_M00_AXI_FULL_DATA_WIDTH/8-1 downto 0);
		m00_axi_full_wlast	: out std_logic;
		m00_axi_full_wuser	: out std_logic_vector(C_M00_AXI_FULL_WUSER_WIDTH-1 downto 0);
		m00_axi_full_wvalid	: out std_logic;
		m00_axi_full_wready	: in std_logic;
		m00_axi_full_bid	: in std_logic_vector(C_M00_AXI_FULL_ID_WIDTH-1 downto 0);
		m00_axi_full_bresp	: in std_logic_vector(1 downto 0);
		m00_axi_full_buser	: in std_logic_vector(C_M00_AXI_FULL_BUSER_WIDTH-1 downto 0);
		m00_axi_full_bvalid	: in std_logic;
		m00_axi_full_bready	: out std_logic;
		m00_axi_full_arid	: out std_logic_vector(C_M00_AXI_FULL_ID_WIDTH-1 downto 0);
		m00_axi_full_araddr	: out std_logic_vector(C_M00_AXI_FULL_ADDR_WIDTH-1 downto 0);
		m00_axi_full_arlen	: out std_logic_vector(7 downto 0);
		m00_axi_full_arsize	: out std_logic_vector(2 downto 0);
		m00_axi_full_arburst	: out std_logic_vector(1 downto 0);
		m00_axi_full_arlock	: out std_logic;
		m00_axi_full_arcache	: out std_logic_vector(3 downto 0);
		m00_axi_full_arprot	: out std_logic_vector(2 downto 0);
		m00_axi_full_arqos	: out std_logic_vector(3 downto 0);
		m00_axi_full_aruser	: out std_logic_vector(C_M00_AXI_FULL_ARUSER_WIDTH-1 downto 0);
		m00_axi_full_arvalid	: out std_logic;
		m00_axi_full_arready	: in std_logic;
		m00_axi_full_rid	: in std_logic_vector(C_M00_AXI_FULL_ID_WIDTH-1 downto 0);
		m00_axi_full_rdata	: in std_logic_vector(C_M00_AXI_FULL_DATA_WIDTH-1 downto 0);
		m00_axi_full_rresp	: in std_logic_vector(1 downto 0);
		m00_axi_full_rlast	: in std_logic;
		m00_axi_full_ruser	: in std_logic_vector(C_M00_AXI_FULL_RUSER_WIDTH-1 downto 0);
		m00_axi_full_rvalid	: in std_logic;
		m00_axi_full_rready	: out std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXI_FULL
		s00_axi_full_aclk	: in std_logic;
		s00_axi_full_aresetn	: in std_logic;
		s00_axi_full_awid	: in std_logic_vector(C_S00_AXI_FULL_ID_WIDTH-1 downto 0);
		s00_axi_full_awaddr	: in std_logic_vector(C_S00_AXI_FULL_ADDR_WIDTH-1 downto 0);
		s00_axi_full_awlen	: in std_logic_vector(7 downto 0);
		s00_axi_full_awsize	: in std_logic_vector(2 downto 0);
		s00_axi_full_awburst	: in std_logic_vector(1 downto 0);
		s00_axi_full_awlock	: in std_logic;
		s00_axi_full_awcache	: in std_logic_vector(3 downto 0);
		s00_axi_full_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_full_awqos	: in std_logic_vector(3 downto 0);
		s00_axi_full_awregion	: in std_logic_vector(3 downto 0);
		s00_axi_full_awuser	: in std_logic_vector(C_S00_AXI_FULL_AWUSER_WIDTH-1 downto 0);
		s00_axi_full_awvalid	: in std_logic;
		s00_axi_full_awready	: out std_logic;
		s00_axi_full_wdata	: in std_logic_vector(C_S00_AXI_FULL_DATA_WIDTH-1 downto 0);
		s00_axi_full_wstrb	: in std_logic_vector((C_S00_AXI_FULL_DATA_WIDTH/8)-1 downto 0);
		s00_axi_full_wlast	: in std_logic;
		s00_axi_full_wuser	: in std_logic_vector(C_S00_AXI_FULL_WUSER_WIDTH-1 downto 0);
		s00_axi_full_wvalid	: in std_logic;
		s00_axi_full_wready	: out std_logic;
		s00_axi_full_bid	: out std_logic_vector(C_S00_AXI_FULL_ID_WIDTH-1 downto 0);
		s00_axi_full_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_full_buser	: out std_logic_vector(C_S00_AXI_FULL_BUSER_WIDTH-1 downto 0);
		s00_axi_full_bvalid	: out std_logic;
		s00_axi_full_bready	: in std_logic;
		s00_axi_full_arid	: in std_logic_vector(C_S00_AXI_FULL_ID_WIDTH-1 downto 0);
		s00_axi_full_araddr	: in std_logic_vector(C_S00_AXI_FULL_ADDR_WIDTH-1 downto 0);
		s00_axi_full_arlen	: in std_logic_vector(7 downto 0);
		s00_axi_full_arsize	: in std_logic_vector(2 downto 0);
		s00_axi_full_arburst	: in std_logic_vector(1 downto 0);
		s00_axi_full_arlock	: in std_logic;
		s00_axi_full_arcache	: in std_logic_vector(3 downto 0);
		s00_axi_full_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_full_arqos	: in std_logic_vector(3 downto 0);
		s00_axi_full_arregion	: in std_logic_vector(3 downto 0);
		s00_axi_full_aruser	: in std_logic_vector(C_S00_AXI_FULL_ARUSER_WIDTH-1 downto 0);
		s00_axi_full_arvalid	: in std_logic;
		s00_axi_full_arready	: out std_logic;
		s00_axi_full_rid	: out std_logic_vector(C_S00_AXI_FULL_ID_WIDTH-1 downto 0);
		s00_axi_full_rdata	: out std_logic_vector(C_S00_AXI_FULL_DATA_WIDTH-1 downto 0);
		s00_axi_full_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_full_rlast	: out std_logic;
		s00_axi_full_ruser	: out std_logic_vector(C_S00_AXI_FULL_RUSER_WIDTH-1 downto 0);
		s00_axi_full_rvalid	: out std_logic;
		s00_axi_full_rready	: in std_logic
	);
end AXI_Wrapper_Generico_v1_0;

architecture arch_imp of AXI_Wrapper_Generico_v1_0 is

	-- component declaration
	component AXI_Wrapper_Generico_v1_0_M00_AXI_FULL is
		generic (
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_AXI_BURST_LEN	: integer	:= 16;
		C_M_AXI_ID_WIDTH	: integer	:= 1;
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		C_M_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_M_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_M_AXI_WUSER_WIDTH	: integer	:= 0;
		C_M_AXI_RUSER_WIDTH	: integer	:= 0;
		C_M_AXI_BUSER_WIDTH	: integer	:= 0
		);
		port (
		INIT_AXI_TXN	: in std_logic;
		TXN_DONE	: out std_logic;
		ERROR	: out std_logic;
		M_AXI_ACLK	: in std_logic;
		M_AXI_ARESETN	: in std_logic;
		M_AXI_AWID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWLEN	: out std_logic_vector(7 downto 0);
		M_AXI_AWSIZE	: out std_logic_vector(2 downto 0);
		M_AXI_AWBURST	: out std_logic_vector(1 downto 0);
		M_AXI_AWLOCK	: out std_logic;
		M_AXI_AWCACHE	: out std_logic_vector(3 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWQOS	: out std_logic_vector(3 downto 0);
		M_AXI_AWUSER	: out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WLAST	: out std_logic;
		M_AXI_WUSER	: out std_logic_vector(C_M_AXI_WUSER_WIDTH-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		M_AXI_BUSER	: in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARLEN	: out std_logic_vector(7 downto 0);
		M_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
		M_AXI_ARBURST	: out std_logic_vector(1 downto 0);
		M_AXI_ARLOCK	: out std_logic;
		M_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARQOS	: out std_logic_vector(3 downto 0);
		M_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		M_AXI_RLAST	: in std_logic;
		M_AXI_RUSER	: in std_logic_vector(C_M_AXI_RUSER_WIDTH-1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic
		);
	end component AXI_Wrapper_Generico_v1_0_M00_AXI_FULL;

	component AXI_Wrapper_Generico_v1_0_S00_AXI_FULL is
		generic (
		C_S_AXI_ID_WIDTH	: integer	:= 1;
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6;
		C_S_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S_AXI_BUSER_WIDTH	: integer	:= 0
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWID	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWLEN	: in std_logic_vector(7 downto 0);
		S_AXI_AWSIZE	: in std_logic_vector(2 downto 0);
		S_AXI_AWBURST	: in std_logic_vector(1 downto 0);
		S_AXI_AWLOCK	: in std_logic;
		S_AXI_AWCACHE	: in std_logic_vector(3 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWQOS	: in std_logic_vector(3 downto 0);
		S_AXI_AWREGION	: in std_logic_vector(3 downto 0);
		S_AXI_AWUSER	: in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WLAST	: in std_logic;
		S_AXI_WUSER	: in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BID	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BUSER	: out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARID	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARLEN	: in std_logic_vector(7 downto 0);
		S_AXI_ARSIZE	: in std_logic_vector(2 downto 0);
		S_AXI_ARBURST	: in std_logic_vector(1 downto 0);
		S_AXI_ARLOCK	: in std_logic;
		S_AXI_ARCACHE	: in std_logic_vector(3 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARQOS	: in std_logic_vector(3 downto 0);
		S_AXI_ARREGION	: in std_logic_vector(3 downto 0);
		S_AXI_ARUSER	: in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RID	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RLAST	: out std_logic;
		S_AXI_RUSER	: out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component AXI_Wrapper_Generico_v1_0_S00_AXI_FULL;

begin

-- Instantiation of Axi Bus Interface M00_AXI_FULL
AXI_Wrapper_Generico_v1_0_M00_AXI_FULL_inst : AXI_Wrapper_Generico_v1_0_M00_AXI_FULL
	generic map (
		C_M_TARGET_SLAVE_BASE_ADDR	=> C_M00_AXI_FULL_TARGET_SLAVE_BASE_ADDR,
		C_M_AXI_BURST_LEN	=> C_M00_AXI_FULL_BURST_LEN,
		C_M_AXI_ID_WIDTH	=> C_M00_AXI_FULL_ID_WIDTH,
		C_M_AXI_ADDR_WIDTH	=> C_M00_AXI_FULL_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH	=> C_M00_AXI_FULL_DATA_WIDTH,
		C_M_AXI_AWUSER_WIDTH	=> C_M00_AXI_FULL_AWUSER_WIDTH,
		C_M_AXI_ARUSER_WIDTH	=> C_M00_AXI_FULL_ARUSER_WIDTH,
		C_M_AXI_WUSER_WIDTH	=> C_M00_AXI_FULL_WUSER_WIDTH,
		C_M_AXI_RUSER_WIDTH	=> C_M00_AXI_FULL_RUSER_WIDTH,
		C_M_AXI_BUSER_WIDTH	=> C_M00_AXI_FULL_BUSER_WIDTH
	)
	port map (
		INIT_AXI_TXN	=> m00_axi_full_init_axi_txn,
		TXN_DONE	=> m00_axi_full_txn_done,
		ERROR	=> m00_axi_full_error,
		M_AXI_ACLK	=> m00_axi_full_aclk,
		M_AXI_ARESETN	=> m00_axi_full_aresetn,
		M_AXI_AWID	=> m00_axi_full_awid,
		M_AXI_AWADDR	=> m00_axi_full_awaddr,
		M_AXI_AWLEN	=> m00_axi_full_awlen,
		M_AXI_AWSIZE	=> m00_axi_full_awsize,
		M_AXI_AWBURST	=> m00_axi_full_awburst,
		M_AXI_AWLOCK	=> m00_axi_full_awlock,
		M_AXI_AWCACHE	=> m00_axi_full_awcache,
		M_AXI_AWPROT	=> m00_axi_full_awprot,
		M_AXI_AWQOS	=> m00_axi_full_awqos,
		M_AXI_AWUSER	=> m00_axi_full_awuser,
		M_AXI_AWVALID	=> m00_axi_full_awvalid,
		M_AXI_AWREADY	=> m00_axi_full_awready,
		M_AXI_WDATA	=> m00_axi_full_wdata,
		M_AXI_WSTRB	=> m00_axi_full_wstrb,
		M_AXI_WLAST	=> m00_axi_full_wlast,
		M_AXI_WUSER	=> m00_axi_full_wuser,
		M_AXI_WVALID	=> m00_axi_full_wvalid,
		M_AXI_WREADY	=> m00_axi_full_wready,
		M_AXI_BID	=> m00_axi_full_bid,
		M_AXI_BRESP	=> m00_axi_full_bresp,
		M_AXI_BUSER	=> m00_axi_full_buser,
		M_AXI_BVALID	=> m00_axi_full_bvalid,
		M_AXI_BREADY	=> m00_axi_full_bready,
		M_AXI_ARID	=> m00_axi_full_arid,
		M_AXI_ARADDR	=> m00_axi_full_araddr,
		M_AXI_ARLEN	=> m00_axi_full_arlen,
		M_AXI_ARSIZE	=> m00_axi_full_arsize,
		M_AXI_ARBURST	=> m00_axi_full_arburst,
		M_AXI_ARLOCK	=> m00_axi_full_arlock,
		M_AXI_ARCACHE	=> m00_axi_full_arcache,
		M_AXI_ARPROT	=> m00_axi_full_arprot,
		M_AXI_ARQOS	=> m00_axi_full_arqos,
		M_AXI_ARUSER	=> m00_axi_full_aruser,
		M_AXI_ARVALID	=> m00_axi_full_arvalid,
		M_AXI_ARREADY	=> m00_axi_full_arready,
		M_AXI_RID	=> m00_axi_full_rid,
		M_AXI_RDATA	=> m00_axi_full_rdata,
		M_AXI_RRESP	=> m00_axi_full_rresp,
		M_AXI_RLAST	=> m00_axi_full_rlast,
		M_AXI_RUSER	=> m00_axi_full_ruser,
		M_AXI_RVALID	=> m00_axi_full_rvalid,
		M_AXI_RREADY	=> m00_axi_full_rready
	);

-- Instantiation of Axi Bus Interface S00_AXI_FULL
AXI_Wrapper_Generico_v1_0_S00_AXI_FULL_inst : AXI_Wrapper_Generico_v1_0_S00_AXI_FULL
	generic map (
		C_S_AXI_ID_WIDTH	=> C_S00_AXI_FULL_ID_WIDTH,
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_FULL_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_FULL_ADDR_WIDTH,
		C_S_AXI_AWUSER_WIDTH	=> C_S00_AXI_FULL_AWUSER_WIDTH,
		C_S_AXI_ARUSER_WIDTH	=> C_S00_AXI_FULL_ARUSER_WIDTH,
		C_S_AXI_WUSER_WIDTH	=> C_S00_AXI_FULL_WUSER_WIDTH,
		C_S_AXI_RUSER_WIDTH	=> C_S00_AXI_FULL_RUSER_WIDTH,
		C_S_AXI_BUSER_WIDTH	=> C_S00_AXI_FULL_BUSER_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_full_aclk,
		S_AXI_ARESETN	=> s00_axi_full_aresetn,
		S_AXI_AWID	=> s00_axi_full_awid,
		S_AXI_AWADDR	=> s00_axi_full_awaddr,
		S_AXI_AWLEN	=> s00_axi_full_awlen,
		S_AXI_AWSIZE	=> s00_axi_full_awsize,
		S_AXI_AWBURST	=> s00_axi_full_awburst,
		S_AXI_AWLOCK	=> s00_axi_full_awlock,
		S_AXI_AWCACHE	=> s00_axi_full_awcache,
		S_AXI_AWPROT	=> s00_axi_full_awprot,
		S_AXI_AWQOS	=> s00_axi_full_awqos,
		S_AXI_AWREGION	=> s00_axi_full_awregion,
		S_AXI_AWUSER	=> s00_axi_full_awuser,
		S_AXI_AWVALID	=> s00_axi_full_awvalid,
		S_AXI_AWREADY	=> s00_axi_full_awready,
		S_AXI_WDATA	=> s00_axi_full_wdata,
		S_AXI_WSTRB	=> s00_axi_full_wstrb,
		S_AXI_WLAST	=> s00_axi_full_wlast,
		S_AXI_WUSER	=> s00_axi_full_wuser,
		S_AXI_WVALID	=> s00_axi_full_wvalid,
		S_AXI_WREADY	=> s00_axi_full_wready,
		S_AXI_BID	=> s00_axi_full_bid,
		S_AXI_BRESP	=> s00_axi_full_bresp,
		S_AXI_BUSER	=> s00_axi_full_buser,
		S_AXI_BVALID	=> s00_axi_full_bvalid,
		S_AXI_BREADY	=> s00_axi_full_bready,
		S_AXI_ARID	=> s00_axi_full_arid,
		S_AXI_ARADDR	=> s00_axi_full_araddr,
		S_AXI_ARLEN	=> s00_axi_full_arlen,
		S_AXI_ARSIZE	=> s00_axi_full_arsize,
		S_AXI_ARBURST	=> s00_axi_full_arburst,
		S_AXI_ARLOCK	=> s00_axi_full_arlock,
		S_AXI_ARCACHE	=> s00_axi_full_arcache,
		S_AXI_ARPROT	=> s00_axi_full_arprot,
		S_AXI_ARQOS	=> s00_axi_full_arqos,
		S_AXI_ARREGION	=> s00_axi_full_arregion,
		S_AXI_ARUSER	=> s00_axi_full_aruser,
		S_AXI_ARVALID	=> s00_axi_full_arvalid,
		S_AXI_ARREADY	=> s00_axi_full_arready,
		S_AXI_RID	=> s00_axi_full_rid,
		S_AXI_RDATA	=> s00_axi_full_rdata,
		S_AXI_RRESP	=> s00_axi_full_rresp,
		S_AXI_RLAST	=> s00_axi_full_rlast,
		S_AXI_RUSER	=> s00_axi_full_ruser,
		S_AXI_RVALID	=> s00_axi_full_rvalid,
		S_AXI_RREADY	=> s00_axi_full_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
