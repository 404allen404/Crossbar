`define S0_MIN 32'h0000_0000
`define S0_MAX 32'h0000_3FFF
`define S1_MIN 32'h0001_0000
`define S1_MAX 32'h0001_FFFF
`define S2_MIN 32'h0002_0000
`define S2_MAX 32'h0002_FFFF
`define S3_MIN 32'h1000_0000
`define S3_MAX 32'h1000_03FF
`define S4_MIN 32'h1001_0000
`define S4_MAX 32'h1001_03FF
`define S5_MIN 32'h2000_0000
`define S5_MAX 32'h207F_FFFF

module AXI_Decoder (
  /* input */
  input logic addr_valid;
  input logic [31:0] addr_in;
  /* output */
  output logic [5:0] M_VALID;
);


  always_comb begin
    if(addr_valid) begin
      unique if(addr_in <= `S0_MAX && addr_in >= `S0_MIN) begin
        M_VALID = 6'b000001;
      end
      else if(addr_in <= `S1_MAX && addr_in > `S0_MAX) begin
        M_VALID = 6'b000010;
      end
      else if(addr_in <= `S2_MAX && addr_in > `S1_MAX) begin
        M_VALID = 6'b000100;
      end
      else if(addr_in <= `S3_MAX && addr_in > `S2_MAX) begin
        M_VALID = 6'b001000;
      end
      else if(addr_in <= `S4_MAX && addr_in > `S3_MAX) begin
        M_VALID = 6'b010000;
      end
      else begin
        M_VALID = 6'b100000;
      end
    end
    else begin
      M_VALID = 6'b000000;
    end
  end

endmodule