module 2DFF (sclk, srst, data_in, data_out);

  parameter DATA_SIZE = 3;

  input  logic sclk; // source clk
  input  logic srst; // source rst
  input  logic [DATA_SIZE-1:0] data_in;
  output logic [DATA_SIZE-1:0] data_out;

  logic [DATA_SIZE-1:0] tmp_data; 

  always_ff @(posedge sclk) begin
    if(srst) begin
      tmp_data <= DATA_SIZE'd0;
      data_out <= DATA_SIZE'd0;
    end
    else begin
      tmp_data <= data_in;
      data_out <= tmp_data;
    end
  end

endmodule