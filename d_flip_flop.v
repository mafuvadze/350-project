module d_flip_flop(data, reset, clk, Q);
	// Inputs
	input data, reset, clk;
	
	// Outputs
	output reg Q;
		
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			Q <= 1'b0;
		end else begin
			Q <= data;
		end
	end
endmodule
