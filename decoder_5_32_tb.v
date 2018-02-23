module decoder_5_32_tb();
	// Inputs
	reg [4:0] in;
	
	// Outputs
	wire out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31;
	
	// Instantiate
	decoder_5_32 test(out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31, in[0], in[1], in[2], in[3], in[4]);
	
	
	initial 
	begin	
		test_1();
		test_2();
		test_3();
		
		$stop;
	end
	
	task test_1;
	begin
		$display("Starting testing 1 with value 00011");
		in = 5'b00011;
		#10
		$display(out_31, out_30, out_29, out_28, out_27, out_26, out_25, out_24, out_23, out_22, out_21, out_20, out_19, out_18, out_17, out_16, out_15, out_14, out_13, out_12, out_11, out_10, out_9, out_8, out_7, out_6, out_5, out_4, out_3, out_2, out_1, out_0);
	end
	endtask
	
	task test_2;
	begin
		$display("Starting testing 1 with value 00101");
		in = 5'b00101;
		#10
		$display(out_31, out_30, out_29, out_28, out_27, out_26, out_25, out_24, out_23, out_22, out_21, out_20, out_19, out_18, out_17, out_16, out_15, out_14, out_13, out_12, out_11, out_10, out_9, out_8, out_7, out_6, out_5, out_4, out_3, out_2, out_1, out_0);
	end
	endtask
	
	task test_3;
	begin
		$display("Starting testing 1 with value 01000");
		in = 5'b01000;
		#10
		$display(out_31, out_30, out_29, out_28, out_27, out_26, out_25, out_24, out_23, out_22, out_21, out_20, out_19, out_18, out_17, out_16, out_15, out_14, out_13, out_12, out_11, out_10, out_9, out_8, out_7, out_6, out_5, out_4, out_3, out_2, out_1, out_0);
	end
	endtask
	
endmodule
