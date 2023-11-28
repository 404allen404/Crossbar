module ASYN_FIFO (wclk, wrst, wfull, wdata, wpush, rclk, rrst, rempty, rdata, rpop);

  parameter DATA_SIZE = 32;
  parameter ADDR_SIZE = 3;

  input  logic                 wclk;
  input  logic                 wrst;
  input  logic                 rclk;
  input  logic                 rrst;
  input  logic                 wpush;
  input  logic [DATA_SIZE-1:0] wdata;
  input  logic                 rpop;

  output logic                 wfull;
  output logic                 rempty;
  output logic [DATA_SIZE-1:0] rdata;

  logic [ADDR_SIZE-1:0] wptr;
  logic [ADDR_SIZE-1:0] rptr;

  logic [ADDR_SIZE-1:0] sync_wptr;
  logic [ADDR_SIZE-1:0] sync_rptr;

  logic                 wen;

  assign wen = (wpush & ~wfull);

  FIFO_MEM FIFO_MEM (.wclk(wclk), 
                     .wen(wen),
                     .waddr(wptr),
                     .wdata(wdata),
                     .raddr(rptr),
                     .rdata(rdata));

  2DFF rptr_2DFF (.sclk(rclk),
                  .srst(rrst),
                  .data_in(rptr),
                  .data_out(sync_rptr));

  2DFF wptr_2DFF (.sclk(wclk),
                  .srst(wrst),
                  .data_in(wptr),
                  .data_out(sync_wptr));


  WPTR_FULL WPTR_FULL();

  RPTR_EMPTY RPTR_EMPTY();

endmodule