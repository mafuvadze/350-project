module DX_latch (
	out_PC_next,											//	32-bit PC of next instr
	out_ctrl_signals,										//	10-bit signals for muxes
	out_immediate,											// 32-bit signed extended integer
	out_instr,
	out_data_readRegA,
	out_data_readRegB,
	wren,
	clock,
	reset,
	in_PC_next,
	in_ctrl_signals,
	in_immediate,
	in_instr,
	in_data_readRegA,
	in_data_readRegB
);
	
	input [31:0] 		in_data_readRegA,
							in_data_readRegB,
							in_instr,
							in_PC_next,
							in_immediate;
	input [11:0]		in_ctrl_signals;
	input 				wren,
							clock,
							reset;
	
	output [31:0]		out_data_readRegA,
							out_data_readRegB,
							out_instr,
							out_PC_next,
							out_immediate;
	output [11:0]		out_ctrl_signals;
	
	wire [31:0]			temp_ctrls;
	wire					HIGH;
	
	assign out_ctrl_signals = temp_ctrls[11:0];
	
	register regA (
		.data(in_data_readRegA),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_data_readRegA)
	 );
	 
	 register regB (
		.data(in_data_readRegB),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_data_readRegB)
	 );
	
	register instr_reg (
		.data(in_instr),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_instr)
	 );
	 
	 register PC_next_reg (
		.data(in_PC_next),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_PC_next)
	 );
	 
	 register ctrl_signals_reg (
		.data({20'b0, in_ctrl_signals}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_ctrls)
	 );
	 
	 register imm_reg (
		.data(in_immediate),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_immediate)
	 );
	
endmodule
