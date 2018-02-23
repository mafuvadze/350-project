module cla_32_tb();
	// Inputs
	reg [31:0] a, b;
	reg c_in;
	
	// Outputs
	wire [31:0] sum;
	wire overflow;
	
	cla_32 test(sum, overflow, a, b, c_in);
 
	// Set initial vals
	initial
	begin
		$display("<< Starting the simulation >>");
		
		test_1();
		test_2();
		test_3();
		
		$stop;
	end
	
	// Test 1
	task test_1;
	begin
		c_in = 1'b0;
		a = 32'd45673475;
		b = 32'd25297629;
		
		#50
		
		$display("Overflow: %d", overflow);
		
		if (sum == (a+b)) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
			$display("Expected %b got %b", (a+b), sum);

		end
	end
	endtask
	
	// Test 2
	task test_2;
	begin
		c_in = 1'b0;
		a = 32'd9075525;
		b = 32'd615815;
		
		#50
		
		$display("Overflow: %d", overflow);
		
		if (sum == (a+b)) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
			$display("Expected %b got %b", (a+b), sum);

		end
	end
	endtask
	
	// Test 3
	task test_3;
	begin
		c_in = 1'b0;
		
		assign a = 32'h80000000;
      assign b = 32'h80000000;
		
		#50
		
		$display("Overflow: %d", overflow);
		$display("Sum: %b", sum);
		if (sum == (a+b)) begin
			$display("PASSED");
		end else begin
			$display("FAILED");
			$display("Expected %b got %b", (a+b), sum);
		end
	end
	endtask
	
endmodule
