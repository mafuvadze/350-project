module gpio_protocol (GPIO, CLOCK_50, clock);
	/*
	[15:0] 	MESSAGE_DATA
	[16]		SHARED_CLOCK	
	
	
	*/
	
	inout [35:0]	GPIO;
	input 			CLOCK_50;
	output 			clock;
	
	reg 				fpga_state; // Leader or Follower
	
	wire 				LEADER,
						FOLLOWER;
	
	// Leader selection						
	assign LEADER 	 = 0;
	assign FOLLOWER = 1;
	
	initial begin
		if (GPIO[30]) fpga_state = FOLLOWER;
		else fpga_state = LEADER;
	end
	
	// Pin assignments for leader
	assign GPIO[30] = fpga_state ? 1'bz : 1'b1; 		// Indicate leader chosen
	assign GPIO[16] = fpga_state ? 1'bz : CLOCK_50; // Set shared clock
	
	assign clock = GPIO[16];
	
endmodule
