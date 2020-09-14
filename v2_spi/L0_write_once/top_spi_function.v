module top_spi_function #(
	parameter CLK_CNT_HALF=20,
	parameter CLK_CNT_HALF_WIDTH=5,
	parameter MODE = 2'b00,
	parameter CPOL = MODE[1],
	parameter CPHA = MODE[0]
)
(
	input clk,
	input rst_n,

	output [7:0] om_data_master,
	output [7:0] om_data_slave
);

wire [7:0] im_data_master;
wire [7:0] im_data_slave;


wire MISO_spi,MOSI_spi,SCLK_spi;
wire om_send_finish_master,om_receive_finish_master;
wire om_send_finish_slave,om_receive_finish_slave;

reg finish1,finish2,finish3,finish4;

reg im_work_en;

wire finish_wait;
wire finish_end;
wire close;
assign im_data_master = "a";
assign im_data_slave = "b";

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		finish1<=1'b0;
	end
	else if(om_send_finish_master)begin
		finish1<=1'b1;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		finish2<=1'b0;
	end
	else if(om_receive_finish_master)begin
		finish2<=1'b1;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		finish3<=1'b0;
	end
	else if(om_send_finish_slave)begin
		finish3<=1'b1;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		finish4<=1'b0;
	end
	else if(om_receive_finish_slave)begin
		finish4<=1'b1;
	end
end
assign finish_wait=finish1 & finish2 & finish3 & finish4;
assign finish_end=om_send_finish_master | om_send_finish_slave
	| om_receive_finish_master | om_receive_finish_slave;
assign close= (finish_wait && !finish_end );
//work forms
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		im_work_en<=1'b0;
	end
	else if(close)begin
		im_work_en<=1'b0;
	end
	else begin
		im_work_en<=1'b1;
	end
end

L1_spi_master_v2 #(
	.CLK_CNT_HALF(CLK_CNT_HALF),
	.CLK_CNT_HALF_WIDTH(CLK_CNT_HALF_WIDTH),
	.MODE(MODE)

)top_U1(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.im_data(im_data_master),
	.om_data(om_data_master),

	.im_MISO_spi(MISO_spi),
	.om_MOSI_spi(MOSI_spi),
	.om_SCLK_spi(SCLK_spi),

	.om_send_finish(om_send_finish_master),
	.om_receive_finish(om_receive_finish_master)
);

L1_spi_slave #(
	.CLK_CNT_HALF(CLK_CNT_HALF),
	.CLK_CNT_HALF_WIDTH(CLK_CNT_HALF_WIDTH),
	.MODE(MODE)
)top_U2(
	.clk(clk),
	.rst_n(rst_n),

	.im_data(im_data_slave),
	.om_data(om_data_slave),

	.im_MOSI_spi(MOSI_spi),
	.im_SCLK_spi(SCLK_spi),
	.om_MISO_spi(MISO_spi),

	.om_send_finish(om_send_finish_slave),
	.om_receive_finish(om_receive_finish_slave)
);
endmodule
