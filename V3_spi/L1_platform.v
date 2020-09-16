module L1_platform #(
	parameter MODE=0, //chose form

	parameter CLK_TIMES=4'd8,  //set bite width
	parameter CLK_TIMES_WIDTH=4,

	parameter HALF_CLK_PERIOD=7'd100, //real time depends on system clk
	parameter HALF_CLK_PERIOD_WIDTH=7,

	parameter READ_DELAY_WRITE = 5'd20, //used to delay read of write
	parameter READ_DELAY_WRITE_WIDTH = 5,

	parameter FIRST_EDGE_DELAY = 5, //used to set slave read
	parameter LAST_EDGE_BEFORE = 5
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output om_work_end_master,
	output om_work_end_slave,

	input [7:0] im_data_bus_master,
	input [7:0] im_data_bus_slave,
	output [7:0] om_data_bus_master,
	output [7:0] om_data_bus_slave
);
	wire miso_wire;
	wire mosi_wire;
	wire sclk_wire;
L2_master #(
	.MODE(MODE)

	.CLK_TIMES(CLK_TIMES),
	.CLK_TIMES_WIDTH(CLK_TIMES_WIDTH),

	.HALF_CLK_PERIOD(HALF_CLK_PERIOD),
	.HALF_CLK_PERIOD_WIDTH(HALF_CLK_PERIOD_WIDTH),

	.READ_DELAY_WRITE(READ_DELAY_WRITE),
	.READ_DELAY_WRITE_WIDTH(READ_DELAY_WRITE_WIDTH)
)
U1_master
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.om_work_end(om_work_end_master),

	.im_miso_wire(miso_wire),
	.om_mosi_wire(mosi_wire),
	.om_sclk_wire(sclk_wire),

	.im_data_bus(im_data_bus_master),
	.om_data_bus(om_data_bus_master)
);

L2_slave #(
	.MODE(MODE),

	.HALF_CLK_PERIOD(HALF_CLK_PERIOD),
	.HALF_CLK_PERIOD_WIDTH(HALF_CLK_PERIOD_WIDTH),
	
	.FIRST_EDGE_DELAY(FIRST_EDGE_DELAY),
	.LAST_EDGE_BEFORE(LAST_EDGE_BEFORE),

	.CLK_TIMES(CLK_TIMES),
	.CLK_TIMES_WIDTH(CLK_TIMES_WIDTH),

	.READ_DELAY_WRITE(READ_DELAY_WRITE),
	.READ_DELAY_WRITE_WIDTH(READ_DELAY_WRITE_WIDTH)
)
U2_slave
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(im_work_en),
	.om_work_end(om_work_end_slave),

	.im_mosi_wire(mosi_wire),
	.im_sclk_wire(sclk_wire),
	.om_miso_wire(miso_wire),

	.im_data_bus(im_data_bus_slave),
	.om_data_bus(om_data_bus_slave)
);


endmodule