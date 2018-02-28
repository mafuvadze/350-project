module MW_latch (
	out_ALU_result,
	out_data_read,
	out_rd,
	out_ctrl_signals,
	wren,
	clock,
	reset,
	in_ALU_result,
	in_data_read,
	in_rd,
	in_ctrl_signals
);

	input [31:0] 		in_ALU_result,
							in_data_read;
	input [11:0]		in_ctrl_signals;
	input [4:0]			in_rd;
	input 				wren,
							clock,
							reset;
								
	output [31:0] 		out_ALU_result,
							out_data_read;
	output [11:0]		out_ctrl_signals;
	output [4:0]		out_rd;
	
	wire [31:0]			temp_ctrls,
							temp_rd;
	
	assign out_ctrl_signals = temp_ctrls[11:0];
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
		.data({20'b0, in_ctrl_signals}),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(temp_ctrls)
	 );

	
endmodule
