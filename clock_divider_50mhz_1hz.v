module clock_divider_50mhz_1hz (in_clock, out_clock);
	input 	in_clock;
	output 	out_clock;
	
	reg [24:0] counter;
	reg clkout;
	
	initial begin
		 counter = 0;
		 clkout  = 0;
	end
	
	always @(posedge in_clock) begin
		 if (counter == 0) begin
			  counter <= 24999999;
			  clkout <= ~clkout;
		 end else begin
			  counter <= counter - 1;
		 end
	end
	
	assign out_clock = clkout;
	
endmodule
