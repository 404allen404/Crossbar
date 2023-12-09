module AXI_M_IF (

  /* input */ 
  input logic                       AXI_CLK_i,
  input logic                       AXI_RST_i,
  input logic                       S_CLK_i,
  input logic                       S_RST_i,

  input logic                       M0_AR_FIFO_VALID;
  input logic                       M0_AW_FIFO_VALID;
  input logic                       M0_W_FIFO_VALID;
  input logic                       M1_AR_FIFO_VALID;
  input logic                       M1_AW_FIFO_VALID;
  input logic                       M1_W_FIFO_VALID;

  input logic [48:0]                M0_AR_FIFO_DATA;
  input logic [48:0]                M0_AW_FIFO_DATA;
  input logic [36:0]                M0_W_FIFO_DATA;
  input logic [48:0]                M1_AR_FIFO_DATA;
  input logic [48:0]                M1_AW_FIFO_DATA;
  input logic [36:0]                M1_W_FIFO_DATA;

  input  logic                      AWREADY_i,

  input  logic                      WREADY_i,

  input  logic [`AXI_IDS_BITS-1:0]  BID_i,
  input  logic [1:0]                BRESP_i,
  input  logic                      BVALID_i,

  input  logic                      ARREADY_i,

  input  logic [`AXI_IDS_BITS-1:0]  RID_i,
  input  logic [`AXI_DATA_BITS-1:0] RDATA_i,
  input  logic [1:0]                RRESP_i,
  input  logic                      RLAST_i,
  input  logic                      RVALID_i,

  /* output */

  output logic [`AXI_IDS_BITS-1:0]  AWID_o,
  output logic [`AXI_ADDR_BITS-1:0] AWADDR_o,
  output logic [`AXI_LEN_BITS-1:0]  AWLEN_o,
  output logic [`AXI_SIZE_BITS-1:0] AWSIZE_o,
  output logic [1:0]                AWBURST_o,
  output logic                      AWVALID_o,

  output logic [`AXI_IDS_BITS-1:0]  ARID_o,
  output logic [`AXI_ADDR_BITS-1:0] ARADDR_o,
  output logic [`AXI_LEN_BITS-1:0]  ARLEN_o,
  output logic [`AXI_SIZE_BITS-1:0] ARSIZE_o,
  output logic [1:0]                ARBURST_o,
  output logic                      ARVALID_o,

  output logic                      RREADY_o,

  output logic [`AXI_DATA_BITS-1:0] WDATA_o,
  output logic [`AXI_STRB_BITS-1:0] WSTRB_o,
  output logic                      WLAST_o,
  output logic                      WVALID_o,

  output logic                      BREADY_o,

);

  logic ar_wfull;
  logic aw_wfull;
  logic w_wfull;

  logic ar_rempty;
  logic aw_rempty;
  logic w_rempty;

  logic [48:0] ar_wdata;
  logic [48:0] aw_wdata;
  logic [36:0] w_wdata;

  logic ar_out_valid;
  logic aw_out_valid;
  logic w_out_valid;

  ASYN_FIFO #(49, 3) AR_FIFO (
    /* input */
    .wclk(AXI_CLK_i),
    .wrst(AXI_RST_i),
    .rclk(S_CLK_i),
    .rrst(S_RST_i),
    .wpush(AR_FIFO_VALID),
    .wdata(AR_FIFO_DATA),
    .rpop(ARREADY_i),
    /* output */
    .wfull(ar_wfull),
    .rempty(ar_rempty),
    .rdata(ar_rdata)
  );

  ASYN_FIFO #(49, 3) AW_FIFO (
    /* input */
    .wclk(AXI_CLK_i),
    .wrst(AXI_RST_i),
    .rclk(S_CLK_i),
    .rrst(S_RST_i),
    .wpush(),
    .wdata(),
    .rpop(),
    /* output */
    .wfull(),
    .rempty(),
    .rdata()
  );

  ASYN_FIFO #(37, 3) W_FIFO (
    /* input */
    .wclk(AXI_CLK_i),
    .wrst(AXI_RST_i),
    .rclk(S_CLK_i),
    .rrst(S_RST_i),
    .wpush(),
    .wdata(),
    .rpop(),
    /* output */
    .wfull(),
    .rempty(),
    .rdata()
  );

  ASYN_FIFO #(39, 3) R_FIFO ();
  ASYN_FIFO #( 6, 3) B_FIFO ();

  P_Arbiter #(49) AR_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_AR_FIFO_DATA),
    .in2(M1_AR_FIFO_DATA),
    .in1_valid(M0_AR_FIFO_VALID),
    .in2_valid(M1_AR_FIFO_VALID),
    .out_grant(),
    /* output */
    .out(),
    .out_valid(),
    .in1_grant(),
    .in2_grant(),
    .sel()
  );

  P_Arbiter #(49) AW_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_AW_FIFO_DATA),
    .in2(M1_AW_FIFO_DATA),
    .in1_valid(M0_AW_FIFO_VALID),
    .in2_valid(M1_AW_FIFO_VALID),
    .out_grant(),
    /* output */
    .out(),
    .out_valid(),
    .in1_grant(),
    .in2_grant(),
    .sel()
  );

  P_Arbiter #(37) W_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_W_FIFO_DATA),
    .in2(M1_W_FIFO_DATA),
    .in1_valid(M0_W_FIFO_VALID),
    .in2_valid(M1_W_FIFO_VALID),
    .out_grant(),
    /* output */
    .out(),
    .out_valid(),
    .in1_grant(),
    .in2_grant(),
    .sel()
  );

endmodule