module FIFO_MEM 
  #(
    parameter DATA_SIZE = 32,
    parameter ADDR_SIZE = 3
  )
  (wclk, wen, waddr, wdata, raddr, rdata);

  parameter DEPTH = 1 << ADDR_SIZE;

  input  logic                 wclk;
  input  logic                 wen;
  input  logic [ADDR_SIZE-1:0] waddr;
  input  logic [DATA_SIZE-1:0] wdata;
  input  logic [ADDR_SIZE-1:0] raddr;
  output logic [DATA_SIZE-1:0] rdata;

  logic [DATA_SIZE-1:0] MEM [0:DEPTH-1];

  assign rdata = MEM[raddr];

  always_ff @(posedge wclk) begin
    if(wen) begin
      MEM[waddr] <= wdata;
    end
  end

endmodule