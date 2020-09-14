module L2_clk_cnt#(
	parameter CLK_CNT_HALF_WIDTH=4, //2^CLK_CNT_HALF_WIDTH=16 > 10  ? ok : no ;
	parameter CLK_CNT_HALF = 10, 
	parameter CPOL =1'b0
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output reg om_clk_cnt,
	output reg om_up_edge,
	output reg om_down_edge,
	output reg om_high_read,
	output reg om_low_read
);
reg [CLK_CNT_HALF_WIDTH-1:0] cnt;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt<=0;
	end
	else if(cnt==CLK_CNT_HALF-1'b1)begin
		cnt<=0;
	end
	else if(im_work_en)begin
		cnt<=cnt+1'b1;
	end
	else if(!im_work_en)begin
		cnt<=1'b0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_clk_cnt<=CPOL;
	end
	else if(!im_work_en)begin
		om_clk_cnt<=CPOL;
	end
	else if(cnt==CLK_CNT_HALF-1'b1)begin
		om_clk_cnt<=~om_clk_cnt;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_up_edge<=1'b0;
		om_down_edge<=1'b0;
		om_high_read<=1'b0;
		om_low_read<=1'b0;
	end
	else if(cnt==CLK_CNT_HALF-1'b1)begin
		om_up_edge<=~om_clk_cnt;
		om_down_edge<=om_clk_cnt;
	end
	else if(cnt==CLK_CNT_HALF/2-1'b1)begin
		om_high_read<=om_clk_cnt;
		om_low_read<=~om_clk_cnt;
	end
	else begin
		om_up_edge<=1'b0;
		om_down_edge<=1'b0;
		om_high_read<=1'b0;
		om_low_read<=1'b0;
	end
end

endmodule
