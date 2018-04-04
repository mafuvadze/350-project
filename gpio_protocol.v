module gpio_protocol (GPIO, CLOCK_50, clock);
	inout [35:0]	GPIO;
	input 			CLOCK_50;
	output 			clock;
	
	reg 				fpga_state; // Leader or Follower
	
	wire 				LEADER,
						FOLLOWER;
							
	assign LEADER 	 = 0;
	assign FOLLOWER = 1;
	
	initial begin
		if (GPIO[30]) fpga_state = FOLLOWER;
		else fpga_state = LEADER;
	end
	
	assign GPIO[30] = fpga_state ? 1'bz : 1'b1; 
endmodule
