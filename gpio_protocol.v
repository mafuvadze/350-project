module gpio_protocol (GPIO, CLOCK_50, data_rdy);
	/*
	[3:0] 	MESSAGE_DATA
	[4]		SHARED_CLOCK	
	[5]		MESSAGE_DONE
	
	*/
	
	input 			CLOCK_50,
						data_rdy;
	inout [35:0]	GPIO;
	
	reg [3:0]		comm [31:0]; // Communication register
	reg [4:0]		counter;
	
	always @(posedge CLOCK_50) begin
		if (counter < 5'd31) begin
			counter = 0;
		end else if (data_rdy) begin
			counter = counter + 1;
		end
	end
	assign GPIO[5]   = (counter == 0);
	assign GPIO[3:0] = comm[counter];
	
	initial begin
		counter <= 0;
		comm[0] <= 0;
		comm[1] <= 1;
		comm[2] <= 0;
		comm[3] <= 1;
		comm[4] <= 0;
		comm[5] <= 1;
		comm[6] <= 0;
		comm[7] <= 1;
		comm[8] <= 0;
		comm[9] <= 1;
		comm[10] <= 0;
		comm[11] <= 1;
		comm[12] <= 0;
		comm[13] <= 1;
		comm[14] <= 0;
		comm[15] <= 1;
		comm[16] <= 0;
		comm[17] <= 1;
		comm[18] <= 0;
		comm[19] <= 1;
		comm[20] <= 0;
		comm[21] <= 1;
		comm[22] <= 0;
		comm[23] <= 1;
		comm[24] <= 0;
		comm[25] <= 1;
		comm[26] <= 0;
		comm[27] <= 1;
		comm[28] <= 0;
		comm[29] <= 1;
		comm[30] <= 0;
		comm[31] <= 1;
	end
	
endmodule
