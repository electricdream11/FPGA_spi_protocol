`timescale 1ns/1ns
module tb_top_spi_function;
reg clk;
reg rst_n;

wire [7:0] om_data_master;
wire [7:0] om_data_slave;

top_spi_function tb_U1(
	.clk(clk),
	.rst_n(rst_n),

	.om_data_master(om_data_master),
	.om_data_slave(om_data_slave)
);
initial begin
	clk=0;
	rst_n=0;
end
always #2 clk=~clk;
initial begin
	#100
	rst_n<=1'b1;
	#100000
	rst_n<=1'b0;
	#10
	$stop();
end

endmodule
