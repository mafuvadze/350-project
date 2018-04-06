module gpio_protocol (GPIO, clock, data_rdy, state);
	/*
	
	[31:0] 	MESSAGE_DATA
	[32]		SHARED_CLOCK	
	[33]		MESSAGE_DONE
	[34]		State=0 READY
	[35]		State=1 READY
	
	*/
	
	input 				clock,
							data_rdy;
 			
	inout [35:0]		GPIO;
	
	input					state;
	
	wire 					shared_clock;
	
	reg [31:0]	data_in [3:0];  // Communication output register
	reg [31:0]	data_out [3:0]; // Communication input register
	reg [2:0]			counter;
	
	// State
	assign GPIO[34] = state ? 1 : 1'bz;
	
	// Shared clock
	assign GPIO[32] = state ? clock : 1'bz;
	assign shared_clock = GPIO[32];
	
	always @(posedge shared_clock) begin
		if (counter > 3) begin
			counter = 0;
		end else if (data_rdy) begin
			counter = counter + 1;
		end
		
		if (~state)  begin
			data_in[counter] = GPIO[31:0];
		end
	end
	
	assign GPIO[31:0] = state ? data_out[counter] : 32'bz;
	
	initial begin
		counter <= 0;
		
		data_out[0] <= 10;
		data_out[1] <= 6;
		data_out[2] <= 10;
		data_out[3] <= 6;
	end
	
endmodule
