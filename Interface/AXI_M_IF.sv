module AXI_M_IF (
  /* input */ 
  input logic        AXI_CLK_i,
  input logic        AXI_RST_i,
  input logic        S_CLK_i,
  input logic        S_RST_i,

  input logic        AR_FIFO_VALID;
  input logic        AW_FIFO_VALID;
  input logic        W_FIFO_VALID;
  input logic [48:0] AR_FIFO_DATA;
  input logic [48:0] AW_FIFO_DATA;
  input logic [36:0] W_FIFO_DATA;

  /* output */





);

  ASYN_FIFO AR_FIFO();
  ASYN_FIFO AW_FIFO();
  ASYN_FIFO W_FIFO();
  ASYN_FIFO R_FIFO();
  ASYN_FIFO B_FIFO();

  P_Arbiter AR_Arbiter();
  P_Arbiter AW_Arbiter();
  P_Arbiter W_Arbiter();

endmodule