module 2DFF 
  #(
    parameter ADDR_SIZE = 3
  )
  (dclk, drst, data_in, data_out);

  input  logic dclk; // destination clk
  input  logic drst; // destination rst
  input  logic [ADDR_SIZE:0] data_in;
  output logic [ADDR_SIZE:0] data_out;

  logic [ADDR_SIZE:0] tmp_data; 

  always_ff @(posedge dclk) begin
    if(drst) begin
      tmp_data <= (ADDR_SIZE+1)'d0;
      data_out <= (ADDR_SIZE+1)'d0;
    end
    else begin
      tmp_data <= data_in;
      data_out <= tmp_data;
    end
  end

endmodule