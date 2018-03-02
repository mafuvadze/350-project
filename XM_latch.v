module XM_latch (
	out_PC_next,
	out_PC_plus1,
	out_ctrl_signals,									
	out_ALU_result,
	out_data_reg,
	out_rd,
	wren,
	clock,
	reset,
	in_PC_next,
	in_PC_plus1,
	in_ctrl_signals,
	in_ALU_result,
	in_data_reg,
	in_rd
);

	input [31:0]			in_PC_next,
								in_ALU_result,
								in_PC_plus1,
								in_data_reg;
	input [13:0]			in_ctrl_signals;
	input [4:0]				in_rd;
	input 					wren,
								clock,
								reset;
	
	output [31:0]			out_PC_next,
								out_ALU_result,
								out_PC_plus1,
								out_data_reg;
	output [13:0]			out_ctrl_signals;
	output [4:0] 			out_rd;
	
	wire [31:0]				temp_ctrls,
								temp_rd;
	
	assign out_ctrl_signals = temp_ctrls[13:0];
	assign out_rd = temp_rd[4:0];
	
	 register PC_next (
		.data(in_PC_next),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_PC_next)
	 );
	 
	 register ALU_res (
		.data(in_ALU_result),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_ALU_result)
	 );
	 
	 register ctrl_sigs (
		.data({18'b0, in_ctrl_signals}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_ctrls)
	 );
	 
	 register data_reg (
		.data(in_data_reg),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_data_reg)
	 );
	 
	 register rd (
		.data({27'b0, in_rd}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_rd)
	 );
	 
	 register PC_plus1 (
		.data(in_PC_plus1),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_PC_plus1)
	 );
	
endmodule
