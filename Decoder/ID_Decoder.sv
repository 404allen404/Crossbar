module ID_Decoder (
  /* input */
  input logic [7:0] id_in;
  input logic       id_valid;
  /* output */
  output logic [1:0] S_VALID;
);

logic VALID_0;
logic VALID_1;

assign VALID_0 = (id_in[7:4] == 4'd0) && id_valid;
assign VALID_1 = (id_in[7:4] == 4'd1) && id_valid;
assign S_VALID = {VALID_1, VALID_0};

endmodule
