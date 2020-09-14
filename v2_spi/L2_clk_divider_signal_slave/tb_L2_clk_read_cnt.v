`timescale 1ns/1ns
module tb_L2_clk_read_cnt;
	reg clk;
	reg rst_n;

	reg im_SCLK_spi;

	wire om_up_edge;
	wire om_down_edge;
	wire om_high_read;
	wire om_low_read;

L2_clk_read_cnt tb_U1(
	.clk(clk),
	.rst_n(rst_n),

	.im_SCLK_spi(im_SCLK_spi),

	.om_up_edge(om_up_edge),
	.om_down_edge(om_down_edge),
	.om_high_read(om_high_read),
	.om_low_read(om_low_read)

);
initial begin
	clk=0;
	rst_n=0;
	im_SCLK_spi=0;
end

always #1 clk=~clk;
always #20 im_SCLK_spi=~im_SCLK_spi;

initial begin
	#10
	rst_n=1'b1;
	#1000
	$stop();
end


endmodule
