module L3_pluse_create
#(	
	parameter M_OR_S=1'b1, //1:master 0:slave
	parameter CPHA=1'b0,
	parameter READ_DELAY_WRITE = 5'd20, //used to delay read
	parameter READ_DELAY_WRITE_WIDTH = 5
)
(
	input clk,
	input rst_n,

	input im_work_en,
	input im_up_edge,
	input im_down_edge,

	output   om_read_pluse,
	output   om_write_pluse
);
	reg [READ_DELAY_WRITE_WIDTH:0] cnt;
	wire om_read_pluse_temp;

assign om_write_pluse = M_OR_S ? 
						(CPHA ? im_up_edge : im_down_edge)
						:
						((!CPHA) ? im_up_edge : im_down_edge);
assign om_read_pluse_temp = M_OR_S ?
						((!CPHA) ? im_up_edge : im_down_edge)
						:
						(CPHA ? im_up_edge : im_down_edge);

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cnt<=READ_DELAY_WRITE+1'b1;
	end
	else if(!im_work_en)begin
		cnt<=READ_DELAY_WRITE+1'b1;
	end
	else if(om_read_pluse_temp)begin
		cnt<=1'b0;
	end
	else if(cnt==READ_DELAY_WRITE+1'b1)begin
		cnt<=cnt;
	end
	else  begin
		cnt<=cnt+1'b1;
	end
end

assign om_read_pluse =  cnt==READ_DELAY_WRITE;
endmodule
