`timescale 1ns/1ns
`define DEL 2
module arm6(
	clk,
	cpu_en,
	cpu_restart,
	fiq,
	irq,
	ram_abort,
	ram_rdata,
	rom_abort,
	rom_data,
	rst,

	ram_addr,
	ram_cen,
	ram_flag,
	ram_wdata,
	ram_wen,
	rom_addr,
	rom_en
);

input 		clk;
input 		cpu_en;
input 		cpu_restart;
input 		fiq;
input 		irq;
input 		ram_abort;
input [31:0] 	ram_rdata;
input 		rom_abort;
input [31:0]	rom_data;
input 		rst;

output [31:0]	ram_addr;
output 		ram_cen;
output 		ram_wen;
output [3:0]	ram_flag;
output [31:0]	ram_wdata;
output 		rom_en;
output [31:0] 	rom_addr;


/*Register definition area*/
reg 		add_flag;
reg 		all_code;
reg [3:0]	cha_num;
reg 		cha_vld;
reg 		cmd;
reg [31:0]	cmd_addr;
reg 		cmd_flag;
reg 		code_flag;
reg 		code_abort;
reg [31:0]	code_rm;
reg [31:0]	code_rma;
reg [4:0]	code_rot_num;
reg [31:0] 	code_rs;
reg [2:0] 	code_rs_flag;
reg [31:0]	code_rsa;
reg 		code_und;
reg 		cond_satisfy;
reg 		cpsr_c;
reg 		cpsr_f;
reg 		cpsr_i;
reg 		cpsr_n;
reg 		cpsr_v;
reg 		cpsr_z;
reg [4:0]	cpsr_m;
reg [31:0]	dp_ans;
reg 		extra_num;
reg 		fig_flag;
reg [31:0]	go_data;
reg [5:0] 	go_fmt;
reg [3:0] 	go_num;
reg 		go_vld;
reg 		hold_en_dly;
reg 		irq_flag;
reg 		ldm_change;
reg [3:0] 	ldm_num;
reg [3:0] 	ldm_sel;
reg 		ldm_usr;
reg 		ldm_vld;
reg 		multl_extra_num;
reg 		multl_z;
reg [31:0]	r0;
reg [31:0]	r1;
reg [31:0]	r2;
reg [31:0]	r3;
reg [31:0]	r4;
reg [31:0]	r5;
reg [31:0]	r6;
reg [31:0]	r7;
reg [31:0]	r8_fiq;
reg [31:0]	r8_usr;
reg [31:0]	r9_fiq;
reg [31:0]	r9_usr;
reg [31:0]	ra_fiq;
reg [31:0]	ra_usr;
reg [31:0]	ram_flag;
reg [31:0]	ram_wdata;
reg [31:0]	rb_fiq;
reg [31:0]	rb_usr;
reg [31:0]	rc_fiq;
reg [31:0]	rc_usr;
reg [31:0]	rd;
reg [31:0]	rd_abt;
reg [31:0]	rd_fiq;
reg [31:0]	rd_irq;
reg [31:0]	rd_svc;
reg [31:0]	rd_und;
reg [31:0]	rd_usr;
reg [31:0]	re;
reg [31:0]	re_abt;
reg [31:0]	re_fiq;
reg [31:0]	re_irq;
reg [31:0]	re_svc;
reg [31:0] 	re_und;
reg [31:0]	re_usr;
reg [63:0]	reg_ans;
reg [31:0]	rf;
reg  		rm_msb;
reg [31:0]	rn;
reg [31:0] 	rn_register;
reg [31:0] 	rna;
reg [31:0] 	rnb;
reg 		rs_msb;
reg [31:0] 	sec_operand;
reg [10:0]	spsr;
reg [10:0]	spsr_abt;
reg [10:0]	spsr_fiq;
reg [10:0]	spsr_irq;
reg [10:0]	spsr_svc;
reg [10:0]	spsr_und;
reg [4:0]	sum_m;
reg [31:0] 	to_data;
reg [3:0] 	to_num;



//wire definition area

wire [31:0]	and_ans;
wire [31:0]	bic_ans;
wire 		bit_cy;
wire 		bit_ov;
wire 		cha_rf_vld;
wire 		cmd_is_b;
wire 		cmd_is_bx;
wire 		cmd_is_dp0;
wire 		cmd_is_dp1;
wire 		cmd_is_dp2;
wire 		cmd_is_ldm;
wire 		cmd_is_ldr0;
wire 		cmd_is_ldr1;
wire 		cmd_is_ldrh0;
wire 		cmd_is_ldrh1;
wire 		cmd_is_ldrsb0;
wire 		cmd_is_ldrsb1;
wire 		cmd_is_ldrsh0;
wire 		cmd_is_ldrsh1;
wire 		cmd_is_mrs;
wire 		cmd_is_mrs0;
wire 		cmd_is_mrs1;
wire 		cmd_is_mult;
wire 		cmd_is_multl;
wire 		cmd_is_multx;
wire 		cmd_is_swi;
wire 		cmd_is_swp;
wire 		cmd_is_swpx;
wire 		cmd_ok;
wire [4:0]	cmd_sum_m;
wire [31:0] 	code;
wire 		code_is_b;
wire 		code_is_bx;
wire 		code_is_dp0;
wire 		code_is_dp1;
wire 		code_is_dp2;
wire 		code_is_ldm;
wire 		code_is_ldr0;
wire 		code_is_ldr1;
wire 		code_is_ldrsb0;
wire 		code_is_ldrsb1;
wire 		code_is_ldrsh0;
wire 		code_is_ldrsh1;
wire 		code_is_mrs;
wire 		code_is_mrs0;
wire 		code_is_mrs1;
wire 		code_is_mult;
wire 		code_is_multl;
wire 		code_is_swi;
wire 		code_is_swp;
wire 		code_rm_num;
wire 		code_rm_vld;
wire 		code_rn_num;
wire 		code_rn_vld;
wire [3:0]	code_rnhi_num;
wire 		code_rnhi_vld;
wire [3:0] 	code_rs_num;
wire 		code_rs_vld;
wire [4:0] 	code_sum_m;
wire [10:0]	cpsr;
wire [1:0]	cy_high_bits;
wire [31:0]	eor_ans;
wire 		fiq_en;
wire 		go_rf_vld;
wire 		high_bit;
wire 		hold_en;
wire 		hold_en_rising;
wire 		int_all;
wire 		irq_en;
wire [31:0]	ldm_data;
wire 		ldm_rf_vld;
wire [63:0] 	mult_ans;
wire [31:0]	or_ans;
wire [31:0]	r8;
wire [31:0]  	r9;
wire [31:0]  	ra;
wire [31:0]	ram_addr;
wire 		ram_cen;
wire 		ram_wen;
wire [31:0]	rb;
wire [31:0] 	rc;
wire [31:0] 	rf_b;
wire [31:0] 	rom_addr;
wire 		rom_en;
wire [31:0]	sum_middle;
wire [31:0]	sum_rn_rm;
wire 		to_rf_vld;
wire 		to_vld;
wire 		wait_en;


