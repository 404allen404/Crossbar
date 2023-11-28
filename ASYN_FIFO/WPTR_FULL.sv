module WPTR_FULL (wclk, wrst, wpush, wfull, waddr, wptr, sync_rptr);

  parameter ADDR_SIZE = 3;

  input  logic                 wclk;
  input  logic                 wrst;
  input  logic                 wpush;
  input  logic [ADDR_SIZE-1:0] sync_rptr;

  output logic                 wfull; 
  output logic [ADDR_SIZE-1:0] waddr;
  output logic [ADDR_SIZE-1:0] wptr;






endmodule