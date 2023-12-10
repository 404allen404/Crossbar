module 6TO1_MUX 
#(
  parameter DATA_SIZE = 32
) 

(
  /* input */
  input logic [5:0]           sel;
  input logic [DATA_SIZE-1:0] in1;
  input logic [DATA_SIZE-1:0] in2;
  input logic [DATA_SIZE-1:0] in3;
  input logic [DATA_SIZE-1:0] in4;
  input logic [DATA_SIZE-1:0] in5;
  input logic [DATA_SIZE-1:0] in6;
  /* output */
  output logic [DATA_SIZE-1:0] out; 
);

always_comb begin
  unique case(sel)
    6'b000001: out = in1;
    6'b000010: out = in2;
    6'b000100: out = in3;
    6'b001000: out = in4;
    6'b010000: out = in5;
    6'b100000: out = in6;
    default:   out = DATA_SIZE'd0;
  endcase  
end

endmodule 