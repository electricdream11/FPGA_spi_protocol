module L2_master
#(
	parameter MODE = 0,

	parameter CLK_TIMES=8,
	parameter CLK_TIMES_WIDTH=4,

	parameter HALF_CLK_PERIOD=100, //real time depends on system clk
	parameter HALF_CLK_PERIOD_WIDTH=7,


	parameter READ_DELAY_WRITE = 5'd20, //used to delay read
	parameter READ_DELAY_WRITE_WIDTH = 5
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output om_work_end,

	input im_miso_wire,
	output om_mosi_wire,
	output om_sclk_wire,

	input [7:0] im_data_bus,
	output[7:0] om_data_bus

);
	localparam CPOL=MODE[1];
	localparam CPHA=MODE[0];

	wire om_up_edge,om_down_edge;
	wire om_read_pluse,om_write_pluse;


L3_counter_clk #(
	.CPOL(CPOL),
	.CLK_TIMES(CLK_TIMES),
	.CLK_TIMES_WIDTH(CLK_TIMES_WIDTH),
	.HALF_CLK_PERIOD(HALF_CLK_PERIOD),
	.HALF_CLK_PERIOD_WIDTH(HALF_CLK_PERIOD_WIDTH)

)
U1_sclk
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.om_work_end(om_work_end),

	.om_sclk(om_sclk_wire),
	.om_up_edge(om_up_edge),
	.om_down_edge(om_down_edge)
);

L3_pluse_create #(
	.M_OR_S(1'b1),
	.CPHA(CPHA),

	.READ_DELAY_WRITE(READ_DELAY_WRITE),
	.READ_DELAY_WRITE_WIDTH(READ_DELAY_WRITE_WIDTH)
)
U2_pluse
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.im_up_edge(om_up_edge),
	.im_down_edge(om_down_edge),

	.om_read_pluse(om_read_pluse),
	.om_write_pluse(om_write_pluse)
);

L3_8to1_send U3_send(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),

	.im_work_pluse(om_write_pluse),
	.im_data(im_data_bus),
	.om_data(om_mosi_wire)
);

L3_1to8_receive U4_receive(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),

	.im_work_pluse(om_read_pluse),
	.im_data(im_miso_wire),
	.om_data(om_data_bus)
);
endmodule
