// define
`include "./AXI_define.svh"
// Interface
`include "./Interface/AXI/AXI_S_IF.sv"
`include "./Interface/AXI/AXI_M_IF.sv"
// ASYN_FIFO
`include "./ASYN_FIFO/ASYN_FIFO.sv"
`include "./ASYN_FIFO/FIFO_MEM.sv"
`include "./ASYN_FIFO/2DFF.sv"
// Decoder
`include "./Decoder/AXI_Decoder.sv"
// Arbiter
`include "./Arbiter/P_Arbiter.sv"

module AXI (
  input logic                       CPU_CLK_i,      
  input logic                       AXI_CLK_i,        
  input logic                       ROM_CLK_i,      
  input logic                       DRAM_CLK_i,
  input logic                       SRAM_CLK_i,
  input logic                       CPU_RST_i,      
  input logic                       AXI_RST_i,        
  input logic                       ROM_RST_i,      
  input logic                       DRAM_RST_i,
  input logic                       SRAM_RST_i,                  
  // MASTER INTERFACE
  // M0
  // READ
  input  logic [`AXI_ID_BITS-1:0]   ARID_M0_i,
  input  logic [`AXI_ADDR_BITS-1:0] ARADDR_M0_i,
  input  logic [`AXI_LEN_BITS-1:0]  ARLEN_M0_i,
  input  logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0_i,
  input  logic [1:0]                ARBURST_M0_i,
  input  logic                      ARVALID_M0_i,
  output logic                      ARREADY_M0_o,
  output logic [`AXI_ID_BITS-1:0]   RID_M0_o,
  output logic [`AXI_DATA_BITS-1:0] RDATA_M0_o,
  output logic [1:0]                RRESP_M0_o,
  output logic                      RLAST_M0_o,
  output logic                      RVALID_M0_o,
  input  logic                      RREADY_M0_i,
  // M1
  // WRITE
  input  logic[`AXI_ID_BITS-1:0]    AWID_M1_i,
  input  logic[`AXI_ADDR_BITS-1:0]  AWADDR_M1_i,
  input  logic[`AXI_LEN_BITS-1:0]   AWLEN_M1_i,
  input  logic[`AXI_SIZE_BITS-1:0]  AWSIZE_M1_i,
  input  logic[1:0]                 AWBURST_M1_i,
  input  logic                      AWVALID_M1_i,
  output logic                      AWREADY_M1_o,
  input  logic [`AXI_DATA_BITS-1:0] WDATA_M1_i,
  input  logic [`AXI_STRB_BITS-1:0] WSTRB_M1_i,
  input  logic                      WLAST_M1_i,
  input  logic                      WVALID_M1_i,
  output logic                      WREADY_M1_o,
  output logic [`AXI_ID_BITS-1:0]   BID_M1_o,
  output logic [1:0]                BRESP_M1_o,
  output logic                      BVALID_M1_o,
  input  logic                      BREADY_M1_i,
  // READ
  input  logic [`AXI_ID_BITS-1:0]   ARID_M1_i,
  input  logic [`AXI_ADDR_BITS-1:0] ARADDR_M1_i,
  input  logic [`AXI_LEN_BITS-1:0]  ARLEN_M1_i,
  input  logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1_i,
  input  logic [1:0]                ARBURST_M1_i,
  input  logic                      ARVALID_M1_i,
  output logic                      ARREADY_M1_o,
  output logic [`AXI_ID_BITS-1:0]   RID_M1_o,
  output logic [`AXI_DATA_BITS-1:0] RDATA_M1_o,
  output logic [1:0]                RRESP_M1_o,
  output logic                      RLAST_M1_o,
  output logic                      RVALID_M1_o,
  input  logic                      RREADY_M1_i,
  // SLAVE INTERFACE
  // S0
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S0_o,
  output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S0_o,
  output logic[`AXI_LEN_BITS-1:0]   ARLEN_S0_o,
  output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S0_o,
  output logic[1:0]                 ARBURST_S0_o,
  output logic                      ARVALID_S0_o,
  input  logic                      ARREADY_S0_i,
  input  logic[`AXI_IDS_BITS-1:0]   RID_S0_i,
  input  logic[`AXI_DATA_BITS-1:0]  RDATA_S0_i,
  input  logic[1:0]                 RRESP_S0_i,
  input  logic                      RLAST_S0_i,
  input  logic                      RVALID_S0_i,
  output logic                      RREADY_S0_o,
  // S1
  // WRITE
  output logic [`AXI_IDS_BITS-1:0]  AWID_S1_o,
  output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S1_o,
  output logic[`AXI_LEN_BITS-1:0]   AWLEN_S1_o,
  output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S1_o,
  output logic[1:0]                 AWBURST_S1_o,
  output logic                      AWVALID_S1_o,
  input  logic                      AWREADY_S1_i,
  output logic [`AXI_DATA_BITS-1:0] WDATA_S1_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_S1_o,
  output logic                      WLAST_S1_o,
  output logic                      WVALID_S1_o,
  input  logic                      WREADY_S1_i,
  input  logic[`AXI_IDS_BITS-1:0]   BID_S1_i,
  input  logic[1:0]                 BRESP_S1_i,
  input  logic                      BVALID_S1_i,
  output logic                      BREADY_S1_o,
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S1_o,
  output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S1_o,
  output logic[`AXI_LEN_BITS-1:0]   ARLEN_S1_o,
  output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S1_o,
  output logic[1:0]                 ARBURST_S1_o,
  output logic                      ARVALID_S1_o,
  input  logic                      ARREADY_S1_i,
  input  logic[`AXI_IDS_BITS-1:0]   RID_S1_i,
  input  logic[`AXI_DATA_BITS-1:0]  RDATA_S1_i,
  input  logic[1:0]                 RRESP_S1_i,
  input  logic                      RLAST_S1_i,
  input  logic                      RVALID_S1_i,
  output logic                      RREADY_S1_o,
  // S2
  // WRITE
  output logic [`AXI_IDS_BITS-1:0]  AWID_S2_o,
  output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S2_o,
  output logic[`AXI_LEN_BITS-1:0]   AWLEN_S2_o,
  output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S2_o,
  output logic[1:0]                 AWBURST_S2_o,
  output logic                      AWVALID_S2_o,
  input  logic                      AWREADY_S2_i,
  output logic [`AXI_DATA_BITS-1:0] WDATA_S2_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_S2_o,
  output logic                      WLAST_S2_o,
  output logic                      WVALID_S2_o,
  input  logic                      WREADY_S2_i,
  input  logic [`AXI_IDS_BITS-1:0]  BID_S2_i,
  input  logic [1:0]                BRESP_S2_i,
  input  logic                      BVALID_S2_i,
  output logic                      BREADY_S2_o,
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S2_o,
  output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S2_o,
  output logic[`AXI_LEN_BITS-1:0]   ARLEN_S2_o,
  output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S2_o,
  output logic [1:0]                ARBURST_S2_o,
  output logic                      ARVALID_S2_o,
  input  logic                      ARREADY_S2_i,
  input  logic[`AXI_IDS_BITS-1:0]   RID_S2_i,
  input  logic[`AXI_DATA_BITS-1:0]  RDATA_S2_i,
  input  logic[1:0]                 RRESP_S2_i,
  input  logic                      RLAST_S2_i,
  input  logic                      RVALID_S2_i,
  output logic                      RREADY_S2_o,
  // S3
  // WRITE
  output logic [`AXI_IDS_BITS-1:0]  AWID_S3_o,
  output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3_o,
  output logic [`AXI_LEN_BITS-1:0]  AWLEN_S3_o,
  output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3_o,
  output logic [1:0]                AWBURST_S3_o,
  output logic                      AWVALID_S3_o,
  input  logic                      AWREADY_S3_i,
  output logic [`AXI_DATA_BITS-1:0] WDATA_S3_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_S3_o,
  output logic                      WLAST_S3_o,
  output logic                      WVALID_S3_o,
  input  logic                      WREADY_S3_i,
  input  logic [`AXI_IDS_BITS-1:0]  BID_S3_i,
  input  logic [1:0]                BRESP_S3_i,
  input  logic                      BVALID_S3_i,
  output logic                      BREADY_S3_o,
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S3_o,
  output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3_o,
  output logic [`AXI_LEN_BITS-1:0]  ARLEN_S3_o,
  output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3_o,
  output logic [1:0]                ARBURST_S3_o,
  output logic                      ARVALID_S3_o,
  input  logic                      ARREADY_S3_i,
  input  logic [`AXI_IDS_BITS-1:0]  RID_S3_i,
  input  logic [`AXI_DATA_BITS-1:0] RDATA_S3_i,
  input  logic [1:0]                RRESP_S3_i,
  input  logic                      RLAST_S3_i,
  input  logic                      RVALID_S3_i,
  output logic                      RREADY_S3_o,
  // S4
  // WRITE
  output logic [`AXI_IDS_BITS-1:0]  AWID_S4_o,
  output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S4_o,
  output logic[`AXI_LEN_BITS-1:0]   AWLEN_S4_o,
  output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S4_o,
  output logic[1:0]                 AWBURST_S4_o,
  output logic                      AWVALID_S4_o,
  input  logic                      AWREADY_S4_i,
  output logic [`AXI_DATA_BITS-1:0] WDATA_S4_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_S4_o,
  output logic                      WLAST_S4_o,
  output logic                      WVALID_S4_o,
  input  logic                      WREADY_S4_i,
  input  logic[`AXI_IDS_BITS-1:0]   BID_S4_i,
  input  logic[1:0]                 BRESP_S4_i,
  input  logic                      BVALID_S4_i,
  output logic                      BREADY_S4_o,
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S4_o,
  output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S4_o,
  output logic[`AXI_LEN_BITS-1:0]   ARLEN_S4_o,
  output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S4_o,
  output logic[1:0]                 ARBURST_S4_o,
  output logic                      ARVALID_S4_o,
  input  logic                      ARREADY_S4_i,
  input  logic[`AXI_IDS_BITS-1:0]   RID_S4_i,
  input  logic[`AXI_DATA_BITS-1:0]  RDATA_S4_i,
  input  logic[1:0]                 RRESP_S4_i,
  input  logic                      RLAST_S4_i,
  input  logic                      RVALID_S4_i,
  output logic                      RREADY_S4_o,
  // S5
  // WRITE
  output logic [`AXI_IDS_BITS-1:0]  AWID_S5_o,
  output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5_o,
  output logic [`AXI_LEN_BITS-1:0]  AWLEN_S5_o,
  output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5_o,
  output logic [1:0]                AWBURST_S5_o,
  output logic                      AWVALID_S5_o,
  input  logic                      AWREADY_S5_i,
  output logic [`AXI_DATA_BITS-1:0] WDATA_S5_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_S5_o,
  output logic                      WLAST_S5_o,
  output logic                      WVALID_S5_o,
  input  logic                      WREADY_S5_i,
  input  logic [`AXI_IDS_BITS-1:0]  BID_S5_i,
  input  logic [1:0]                BRESP_S5_i,
  input  logic                      BVALID_S5_i,
  output logic                      BREADY_S5_o,
  // READ
  output logic [`AXI_IDS_BITS-1:0]  ARID_S5_o,
  output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5_o,
  output logic [`AXI_LEN_BITS-1:0]  ARLEN_S5_o,
  output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5_o,
  output logic [1:0]                ARBURST_S5_o,
  output logic                      ARVALID_S5_o,
  input  logic                      ARREADY_S5_i,
  input  logic [`AXI_IDS_BITS-1:0]  RID_S5_i,
  input  logic [`AXI_DATA_BITS-1:0] RDATA_S5_i,
  input  logic [1:0]                RRESP_S5_i,
  input  logic                      RLAST_S5_i,
  input  logic                      RVALID_S5_i,
  output logic                      RREADY_S5_o
  
); 

  logic [5:0]  M0_AR_VALID;
  logic [5:0]  M0_AW_VALID;
  logic [5:0]  M0_W_VALID;
  logic [48:0] M0_AR_DATA;
  logic [48:0] M0_AW_DATA;
  logic [36:0] M0_W_DATA;

  logic [5:0]  M1_AR_VALID;
  logic [5:0]  M1_AW_VALID;
  logic [5:0]  M1_W_VALID;
  logic [48:0] M1_AR_DATA;
  logic [48:0] M1_AW_DATA;
  logic [36:0] M1_W_DATA;

  AXI_S_IF #(4'd0) AXI_S_IF_S0 (
    /* input */
    .CPU_CLK_i(CPU_CLK_i),
    .CPU_RST_i(CPU_RST_i),
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .ARID_i(ARID_M0_i),
    .ARADDR_i(ARADDR_M0_i),
    .ARLEN_i(ARLEN_M0_i),
    .ARSIZE_i(ARSIZE_M0_i),
    .ARBURST_i(ARBURST_M0_i),
    .ARVALID_i(ARVALID_M0_i),
    .RREADY_i(RREADY_M0_i),
    .AWID_i(4'd0),
    .AWADDR_i(32'd0),
    .AWLEN_i(4'd0),
    .AWSIZE_i(3'd0),
    .AWBURST_i(2'd0),
    .AWVALID_i(1'b0),
    .WDATA_i(32'd0),
    .WSTRB_i(4'b1111),
    .WLAST_i(1'b0),
    .WVALID_i(1'b0),
    .BREADY_i(1'b0),
    /* output */
    .ARREADY_o(ARREADY_M0_o),
    .RID_o(RID_M0_o),
    .RDATA_o(RDATA_M0_o),
    .RRESP_o(RRESP_M0_o),
    .RLAST_o(RLAST_M0_o),
    .RVALID_o(RVALID_M0_o),
    
    .M_AR_VALID(M0_AR_VALID),
    .M_AW_VALID(M0_AW_VALID),
    .M_W_VALID(M0_W_VALID),
    .M_AR_DATA(M0_AR_DATA),
    .M_AW_DATA(M0_AW_DATA),
    .M_W_DATA(M0_W_DATA)
  );

  AXI_S_IF #(4'd1) AXI_S_IF_S1 (
    /* input */
    .CPU_CLK_i(CPU_CLK_i),
    .CPU_RST_i(CPU_RST_i),
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .ARID_i(ARID_M1_i),
    .ARADDR_i(ARADDR_M1_i),
    .ARLEN_i(ARLEN_M1_i),
    .ARSIZE_i(ARSIZE_M1_i),
    .ARBURST_i(ARBURST_M1_i),
    .ARVALID_i(ARVALID_M1_i),
    .RREADY_i(RREADY_M1_i),
    .AWID_i(AWID_M1_i),
    .AWADDR_i(AWADDR_M1_i),
    .AWLEN_i(AWLEN_M1_i),
    .AWSIZE_i(AWSIZE_M1_i),
    .AWBURST_i(AWBURST_M1_i),
    .AWVALID_i(AWVALID_M1_i),
    .WDATA_i(WDATA_M1_i),
    .WSTRB_i(WSTRB_M1_i),
    .WLAST_i(WLAST_M1_i),
    .WVALID_i(WVALID_M1_i),
    .BREADY_i(BREADY_M1_i),
    /* output */
    .ARREADY_o(ARREADY_M1_o),
    .RID_o(RID_M1_o),
    .RDATA_o(RDATA_M1_o),
    .RRESP_o(RRESP_M1_o),
    .RLAST_o(RLAST_M1_o),
    .RVALID_o(RVALID_M1_o),
    .AWREADY_o(AWREADY_M1_o),
    .WREADY_o(WREADY_M1_o),
    .BID_o(BID_M1_o),
    .BRESP_o(BRESP_M1_o),
    .BVALID_o(BVALID_M1_o),

    .M_AR_VALID(M1_AR_VALID),
    .M_AW_VALID(M1_AW_VALID),
    .M_W_VALID(M1_W_VALID),
    .M_AR_DATA(M1_AR_DATA),
    .M_AW_DATA(M1_AW_DATA),
    .M_W_DATA(M1_W_DATA)
  );


  AXI_M_IF AXI_M_IF_M0 ();
  AXI_M_IF AXI_M_IF_M1 ();  
  AXI_M_IF AXI_M_IF_M2 ();
  AXI_M_IF AXI_M_IF_M3 ();
  AXI_M_IF AXI_M_IF_M4 ();
  AXI_M_IF AXI_M_IF_M5 ();

endmodule
