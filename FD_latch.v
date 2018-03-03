module FD_latch (
	out_IR,
	out_PC_next,
	wren,
	clock,
	reset,
	in_IR,
	in_PC_next
);

	input [31:0] 	in_IR,
						in_PC_next;
	input			 	wren,
						clock,
						reset;
	
	output [31:0] 	out_IR,
						out_PC_next;
							
	assign LOW = 1'b0;
						
	register PC_reg (
		.data(in_PC_next),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_PC_next)
	);
	
	register IR_reg (
		.data(in_IR),
		.enable(wren),
		.reset(reset),
		.clk(clock),
		.out(out_IR)
	);

endmodule
