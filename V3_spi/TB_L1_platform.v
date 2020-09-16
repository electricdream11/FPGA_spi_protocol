`timescale 1ns/1ns
module TB_L1_platform;
	reg clk;
	reg rst_n;

	reg work_en;
	wire work_end_master;
	wire work_end_slave;

	reg [7:0] im_data_bus_master;
	reg [7:0] im_data_bus_slave;
	wire [7:0] om_data_bus_master;
	wire [7:0] om_data_bus_slave;

	reg [2:0] cnt;

L1_platform U1_platform
(
	.clk(clk),
	.rst_n(rst_n),

	.im_work_en(work_en),
	.om_work_end_master(work_end_master),
	.om_work_end_slave(work_end_slave),

	.im_data_bus_master(im_data_bus_master),
	.im_data_bus_slave(im_data_bus_slave),
	.om_data_bus_master(om_data_bus_master),
	.om_data_bus_slave(om_data_bus_slave)
);
initial begin:INDEX
	clk=0;
	rst_n=0;
	work_en=0;
	im_data_bus_master=8'b0;
	im_data_bus_slave=8'b0;
	cnt=0;
end

always #2 clk = ~clk;

initial begin
	#10
	rst_n=1;
	#100000
	rst_n=0;
	#10
	$stop;
end

always@(posedge clk)begin
	if(!rst_n)
	work_en=1'b0;
	else if(work_end_master && work_end_slave)
	work_en=1'b0;
	else if(!work_en)
	#40
	work_en=1'b1;
end

always@(posedge work_en)begin
	cnt<=cnt+1'b1;
end

always@(cnt)begin
	case(cnt)
		3'd0: begin im_data_bus_master = 8'h10; im_data_bus_slave=8'h54;end
		3'd1: begin im_data_bus_master = 8'h44; im_data_bus_slave=8'h23;end
		3'd2: begin im_data_bus_master = 8'h21; im_data_bus_slave=8'h75;end
		3'd3: begin im_data_bus_master = 8'h34; im_data_bus_slave=8'h86;end
		3'd4: begin im_data_bus_master = 8'h77; im_data_bus_slave=8'h23;end
		3'd5: begin im_data_bus_master = 8'h88; im_data_bus_slave=8'h56;end
		3'd6: begin im_data_bus_master = 8'h32; im_data_bus_slave=8'h12;end
		3'd7: begin im_data_bus_master = 8'h16; im_data_bus_slave=8'h79;end
	endcase
end
endmodule
