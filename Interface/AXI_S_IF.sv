module AXI_S_IF (

  /* input */
  input logic CPU_CLK_i,
  input logic CPU_RST_i,
  input logic AXI_CLK_i,
  input logic AXI_RST_i,

  input logic [`AXI_ID_BITS-1:0]    ARID_i,    // 4-bit
  input logic [`AXI_ADDR_BITS-1:0]  ARADDR_i,  // 32-bit
  input logic [`AXI_LEN_BITS-1:0]   ARLEN_i,   // 4-bit
  input logic [`AXI_SIZE_BITS-1:0]  ARSIZE_i,  // 3-bit
  input logic [1:0]                 ARBURST_i, // 2-bit
  input logic                       ARVALID_i,

  input logic                       RREADY_i,

  input logic [`AXI_ID_BITS-1:0]    AWID_i,    // 4-bit
  input logic [`AXI_ADDR_BITS-1:0]  AWADDR_i,  // 32-bit
  input logic [`AXI_LEN_BITS-1:0]   AWLEN_i,   // 4-bit
  input logic [`AXI_SIZE_BITS-1:0]  AWSIZE_i,  // 3-bit
  input logic [1:0]                 AWBURST_i, // 2-bit
  input logic                       AWVALID_i,

  input  logic [`AXI_DATA_BITS-1:0] WDATA_i,   // 32-bit
  input  logic [`AXI_STRB_BITS-1:0] WSTRB_i,   // 4-bit
  input  logic                      WLAST_i,
  input  logic                      WVALID_i,

  input  logic                      BREADY_i,

  /* output */
  output logic                      ARREADY_o,

  output logic [`AXI_ID_BITS-1:0]   RID_o,     // 4-bit
  output logic [`AXI_DATA_BITS-1:0] RDATA_o,   // 32-bit
  output logic [1:0]                RRESP_o,   // 2-bit
  output logic                      RLAST_o,
  output logic                      RVALID_o,

  output logic                      AWREADY_o,

  output logic                      WREADY_o,

  output logic [`AXI_ID_BITS-1:0]   BID_o,     // 4-bit
  output logic [1:0]                BRESP_o,   // 2-bit
  output logic                      BVALID_o,

);

  // #(DATA_SIZE, ADDR_SIZE)
  ASYN_FIFO #() AR_FIFO();
  ASYN_FIFO #() AW_FIFO();
  ASYN_FIFO #() W_FIFO();
  ASYN_FIFO #() R_FIFO();
  ASYN_FIFO #() B_FIFO();

endmodule