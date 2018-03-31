module register(
	data,
	enable,
	reset,
	clk,
	out
);

	input [31:0] 	data;

	input 			reset,
						clk,
						enable;

	output [31:0] 	out;

	reg [31:0]		register;
	
	always @(posedge clk) begin
		if (reset) register = 0;
		else if (enable) register = data;
	end
	
endmodule
