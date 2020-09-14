module L2_send(
	input clk,
	input rst_n,
	
	input im_work_en,
	input im_work_pluse,
	input [7:0] im_data,
	output reg om_data,
	output reg om_finish
);
	reg [3:0] bite_cnt;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		om_data<=1'b1;
		bite_cnt<=1'b0;
	end
	else if(!im_work_en)begin
		bite_cnt<=1'b0;
	end
	else if(im_work_pluse)begin
		om_data<=im_data[bite_cnt];

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
	else if(bite_cnt==3'd0) begin
		om_finish<=1'b0;
	end
end
endmodule
