module WPTR_FULL 
  #(
    parameter ADDR_SIZE = 3
  )
  (wclk, wrst, wpush, wfull, waddr, wptr, sync_rptr);

  input  logic                 wclk;
  input  logic                 wrst;
  input  logic                 wpush;
  input  logic [ADDR_SIZE:0]   sync_rptr; // gray code

  output logic                 wfull; 
  output logic                 wen;
  output logic [ADDR_SIZE-1:0] waddr;     // binary
  output logic [ADDR_SIZE:0]   wptr;      // gray code

  logic [ADDR_SIZE:0] waddr_w;
  logic [ADDR_SIZE:0] wptr_w;
  logic               wfull_w;

  assign wen     = wpush && ~wfull;
  assign waddr_w = {1'b0, waddr} + {ADDR_SIZE'd0, wen};
  assign wptr_w  = (waddr_w >> 1) ^ waddr_w;
  assign wfull_w = (wptr_w == {~sync_rptr[ADDR_SIZE:ADDR_SIZE-1], sync_rptr[ADDR_SIZE-2:0]});

  always_ff @(posedge wclk) begin
    if(wrst) begin
      wfull <= 1'b0;
    end
    else begin
      wfull <= wfull_w;
    end
  end

  always_ff @(posedge wclk) begin
    if(wrst) begin
      waddr <= ADDR_SIZE'd0;
    end
    else begin
      waddr <= waddr_w[ADDR_SIZE-1:0];
    end
  end

  // binary to gray code
  // 4'b0000 -> 4'b0000
  // 4'b0001 -> 4'b0001
  // 4'b0010 -> 4'b0011
  // 4'b0011 -> 4'b0010
  // 4'b0100 -> 4'b0110
  // 4'b0101 -> 4'b0111
  // 4'b0110 -> 4'b0101
  // 4'b0111 -> 4'b0100
  // 4'b1000 -> 4'b1100
  // 4'b1001 -> 4'b1101
  // 4'b1010 -> 4'b1111
  // 4'b1011 -> 4'b1110
  // 4'b1100 -> 4'b1010
  // 4'b1101 -> 4'b1011
  // 4'b1110 -> 4'b1001
  // 4'b1111 -> 4'b1000
  always_ff @(posedge wclk) begin
    if(wrst) begin
      wptr <= (ADDR_SIZE+1)'d0;
    end
    else begin
      wptr <= wptr_w;
    end
  end

endmodule