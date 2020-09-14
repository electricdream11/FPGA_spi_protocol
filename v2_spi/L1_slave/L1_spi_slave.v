module L1_spi_slave #(
	parameter CLK_CNT_HALF=10,
	parameter CLK_CNT_HALF_WIDTH=4,
	parameter MODE =2'b00,
	parameter CPOL = MODE[1],
	parameter CPHA = MODE[0]
)
(
	input clk,
	input rst_n,

	input [7:0] im_data,
	output [7:0] om_data,

	input im_MOSI_spi,
	input im_SCLK_spi,
	output om_MISO_spi,

	output om_send_finish,
	output om_receive_finish

);

wire om_up_edge,om_down_edge,om_high_read,om_low_read;
reg im_send_pluse,im_receive_pluse;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		im_send_pluse<=1'b0;
		im_receive_pluse<=1'b0;
	end
	else 
	case(CPHA)
		1'b1:begin 
			im_send_pluse<=om_down_edge;
			im_receive_pluse<=om_high_read;
		end
		1'b0:begin
			im_send_pluse<=om_up_edge;
			im_receive_pluse<=om_low_read;
		end
	endcase
end



L2_clk_read_cnt #(
	.CLK_CNT_HALF(CLK_CNT_HALF),
	.CLK_CNT_HALF_WIDTH(CLK_CNT_HALF_WIDTH),
	.CPOL(CPOL)
)L2_S1 (
	.clk(clk),
	.rst_n(rst_n),

	.im_SCLK_spi(im_SCLK_spi),
	
	.om_up_edge(om_up_edge),
	.om_down_edge(om_down_edge),
	.om_high_read(om_high_read),
	.om_low_read(om_low_read)
);

L2_send L2_S2(
	.clk(clk),
	.rst_n(rst_n),
	.im_work_en(1'b1),//used to reset bite_cnt 

	.im_work_pluse(im_send_pluse),
	.im_data(im_data),
	.om_data(om_MISO_spi),
	.om_finish(om_send_finish)
);

L2_receive L2_U3(
	.clk(clk),
	.rst_n(rst_n),
        .im_work_en(1'b1),//used to reset bite_cnt 

	.im_work_pluse(im_receive_pluse),
	.im_data(im_MOSI_spi),
	.om_data(om_data),
	.om_finish(om_receive_finish)
);
endmodule
