`timescale 1 ns / 100 ps
module mux_32_tb();
	reg [31:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31;
	reg [4:0] sel;
	
	wire [31:0] out;
	
	mux_32 test_mux(out, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31, sel);
	
	initial
	begin		
		in_0 = 32'b0;
		in_1 = 32'b0;
		in_2 = 32'b0;
		in_3 = 32'b0;
		in_4 = 32'b0;
		in_5 = 32'b0;
		in_6 = 32'b0;
		in_7 = 32'b0;
		in_8 = 32'b0;
		in_9 = 32'b0;
		in_10 = 32'b0;
		in_11 = 32'b0;
		in_12 = 32'b0;
		in_13 = 32'b0;
		in_14 = 32'b0;
		in_15 = 32'b0;
		in_16 = 32'b0;
		in_17 = 32'b0;
		in_18 = 32'b0;
		in_19 = 32'b0;
		in_20 = 32'b0;
		in_21 = 32'b0;
		in_22 = 32'b0;
		in_23 = 32'b0;
		in_24 = 32'b0;
		in_25 = 32'b0;
		in_26 = 32'b0;
		in_27 = 32'b0;
		in_28 = 32'b0;
		in_29 = 32'b0;
		in_30 = 32'b0;
		in_31 = 32'b0;
		
		test_1();
		test_2();
		test_3();
		
		$stop;
	end
	
	task test_1;
	begin
		in_17 = 32'd17;
		sel = 5'b10001;
		#10
		
		if (out == 32'd17) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
		end
	end
	endtask
	
	task test_2;
	begin
		in_23 = 32'd23;
		sel = 5'b10111;
		#10
		
		if (out == 32'd23) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
		end
	end
	endtask
	
	task test_3;
	begin
		in_7 = 32'd7;
		sel = 5'b00111;
		#10
		
		if (out == 32'd7) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
		end
	end
	endtask
	
endmodule
