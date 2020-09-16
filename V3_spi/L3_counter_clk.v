module L3_counter_clk#(
	parameter CPOL=1'b0,
	parameter CLK_TIMES=8,
	parameter CLK_TIMES_WIDTH=4,
	parameter HALF_CLK_PERIOD=100, //real time depends on system clk
	parameter HALF_CLK_PERIOD_WIDTH=7
)
(
	input clk,
	input rst_n,

	input im_work_en,
	output om_work_end,

	output reg om_sclk,
	output om_up_edge,
	output om_down_edge

);
	reg [HALF_CLK_PERIOD_WIDTH-1:0] cnt;
	reg [CLK_TIMES_WIDTH-1:0] bite_cnt;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt<=1'b0;
	end
	else if(!im_work_en)begin
		cnt<=1'b0;
	end
	else if(cnt==HALF_CLK_PERIOD-1'b1)begin
		cnt<=1'b0;
	end
	else begin
		cnt<=cnt+1'b1;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_sclk<=CPOL;
	end
	else if(!im_work_en)begin
		om_sclk<=CPOL;
	end
	else if(bite_cnt==CLK_TIMES)begin
		om_sclk<=CPOL;
	end
	else if(cnt==HALF_CLK_PERIOD-1'b1)begin
		om_sclk<=~om_sclk;
	end
end
assign om_up_edge = (cnt==HALF_CLK_PERIOD-1'b1) && (!om_sclk);
assign om_down_edge = (cnt==HALF_CLK_PERIOD-1'b1) && (om_sclk);

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bite_cnt<=1'b0;
	end
	else if(!im_work_en)begin
		bite_cnt<=1'b0;
	end
	else if(bite_cnt==CLK_TIMES)begin
		bite_cnt<=bite_cnt;
	end
	else if(cnt==HALF_CLK_PERIOD-1'b1 && om_sclk==!CPOL)begin
		bite_cnt<=bite_cnt+1'b1;
	end
end

assign om_work_end = (bite_cnt==CLK_TIMES);
endmodule
