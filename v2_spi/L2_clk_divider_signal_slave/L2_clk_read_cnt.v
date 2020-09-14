module L2_clk_read_cnt
#(
	parameter CLK_CNT_HALF_WIDTH=4,
	parameter CLK_CNT_HALF = 10,
	parameter CPOL=1'b0
)
(
	input clk,
	input rst_n,

	input im_SCLK_spi,

	output reg om_up_edge,
	output reg om_down_edge,
	output reg om_high_read,
	output reg om_low_read
);
reg [CLK_CNT_HALF_WIDTH-1:0] cnt;
reg [CLK_CNT_HALF_WIDTH-1:0] cnt2;
reg [3:0] bite_cnt;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt=0;
	end
	else if(im_SCLK_spi==~CPOL)begin
		cnt<=cnt+1'b1;
	end
	else if(im_SCLK_spi==CPOL)begin
		cnt<=1'b0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bite_cnt<=4'd0;
	end
	else if(cnt==1'b1 && im_SCLK_spi==~CPOL)begin			
		bite_cnt<=bite_cnt+1'b1;
	end
	else if(cnt2==CLK_CNT_HALF*3/4 && bite_cnt==4'd8)begin
		bite_cnt<=4'd0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt2<=0;
	end
	else if(im_SCLK_spi==CPOL && bite_cnt!=0)
		cnt2<=cnt2+1'b1;
	else if(im_SCLK_spi==~CPOL)begin
		cnt2<=1'b0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_up_edge<=1'b0;
		om_down_edge<=1'b0;
	end
	else if(cnt==1'b1 || cnt2==1'b1)begin
		om_up_edge<=im_SCLK_spi;
		om_down_edge<=~im_SCLK_spi;
	end
	else begin
		om_up_edge<=1'b0;
		om_down_edge<=1'b0;		
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_high_read<=1'b0;
		om_low_read<=1'b0;
	end
	else if(cnt==CLK_CNT_HALF/2 || cnt2==CLK_CNT_HALF/2)begin
		om_high_read<=im_SCLK_spi;
		om_low_read<=~im_SCLK_spi;
	end
	else begin
		om_high_read<=1'b0;
		om_low_read<=1'b0;
	end	
end
endmodule
