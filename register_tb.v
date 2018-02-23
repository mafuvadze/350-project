`timescale 1 ns / 100 ps
module register_tb();
	// Inputs
	reg [31:0] data;
	reg enable, reset, clk;
	
	// Outputs
	wire [31:0] out;
	
	register test (data, enable, reset, clk, out);	

	initial
	begin
		$display("<< Starting the simulation >>");
		
		enable=1'b0;
		data=32'd0;
		reset=1'b0;
		clk=1'b1;
		
		test_1();
		test_2();
		test_3();
		
		$stop;
	end
	
	// Test 1
	task test_1;
	begin
		enable = 1'b1;
		data = 32'd45;
		reset = 1'b0;
		clk = 1'b1;
		#10
		
		$display("out: %h", out);
		if (out !== 32'd45) begin
			$display("Error: expected reg to have value 45");
		end
	end
	endtask
	
	// Test 2
	task test_2;
	begin
		enable=1'b0;
		data=32'd67;
		reset=1'b0;
		clk=1'b0;
		#10
		
		$display("out: %h", out);
		if (out !== 32'd45) begin
			$display("Error: expected reg to have value 45");
		end
	end
	endtask
	
	// Test 3
	task test_3;
	begin
		enable=1'b1;
		data=32'd98;
		reset=1'b1;
		clk=1'b1;
		#10
		
		$display("out: %h", out);
		if (out !== 32'd0) begin
			$display("Error: expected reg to have value 0");
		end
	end
	endtask
	
endmodule