`timescale 1 ns / 100 ps
module d_flip_flop_tb();
	// Inputs
	reg data, reset, clk;
	
	// Outputs
	wire Q;
	
	// Instantiate
	d_flip_flop test(.data(data), .reset(reset), .clk(clk), .Q(Q));
	
	// Set initial vals
	initial
	begin
		$display($time, "<< Starting the simulation >>");
		$monitor(data, reset, clk, Q);
		
		#10
		data=1'b0;
		reset=1'b0;
		clk=1'b0;
		
		#80; // Wait _ ns
		//$stop;
	end
	
	// Test inputs
	always
		#40 data=~data;
	always
		#20 reset=~reset;
	always
		#10 clk=~clk;
endmodule
