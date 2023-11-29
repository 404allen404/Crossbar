module WPTR_FULL (wclk, wrst, wpush, wfull, waddr, wptr, sync_rptr);

  parameter ADDR_SIZE = 3;

  input  logic                 wclk;
  input  logic                 wrst;
  input  logic                 wpush;
  input  logic [ADDR_SIZE-1:0] sync_rptr; // gray code

  output logic                 wfull; 
  output logic                 wen;
  output logic [ADDR_SIZE-1:0] waddr;     // binary
  output logic [ADDR_SIZE-1:0] wptr;      // gray code

  assign wen   = wpush && ~wfull;
  assign wfull = 1'b0; // ?

  always_ff @(posedge wclk) begin
    if(wrst) begin
      waddr <= ADDR_SIZE'd0;
    end
    else if(wen) begin
      waddr <= waddr + ADDR_SIZE'd1;
    end
  end

  // binary to gray code
  // 3'b000 -> 3'b000
  // 3'b001 -> 3'b001
  // 3'b010 -> 3'b011
  // 3'b011 -> 3'b010
  // 3'b100 -> 3'b110
  // 3'b101 -> 3'b111
  // 3'b110 -> 3'b101
  // 3'b111 -> 3'b100
  // gray[2] = 1'b0      ^ binary[2]
  // gray[1] = binary[2] ^ binary[1]
  // gray[0] = binart[1] ^ binart[0]
  always_ff @(posedge wclk) begin
    if(wrst) begin
      wptr <= ADDR_SIZE'd0;
    end
    else begin
      wptr <= (waddr >> 1) ^ waddr;
    end
  end



endmodule