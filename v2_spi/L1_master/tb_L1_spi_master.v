`timescale 1ns/1ns
module tb_L1_spi_master;
	reg clk;
	reg rst_n;
	reg im_work_en;

	reg [7:0] im_data;
	wire [7:0] om_data;

	reg im_MISO_spi;
	wire om_MOSI_spi;
	wire om_SCLK_spi;

	wire om_send_finish;
	wire om_receive_finish;

L1_spi_master_v2 #(
	.MODE(2'b00)
)
tb_U1
(
	.clk(clk),
	.rst_n(rst_n),
	.im_work_en(im_work_en),
	.im_data(im_data),
	.om_data(om_data),
	.im_MISO_spi(im_MISO_spi),
	.om_MOSI_spi(om_MOSI_spi),
	.om_SCLK_spi(om_SCLK_spi),
	.om_send_finish(om_send_finish),
	.om_receive_finish(om_receive_finish)

);

initial begin
	clk=0;
	rst_n=0;
	im_work_en=0;
	im_data=0;
	im_MISO_spi=1;
end

always #1 clk=~clk;

initial begin
	#1
	im_data<=8'd100;
	#4
	rst_n=1;
	#12
	im_work_en=1;
	#150
	$stop();

end
endmodule
