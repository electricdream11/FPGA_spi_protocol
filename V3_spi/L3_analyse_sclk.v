module L3_analyse_sclk#(
	parameter CPOL=1'b0,
	parameter HALF_CLK_PERIOD=100,
	parameter HALF_CLK_PERIOD_WIDTH=7,
	parameter FIRST_EDGE_DELAY = 5,
	parameter LAST_EDGE_BEFORE = 5,

	parameter CLK_TIMES = 8,
	parameter CLK_TIMES_WIDTH = 4
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output om_work_end,

	input im_sclk_wire,
	output om_up_edge,
	output om_down_edge

);
	reg sclk_reg;
	reg  [HALF_CLK_PERIOD_WIDTH:0] cnt;
	reg  [CLK_TIMES_WIDTH-1:0] bite_cnt;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		sclk_reg<=CPOL;
	end
	else if(!im_work_en)begin
		sclk_reg<=CPOL;
	end
	else begin
		sclk_reg<=im_sclk_wire;
	end
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt<=1'b0;
	end
	else if(!im_work_en)begin
		cnt<=1'b0;
	end
	else if(sclk_reg==!CPOL)begin
		cnt<=cnt+1'b1;
	end
	else begin
		cnt<=1'b0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bite_cnt<=0;
	end
	else if(!im_work_en)begin
		bite_cnt<=0;
	end
	else if(bite_cnt==CLK_TIMES)begin
		bite_cnt<=bite_cnt;
	end
	else if(cnt==HALF_CLK_PERIOD- LAST_EDGE_BEFORE )begin
		bite_cnt<=bite_cnt+1'b1;
	end
end

assign om_up_edge = (!CPOL)?(cnt==FIRST_EDGE_DELAY)
						:(cnt==HALF_CLK_PERIOD- LAST_EDGE_BEFORE);
assign om_down_edge = (CPOL)?(cnt==FIRST_EDGE_DELAY)
						:(cnt==HALF_CLK_PERIOD- LAST_EDGE_BEFORE);
assign om_work_end = bite_cnt==CLK_TIMES;

endmodule
