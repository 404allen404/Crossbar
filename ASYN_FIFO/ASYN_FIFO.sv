module ASYN_FIFO 
  #(
    parameter DATA_SIZE = 32,
    parameter ADDR_SIZE = 3
  )
  (wclk, wrst, wfull, wdata, wpush, rclk, rrst, rempty, rdata, rpop);

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

  logic [ADDR_SIZE:0] wptr;      // gray code
  logic [ADDR_SIZE:0] rptr;      // gray code

  logic [ADDR_SIZE:0] sync_wptr; // gray code
  logic [ADDR_SIZE:0] sync_rptr; // gray code

  logic [ADDR_SIZE-1:0] waddr;   // binary 
  logic [ADDR_SIZE-1:0] raddr;   // binary

  logic                 wen;

  FIFO_MEM #(DATA_SIZE, ADDR_SIZE) FIFO_MEM (.wclk(wclk), 
                                             .wen(wen),
                                             .waddr(waddr),
                                             .wdata(wdata),
                                             .raddr(raddr),
                                             .rdata(rdata));

  2DFF #(ADDR_SIZE) rptr_2DFF (.dclk(wclk),
                               .drst(wrst),
                               .data_in(rptr),
                               .data_out(sync_rptr));

  2DFF #(ADDR_SIZE) wptr_2DFF (.dclk(rclk),
                               .drst(rrst),
                               .data_in(wptr),
                               .data_out(sync_wptr));


  WPTR_FULL #(ADDR_SIZE) WPTR_FULL (.wclk(wclk),
                                    .wrst(wrst),
                                    .wpush(wpush),
                                    .sync_rptr(sync_rptr),
                                    .wfull(wfull),
                                    .waddr(waddr),
                                    .wptr(wptr),
                                    .wen(wen));

  RPTR_EMPTY #(ADDR_SIZE) RPTR_EMPTY (.rclk(rclk),
                                      .rrst(rrst),
                                      .rpop(rpop),
                                      .sync_wptr(sync_wptr),
                                      .rempty(rempty),
                                      .raddr(raddr),
                                      .rptr(rptr));

endmodule