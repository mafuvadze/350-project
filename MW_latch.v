module MW_latch (
	out_ALU_result,
	out_data_read,
	out_rd,
	out_ctrl_signals,
	out_PC_next,
	wren,
	clock,
	reset,
	in_ALU_result,
	in_data_read,
	in_rd,
	in_ctrl_signals,
	in_PC_next
);

	input [31:0] 		in_ALU_result,
							in_data_read,
							in_PC_next;
	input [13:0]		in_ctrl_signals;
	input [4:0]			in_rd;
	input 				wren,
							clock,
							reset;
								
	output [31:0] 		out_ALU_result,
							out_data_read,
							out_PC_next;
	output [13:0]		out_ctrl_signals;
	output [4:0]		out_rd;
	
	wire [31:0]			temp_ctrls,
							temp_rd;
	
	assign out_ctrl_signals = temp_ctrls[13:0];
	assign out_rd = temp_rd[4:0];
	
	 register rd (
		.data({27'b0, in_rd}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_rd)
	 );
	 
	  register data_read (
		.data(in_data_read),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_data_read)
	 );
	 
	  register ALU_result (
		.data(in_ALU_result),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_ALU_result)
	 );
	 
	 register ctrls (
		.data({18'b0, in_ctrl_signals}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_ctrls)
	 );
	 
	 register PC_next (
		.data(in_PC_next),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_PC_next)
	 );

	
endmodule
