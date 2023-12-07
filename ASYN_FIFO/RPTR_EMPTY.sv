module RPTR_EMPTY 
  #(
    parameter ADDR_SIZE = 3
  )
  (rclk, rrst, rpop, rempty, raddr, rptr, sync_wptr);

  input  logic                 rclk;
  input  logic                 rrst;
  input  logic                 rpop;
  input  logic [ADDR_SIZE:0]   sync_wptr; // gray code

  output logic                 rempty;
  output logic [ADDR_SIZE-1:0] raddr;     // binary
  output logic [ADDR_SIZE:0]   rptr;      // gray code

  logic [ADDR_SIZE:0] raddr_w;
  logic [ADDR_SIZE:0] rptr_w;
  logic               rempty_w;

  assign raddr_w  = {1'b0, raddr} + {ADDR_SIZE'd0, rpop && ~rempty};
  assign rptr_w   = (raddr_w >> 1) ^ raddr_w;
  assign rempty_w = (sync_wptr == rptr_w); 

  always_ff @(posedge rclk) begin
    if(rrst) begin
      raddr <= ADDR_SIZE'd0;
    end
    else begin
      raddr <= raddr_w[ADDR_SIZE-1:0];
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
  always_ff @(posedge rclk) begin
    if(rrst) begin
      rptr <= (ADDR_SIZE+1)'d0;
    end
    else begin
      rptr <= rptr_w;
    end
  end

endmodule