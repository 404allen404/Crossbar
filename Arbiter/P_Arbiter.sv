module PArbiter
#(
  parameter DATA_SIZE = 32
)
(
  /* input */
  input logic AXI_CLK_i,
  input logic AXI_RST_i,
  input logic [DATA_SIZE-1:0] in1,
  input logic [DATA_SIZE-1:0] in2,
  input logic in1_valid,
  input logic in2_valid,
  input logic out_grant,
  /* output */
  output logic [DATA_SIZE-1:0] out,
  output logic out_valid,
  output logic in1_grant,
  output logic in2_grant,
  output logic sel
);

  logic in2_valid_r;

  assign out       = in2_valid_r ? in2 :
                     in1_valid ? in1 : in2;                     
  assign out_valid = in1_valid || in2_valid;
  
  assign in1_grant = ~in2_valid_r && in1_valid && out_grant;
  assign in2_grant = (in2_valid_r || (~in1_valid && in2_valid)) && out_grant;
  assign sel       = in2_valid_r ? 1'b1 : ~in1_valid;

  always_ff @(posedge AXI_CLK_i) begin
    if(AXI_RST_i) begin
      in2_valid_r <= 1'b0;
    end
    else if(out_grant) begin
      in2_valid_r <= 1'b0;
    end
    else if(in2_valid && ~in1_valid) begin
      in2_valid_r <= 1'b1;
    end
  end

endmodule