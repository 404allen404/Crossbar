module RPTR_EMPTY (rclk, rrst, rpop, rempty, raddr, rptr, sync_wptr);

  parameter ADDR_SIZE = 3;

  input  logic                 rclk;
  input  logic                 rrst;
  input  logic                 rpop;
  input  logic [ADDR_SIZE-1:0] sync_wptr; // gray code

  output logic                 rempty;
  output logic [ADDR_SIZE-1:0] raddr;     // binary
  output logic [ADDR_SIZE-1:0] rptr;      // gray code

  assign rempty = 1'b0; // ?

  always_ff @(posedge rclk) begin
    if(rrst) begin
      raddr <= ADDR_SIZE'd0;
    end
    else if(rpop && ~rempty) begin
      raddr <= raddr + ADDR_SIZE'd1;
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
  always_ff @(posedge rclk) begin
    if(rrst) begin
      rptr <= ADDR_SIZE'd0;
    end
    else begin
      rptr <= (rptr >> 1) ^ rptr;
    end
  end

endmodule