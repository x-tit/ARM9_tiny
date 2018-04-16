//Using one period pulse to produce four period pulse
module one2four (clk,rst,a,b);
input clk;
input rst;
input a;	//input signal ,one period
output b;	//output signal ,four period

reg b;
reg [1:0] cnt;

always @ (posedge clk or posedge rst)begin
	if(rst)
		b <= 1'b0;
	else if (a)
		b <= 1'b1;
	else if (cnt == 2'b11)
		b <= 1'b0;
	else;
end

always @ (posedge clk or posedge rst)begin
	if (rst)
		cnt <= 2'b0;
	else if (b)
		cnt  <= cnt +1'b1;
	else
		cnt <= 2'b0;
end

endmodule


