module AXI_M_IF (

  /* input */ 
  input  logic                      AXI_CLK_i,
  input  logic                      AXI_RST_i,
  input  logic                      S_CLK_i,
  input  logic                      S_RST_i,

  // P_Arbiter input
  input  logic                      M0_AR_VALID;
  input  logic                      M0_AW_VALID;
  input  logic                      M0_W_VALID;
  input  logic                      M1_AR_VALID;
  input  logic                      M1_AW_VALID;
  input  logic                      M1_W_VALID;
  input  logic [48:0]               M0_AR_DATA;
  input  logic [48:0]               M0_AW_DATA;
  input  logic [36:0]               M0_W_DATA;
  input  logic [48:0]               M1_AR_DATA;
  input  logic [48:0]               M1_AW_DATA;
  input  logic [36:0]               M1_W_DATA;

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

  input  logic                      b_rpop;
  input  logic                      r_rpop;

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

  output logic [1:0]                S_B_VALID;
  output logic [1:0]                S_R_VALID;
  output logic [9:0]                S_B_DATA;
  output logic [42:0]               S_R_DATA;

  // P_Arbiter output
  output logic ar_in1_grant;
  output logic ar_in2_grant;
  output logic ar_sel;
  output logic aw_in1_grant;
  output logic aw_in2_grant;
  output logic aw_sel;
  output logic w_in1_grant;
  output logic w_in2_grant;
  output logic w_sel;

);

  // ASYN_FIFO input
  logic [42:0] r_wdata;
  logic [ 9:0] b_wdata;

  // ASYN_FIFO output
  logic        ar_wfull;
  logic        aw_wfull;
  logic        w_wfull;
  logic        ar_rempty;
  logic        aw_rempty;
  logic        w_rempty;
  logic [48:0] ar_rdata;
  logic [48:0] aw_rdata;
  logic [36:0] w_rdata;

  logic        r_wfull;
  logic        b_wfull;

  logic [42:0] r_rdata;
  logic [9:0]  b_rdata;

  logic        r_rempty;
  logic        b_rempty;

  // P_Arbiter input
  logic ar_out_grant;
  logic aw_out_grant;
  logic w_out_grant;

  // P_Arbiter output
  logic [48:0] ar_out;
  logic [48:0] aw_out;
  logic [36:0] w_out;
  logic        ar_out_valid;
  logic        aw_out_valid;
  logic        w_out_valid;

  assign S_B_DATA = b_rdata;
  assign S_R_DATA = r_rdata;

  assign ar_out_grant = ar_out_valid && ~ar_wfull;
  assign aw_out_grant = aw_out_valid && ~aw_wfull;
  assign w_out_grant  = w_out_valid && ~w_wfull;

  assign r_wdata = {RID_i, RDATA_i, RRESP_i, RLAST_i};
  assign b_wdata = {BID_i, BRESP_i};

  // AXI_M_IF to Slave
  assign ARID_o    = ar_rdata[48:41]; 
  assign ARADDR_o  = ar_rdata[40:9];
  assign ARLEN_o   = ar_rdata[8:5];
  assign ARSIZE_o  = ar_rdata[4:2];
  assign ARBURST_o = ar_rdata[1:0]

  assign AWID_o    = aw_rdata[48:41]; 
  assign AWADDR_o  = aw_rdata[40:9];
  assign AWLEN_o   = aw_rdata[8:5];
  assign AWSIZE_o  = aw_rdata[4:2];
  assign AWBURST_o = aw_rdata[1:0]

  assign WDATA_o   = w_rdata[36:5];
  assign WSTRB_o   = w_rdata[4:1];
  assign WLAST_o   = w_rdata[0];

  assign ARVALID_o = ~ar_rempty;  
  assign AWVALID_o = ~aw_rempty;
  assign WVALID_o  = ~w_rempty;

  assign RREADY_o = ~r_wfull;
  assign BREADY_o = ~b_wfull;

  ASYN_FIFO #(49, 3) AR_FIFO (
    /* input */
    .wclk(AXI_CLK_i),
    .wrst(AXI_RST_i),
    .rclk(S_CLK_i),
    .rrst(S_RST_i),
    .wpush(ar_out_valid),
    .wdata(ar_out),
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
    .wpush(aw_out_valid),
    .wdata(aw_out),
    .rpop(AWREADY_i),
    /* output */
    .wfull(aw_wfull),
    .rempty(aw_rempty),
    .rdata(aw_rdata)
  );

  ASYN_FIFO #(37, 3) W_FIFO (
    /* input */
    .wclk(AXI_CLK_i),
    .wrst(AXI_RST_i),
    .rclk(S_CLK_i),
    .rrst(S_RST_i),
    .wpush(w_out_valid),
    .wdata(w_out),
    .rpop(WREADY_i),
    /* output */
    .wfull(w_wfull),
    .rempty(w_rempty),
    .rdata(w_rdata)
  );

  ASYN_FIFO #(43, 3) R_FIFO (
    /* input */
    .wclk(S_CLK_i),
    .wrst(S_RST_i),
    .rclk(AXI_CLK_i),
    .rrst(AXI_RST_i),
    .wpush(RVALID_i),
    .wdata(r_wdata),
    .rpop(r_rpop),
    /* output */
    .wfull(r_wfull),
    .rempty(r_rempty),
    .rdata(r_rdata)
  );

  ASYN_FIFO #(10, 3) B_FIFO (
    /* input */
    .wclk(S_CLK_i),
    .wrst(S_RST_i),
    .rclk(AXI_CLK_i),
    .rrst(AXI_RST_i),
    .wpush(BVALID_i),
    .wdata(b_wdata),
    .rpop(b_rpop),
    /* output */
    .wfull(b_wfull),
    .rempty(b_rempty),
    .rdata(b_rdata)
  );

  P_Arbiter #(49) AR_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_AR_DATA),
    .in2(M1_AR_DATA),
    .in1_valid(M0_AR_VALID),
    .in2_valid(M1_AR_VALID),
    .out_grant(ar_out_grant),
    /* output */
    .out(ar_out),
    .out_valid(ar_out_valid),
    .in1_grant(ar_in1_grant),
    .in2_grant(ar_in2_grant),
    .sel(ar_sel)
  );

  P_Arbiter #(49) AW_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_AW_FIFO_DATA),
    .in2(M1_AW_FIFO_DATA),
    .in1_valid(M0_AW_VALID),
    .in2_valid(M1_AW_VALID),
    .out_grant(aw_out_grant),
    /* output */
    .out(aw_out),
    .out_valid(aw_out_valid),
    .in1_grant(aw_in1_grant),
    .in2_grant(aw_in2_grant),
    .sel(aw_sel)
  );

  P_Arbiter #(37) W_Arbiter (
    /* input */
    .AXI_CLK_i(AXI_CLK_i),
    .AXI_RST_i(AXI_RST_i),
    .in1(M0_W_FIFO_DATA),
    .in2(M1_W_FIFO_DATA),
    .in1_valid(M0_W_VALID),
    .in2_valid(M1_W_VALID),
    .out_grant(w_out_grant),
    /* output */
    .out(w_out),
    .out_valid(w_out_valid),
    .in1_grant(w_in1_grant),
    .in2_grant(w_in2_grant),
    .sel(w_sel)
  );

  ID_Decoder R_Decoder (
    /* input */
    .id_in(r_rdata[42:35]),
    .id_valid(~r_rempty),
    /* output */
    .S_VALID(S_R_VALID)
  );

  ID_Decoder B_Decoder (
    /* input */
    .id_in(r_rdata[9:2]),
    .id_valid(~b_rempty),
    /* output */
    .S_VALID(S_B_VALID)
  );

endmodule