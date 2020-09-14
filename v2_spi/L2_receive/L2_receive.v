module L2_receive(
	input clk,
	input rst_n,
	input im_work_en,

	input im_work_pluse,
	input im_data,
	output reg [7:0] om_data,
	output reg om_finish
);
	reg [3:0] bite_cnt;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_data<=8'b0;
		bite_cnt<=3'd0;
	end
	else if(!im_work_en)begin
		bite_cnt<=3'd0;
	end
	else if(im_work_pluse)begin
		om_data[bite_cnt]<=im_data;
		if(bite_cnt==3'd7)
		bite_cnt<=3'd0;
		else 
		bite_cnt<=bite_cnt+1'b1;
	end
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_finish<=1'b0;
	end
	else if(bite_cnt==3'd7)begin
		om_finish<=1'b1;
	end
	else if(bite_cnt==3'd0) begin //here make sure data safe
		om_finish<=1'b0;
	end
end

endmodule
