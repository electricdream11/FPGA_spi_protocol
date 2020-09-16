module L2_slave #(
	parameter MODE = 0
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output om_work_end,

	input im_mosi_wire,
	input im_sclk_wire,
	output om_miso_wire,

	input [7:0] im_data_bus,
	output [7:0] om_data_bus

);
	localparam CPOL=MODE[1];
	localparam CPHA=MODE[0];

	wire om_up_edge,om_down_edge;
	wire om_read_pluse,om_write_pluse;

L3_analyse_sclk #(
	.CPOL(CPOL)
)
U1_sclk
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.om_work_end(om_work_end),

	.im_sclk_wire(im_sclk_wire),
	.om_up_edge(om_up_edge),
	.om_down_edge(om_down_edge)
);

L3_pluse_create #(
	.M_OR_S(1'b0),
	.CPHA(CPHA)
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
	.om_data(om_miso_wire)
);

L3_1to8_receive U4_receive(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),

	.im_work_pluse(om_read_pluse),
	.im_data(im_mosi_wire),
	.om_data(om_data_bus)
);
endmodule
