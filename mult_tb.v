`timescale 1 ns / 100 ps
module mult_tb();
	reg [31:0] multiplicand, multiplier, data_expected;
	reg clock, enable;
	
	wire ready, exception;
	wire [31:0] result;
	
	mult test (result, ready, exception, enable, clock, multiplicand, multiplier);
	
	initial
	begin
		clock = 1'b0;
		test_1();
		//test_2();
		
		$stop;
	end
	
	always
		#10 assign clock = ~clock;
	
	task test_1;
		begin
			  @(negedge clock);
			  assign multiplier = 32'h7FFFFFFF;
			  assign multiplicand = 32'h7FFFFFFF;
			  assign enable = 1'b1;
				assign data_expected = 32'h00000001;

			  @(negedge clock);
			  assign enable = 1'b0;

			  @(posedge result);
			  @(posedge clock);

			  $display("test 11: done");
			  if(result !== data_expected) begin
					$display("**test 11: FAIL; expected: %h, actual: %h;", data_expected, result);
			  end
			  else begin
					$display("test 11: PASS");
			  end
		end
	endtask
	
	task test_2;
		begin
			assign enable = 1'b1;
			assign multiplicand = 32'd78;
			assign multiplier = 32'd13;
			
			#700
			
			$display("result: $d", result);
			assign enable = 1'b0;

		end
	endtask

	
endmodule