module AXI_S_IF 

#(
  parameter M_NUM = 4'd0;
)

(
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
  input  logic                      WLAST_i,   // 1-bit
  input  logic                      WVALID_i,

  input  logic                      BREADY_i,                

  input  logic [5:0]                R_MUX_sel;
  input  logic [5:0]                B_MUX_sel;
  input  logic [42:0]               R_MUX_data;
  input  logic [9:0]                B_MUX_data;

  /* output */
  output logic                      ARREADY_o,

  output logic [`AXI_ID_BITS-1:0]   RID_o,     // 4-bit
  output logic [`AXI_DATA_BITS-1:0] RDATA_o,   // 32-bit
  output logic [1:0]                RRESP_o,   // 2-bit
  output logic                      RLAST_o,   // 1-bit
  output logic                      RVALID_o,

  output logic                      AWREADY_o,

  output logic                      WREADY_o,

  output logic [`AXI_ID_BITS-1:0]   BID_o,     // 4-bit
  output logic [1:0]                BRESP_o,   // 2-bit
  output logic                      BVALID_o,

  output logic [ 5:0]               M_AR_VALID,
  output logic [ 5:0]               M_AW_VALID, 
  output logic [ 5:0]               M_W_VALID,
  output logic [48:0]               M_AR_DATA,
  output logic [48:0]               M_AW_DATA,
  output logic [36:0]               M_W_DATA

);

  logic [42:0] R_MUX_out;
  logic [9:0]  B_MUX_out;

  logic r_wpush;
  logic b_wpush;

  logic [48:0] ar_wdata;
  logic [48:0] aw_wdata;
  logic [36:0] w_wdata;

  logic        ar_rpop;
  logic        aw_rpop;
  logic        w_rpop;

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

  logic [42:0] r_rdata;
  logic [ 9:0] b_rdata;
  logic        r_rempty;
  logic        b_rempty;
  logic        r_wfull;
  logic        b_wfull;

  logic [ 7:0] ar_id;
  logic [ 7:0] aw_id;

  assign r_wpush = |R_MUX_sel;
  assign w_wpush = |B_MUX_sel;

  // AXI_S_IF to Master
  assign ARREADY_o = ~ar_wfull;
  assign AWREADY_o = ~aw_wfull;
  assign WREADY_o  = ~w_wfull;

  assign ar_id     = {M_NUM, ARID_i};
  assign aw_id     = {M_NUM, AWID_i};
  assign ar_wdata  = {ar_id, ARADDR_i, ARLEN_i, ARSIZE_i, ARBURST_i};
  assign aw_wdata  = {aw_id, AWADDR_i, AWLEN_i, AWSIZE_i, AWBURST_i};
  assign w_wdata   = {WDATA_i, WSTRB_i, WLAST_i};

  assign M_AR_DATA = ar_rdata;
  assign M_AW_DATA = aw_rdata;
  assign M_W_DATA  = w_rdata;

  ASYN_FIFO #(49, 3) AR_FIFO  ( /* input */
                                .wclk(CPU_CLK_i),
                                .wrst(CPU_RST_i),
                                .rclk(AXI_CLK_i),
                                .rrst(AXI_RST_i),
                                .wpush(ARVALID_i),
                                .wdata(ar_wdata),
                                .rpop(ar_rpop),
                                /* output */
                                .wfull(ar_wfull),
                                .rempty(ar_rempty),
                                .rdata(ar_rdata)
                              );

  ASYN_FIFO #(49, 3) AW_FIFO  ( /* input */
                                .wclk(CPU_CLK_i),
                                .wrst(CPU_RST_i),
                                .rclk(AXI_CLK_i),
                                .rrst(AXI_RST_i),
                                .wpush(AWVALID_i),
                                .wdata(aw_wdata),
                                .rpop(aw_rpop),
                                /* output */
                                .wfull(aw_wfull),
                                .rempty(aw_rempty),
                                .rdata(aw_rdata)
                              );

  ASYN_FIFO #(37, 3) W_FIFO ( /* input */
                              .wclk(CPU_CLK_i),
                              .wrst(CPU_RST_i),
                              .rclk(AXI_CLK_i),
                              .rrst(AXI_RST_i),
                              .wpush(WVALID_i),
                              .wdata(w_wdata),
                              .rpop(w_rpop),
                              /* output */
                              .wfull(w_wfull),
                              .rempty(w_rempty),
                              .rdata(w_rdata)
                            ); 

  ASYN_FIFO #(43, 3) R_FIFO ( /* input */
                              .wclk(AXI_CLK_i),
                              .wrst(AXI_RST_i),
                              .rclk(CPU_CLK_i),
                              .rrst(CPU_RST_i),
                              .wpush(r_wpush),
                              .wdata(R_MUX_out),
                              .rpop(RREADY_i),
                              /* output */
                              .wfull(r_wfull),
                              .rempty(r_rempty),
                              .rdata(r_rdata)
                            );

  ASYN_FIFO #(10, 3) B_FIFO ( /* input */
                              .wclk(AXI_CLK_i),
                              .wrst(AXI_RST_i),
                              .rclk(CPU_CLK_i),
                              .rrst(CPU_RST_i),
                              .wpush(b_wpush),
                              .wdata(B_MUX_out),
                              .rpop(BREADY_i),
                              /* output */
                              .wfull(b_wfull),
                              .rempty(b_rempty),
                              .rdata(b_rdata)
                            );

  6TO1_MUX R_MUX #(43) (
    /* input */
    .sel(R_MUX_sel),
    .in1(R_MUX_data[0]),
    .in2(R_MUX_data[1]),
    .in3(R_MUX_data[2]),
    .in4(R_MUX_data[3]),
    .in5(R_MUX_data[4]),
    .in6(R_MUX_data[5]),
    /* output */
    .out(R_MUX_out)
  );

  6TO1_MUX B_MUX #(10) (
    /* input */
    .sel(B_MUX_sel),
    .in1(B_MUX_data[0]),
    .in2(B_MUX_data[1]),
    .in3(B_MUX_data[2]),
    .in4(B_MUX_data[3]),
    .in5(B_MUX_data[4]),
    .in6(B_MUX_data[5]),
    /* output */
    .out(B_MUX_out)
  );

  ADDR_Decoder AR_Decoder (
    .addr_valid(~ar_rempty),
    .addr_in(ar_rdata[40:9]),
    .M_VALID(M_AR_VALID)
  );

  ADDR_Decoder AW_Decoder (
    .addr_valid(~aw_rempty),
    .addr_in(aw_rdata[40:9]),
    .M_VALID(M_AW_VALID)
  );

  ADDR_Decoder W_Decoder (
    .addr_valid(),
    .addr_in(),
    .M_VALID()
  );

endmodule