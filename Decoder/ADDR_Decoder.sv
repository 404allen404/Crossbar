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

  logic VALID_0;
  logic VALID_1;
  logic VALID_2;
  logic VALID_3;
  logic VALID_4;
  logic VALID_5;

  assign VALID_0 = (addr_in <= `S0_MAX && addr_in >= `S0_MIN) && addr_valid;
  assign VALID_1 = (addr_in <= `S1_MAX && addr_in > `S0_MAX) && addr_valid;
  assign VALID_2 = (addr_in <= `S2_MAX && addr_in > `S1_MAX) && addr_valid;
  assign VALID_3 = (addr_in <= `S3_MAX && addr_in > `S2_MAX) && addr_valid;
  assign VALID_4 = (addr_in <= `S4_MAX && addr_in > `S3_MAX) && addr_valid;
  assign VALID 5 = (addr_in >= `S5_MIN) && addr_valid;

  assign M_VALID = {VALID_5, VALID_4, VALID_3, VALID_2, VALID_1, VALID_0};

endmodule