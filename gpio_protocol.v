module gpio_protocol (GPIO, clock, data_ready, state, done, message_out, message_in);
	/*
	
	[31:0] 	MESSAGE_DATA
	[32]		SHARED_CLOCK	
	[33]		MESSAGE_DONE
	[34]		State=0 READY
	[35]		State=1 READY
	
	*/
	
	input 				clock,
							data_ready,
							state;
	input [127:0]		message_out;
 			
	inout [35:0]		GPIO;
	
	output 				done;
	output [127:0]		message_in;
		
	wire 					shared_clock,
							reading,
							writting;
							
	wire [31:0]			data_out [3:0];
	
	reg [31:0]			data_in  [3:0];
	reg [2:0]			counter;
	reg					done_reg;
	
	// State
	assign reading  = (state & GPIO[34]) | (~state & GPIO[35]);
	assign writting = (state & GPIO[35])
		| ((state & GPIO[35]) ^ (~state & GPIO[34]));
	
	// Shared clock
	assign GPIO[32] = state ? clock : 1'bz;
	assign shared_clock = GPIO[32];
	
	// Ready signals
	assign GPIO[34] = state ? 1'bz : data_ready;
	assign GPIO[35] = state ? data_ready : 1'bz;
	assign done = done_reg;
	
	// Message
	assign data_out[0] = message_out[31:0];
	assign data_out[1] = message_out[63:32];
	assign data_out[2] = message_out[95:64];
	assign data_out[3] = message_out[127:96];
	
	assign message_in	 = {data_in[3], data_in[2], data_in[1], data_in[0]};
	
	always @(posedge shared_clock) begin
		if (counter > 3) begin
			counter 	= 0;
			done_reg = writting;
		end else if (data_ready) begin
			counter = counter + 1;
			done_reg = 0;
		end else begin
			counter 	= 0;
			done_reg = writting;
		end
		
		if (reading) data_in[counter] = GPIO[31:0];
	end
	
	assign GPIO[31:0] = writting ? data_out[counter] : 32'bz;
	
	initial begin
		counter  <= 0;
		done_reg <= 0;
	end
	
endmodule
