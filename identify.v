assign code_is_mrs = ({code[27:23],code[21:20],code[7],code[4]}==9'b000100000);
assign code_is_msr0 = ({code[27:23],code[21:20],code[7],code[4]}==9'b000101000);
/*
*
	* DP0
	* when code[24:23]==2'b10,DP0 is used to compare,which affects CPSR
	* register ONLY and code[20] must be 1'b1(code[20] determine wether
	* change CPSR or not.)
*/
assign code_is_dp0=(({code[27:23],code[4]}==4'b0000)&(code[24:23]!=2'b10|code[20]));

assign code_is_bx = ({code[27:23],code[20],code[7],code[4]}==8'b00010001);
assign code_is_dp1 = ({code[27:25],code[7],code[4]}==5'b00001)&(code[24:23]!=2'b10|code[20]));
assign code_is_mult=({codep[27:23],code[7:4]}==9'b000001001);
assign code_is_multl=({code[27:23],code[7:4]}==9'b000011001);
assign code_is_swp=({code[27:23],code[7:4]}==9'b000101001);
assign code_is_ldrh0 = ({code[27:25],code[22],code[7:4]}==8'b00011011);
assign code_is_ldrh1 = ({code[27:25],code[22],code[7:4]}==8'b00001011);
assign code_is_ldrsb0 = ({code[27:25],code[22],code[7:4]}==8'b00011101);
assign code_is_ldrsb1 = ({code[27:25],code[22],code[7:4]}==8'b00001101);
assign code_is_ldrsh0 = ({code[27:25],code[22],code[7:4]}==8'b00001111);
assign code_is_ldrsh1 = ({code[27:25],code[22],code[7:4]}==8'b00011111);
assign code_is_msr1 = ({code[27:23],code[20]}==6'b001100);
assign code_is_dp2 = (code[27:25]==3'b001)&((code[24:23]!=2'b10)|code[20]);
assign code_is_ldr0=(code[27:25]==3'b010);
assign code_is_ldr1=(code[27:25]==3'b011);
assign code_is_ldm=(code[27:25]==3'b100);
assign code_is_b=(code[27:25]==3'b101);
assign code_is_swi=(code[27:25]==3'b111);

/* using all_code to identify undefined instructions,all_code is 1'b1 when it is a defined instuction */

always @ (*)begin
if (code[27:25]==3'b0)
	if(~code[4])
		if((code[24:23]==2'b10)&~code[20])
			if(~code[21])
				//MRS
				all_code=(code[19:16]==4'hf)&(code[11:0]==12'b0);
			else
				//MSR0
				all_code=(code[18:17]==2'b0)&(code[15:12]==4'hf)&(code[11:4]==8'h0);
		else
			//dp0
			all_code=(code[24:23]!=2'b10)|code[20];
	else if(~code[7])
	       if(code[24:20]==5'b10010)
		       //BX
			all_code=(code[19:4]==16''hfff1);	       
		else
			//dp1
			all_code=(code[24:23]!=2'b10)|code[20];
	else if(code[6:5]==2'b0)
		if(code[24:22]==3'b0)
			//MULT
			all_code= 1'b1;
		else if (code[24:23]==2'b01)
			//MULTL
			all_code=1'b1;
		else if (code[24:23]==2'b10)
			//SWP
			all_code=(code[21:20]==2'b0)&(code[11:8]==4'b0);
		else
			all_code=1'b0;
	else if(code[6:5]==2'b01)
		if({code[22],code[11:8]}==5'b0)
			//LDRH0
			all_code=1'b1;
		else 
			//LDRH1
			all_code=1'b1;
	else if(code[6:5]==2'b10)
		if(code[11:8]==4'b0)
			//LDRSB0
			all_code=(~code[22])&(code[20]);
		else 
			//LDRSB1
			all_code=code[22]&code[20];
	else
		if(code[11:8]==4'b0)
			//LDRSH0
			all_code=(~code[22])&(code[20]);
		else
			//LDRSH1
			all_code=code[22]&code[20];
else if (code[27:25]==3'b001)
	if((code[24:23]==2'b10)&(~cod[20]))
		//MSR1
		all_code=code[21]&(code[18:17]==2'b0)&(code[15:12]==4'hf);
	else
		//dp2
		all_code=(code[24:23]!=2'b10)|code[20];
else if(code[27:25]==3'b010)
	//LDR0
	all_code=1'b1;
else if(code[27:25]==3'b011)
	//LDR1
	all_code=~code[4];
else if(code[27:25]==3'b100)
	//LDM
	all_code=1'b1;
else if(code[27:25]==3'b101)
	//B
	all_code=1'b1;
else if(code[27:25]==3'b111)
	//SWI
	all_code=code[24];
else
	all_code=0'b0;
end

else if(code[27:25]==3'b100)



