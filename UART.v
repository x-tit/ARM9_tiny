/*UART module
*
	*The frequency of UART data is 9600Hz
	*Threrfore,if the frequency of FPGA is 25MHz,the counter needs to count 25MHz/9600Hz=2604 times
	*change reg [13:0] rx_cnt if it is not enough 
	*
	*
	*
	*
	*
	*
	*  
	*  */

`define COUNTING_TIMES (???????)
`define HALF_COUNTING_TIMES (???????)
module rxtx(
	clk,rst,rx,tx_vld,tx_data,
	rx_vld,rx_data,tx,txrdy);

input clk,rst,rx,tx_vld;
input [7:0] tx_data;

output rx_vld;
output [7:0] rx_data;
output tx;
output txrdy;

//using four register to delay,to synchronise
reg rx1,rx2,rx3,rxx;
always @ (posedge clk) begin
	rx1 <= rx;
	rx2 <= rx1;
	rx3 <= rx2;
	rxx <= rx3;
end

reg rx_dly;
always @ (posedge clk)
	rx_dly <= rxx;

//wether rxx changed or not
wire rx_change;
assign rx_change = (rxx != rx_dly);



/*Counter 
*
	* return to zero when count to COUNTING_TIMES
	* notice that COUNTING_TIMES should be the length of one signal bit
	*
*/
reg [13:0] rx_cnt;
always @ (posedge clk or posedge rst)begin
	if (rst)
		rx_cnt <= 0;
	else if (rx_change |(rx_cnt == COUNTING_TIMES))
		rx_cnt <= 0;
	else 
		rx_cnt <=rx_cnt + 1'b1;
end


//rx_en is the best time to retract data
wire rx_en;
assign rx_en = (rx_cnt==(HALF_COUNTING_TIMES));



//when data_vld is high, it means that there is data
reg datd_vld;
always @ (posedge clk  or posedge rst)begin
	if (rst)
		data_vld <= 1'b0;
	else if (rx_en & ~rxx & ~data_vld) 		//detect the starting zero
		data_vld <.1'b1;			
	else if (data_vld & (data_cnt==4'h9) & rx_en)  //detect the ending one
		data_vld <= 1'b0;
	else ;
end


//Counter ,from 0 to 9,to control the transition of one byte 
reg [3:0] data_cnt;
always @ (posedge clk or posedge rst)begin 
	if(rst)
		data_cnt <=4'b0;
	else if (data_vld)begin 
		if(rx_en)
			data_cnt <= data_cnt+1'b1;
		else ;
	end
	else
		data_cnt <= 4'b0;
end

//
reg [7:0] rx_data;
always @ (posedge clk or posedge rst)begin
	if(rst)
		rx_data <=7'b0;
	else if (data_vld & rx_en & ~data_cnt[3])	//data_cnt[3] means 8,which is the end of the data
		rx_data <={rxx,rx_data[7:1]};		//shift to right
	else;
end
//Other module can retract data when they detect the rx_vld
always @ (posedge clk or posedge rst)begin
	if(rst)

		rx_vld <= 1'b0;
	else
		rx_vld <= data_vld & rx_en & (data_cnt==4'h9);
end

//save tx_data to tx_rdy_data  when both tx_vld and txrdy is one 
//txrdy is one means transmission unit is empty.
reg [7:0] tx_rdy_data;
always @ (posedge clk or posedge rst)begin
	if(rst)
		tx_rdy_data <= 8'b0;
	else if (tx_vld & txrdy)
		tx_rdy_data <= tx_data;
	else;
end


reg tran_vld;
always @ ( posedge clk or posedge rst)begin
	if(rst)
		tran_vld <= 1'b0;
	else if (tx_vld)
		tran_vld <=1'b1;
	else if (tran_vld & rx_en & (tran_cnt == 4'd10))
		tran_vld <= 1'b0
	else ;
end

reg [3:0] tran_cnt
always @ (posedge clk or posedge rst)begin 
	if(rst)
		tran_cnt <= 4'b0;
	else if(tran_vld)
		if(rx_en)
			tran_cnt <= tran_cnt + 1'b1;
		else ;
	else;
	tran_cnt <= 4'b0;
end

reg tx;
always @ (posedge clk or posedge rst )begin
	if(rst)
		tx <=1'b1;
	else if (tran_vld)
		if(rx_en)
			case (tran_cnt)
				4'd0 : tx <= 1'b0;
				4'd1 : tx <= tx_rdy_data[0];
				4'd2 : tx <= tx_rdy_data[1];
				4'd3 : tx <= tx_rdy_data[2];
				4'd4 : tx <= tx_rdy_data[3];
				4'd5 : tx <= tx_rdy_data[4];
				4'd6 : tx <= tx_rdy_data[5];
				4'd7 : tx <= tx_rdy_data[6];
				4'd8 : tx <= tx_rdy_data[7];
				4'd9 : tx <= ^tx_rdy_data;
				4'd10 : tx <=1'b1;
				default :tx <= 1'b1;
			endcase
		else;
	else
		tx<=1'b1;

	assign txrdy = ~tran_vld;	//Tell other modules :don't send data when txrdy is low!!

endmodule
