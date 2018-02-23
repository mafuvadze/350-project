`timescale 1 ns / 100 ps
module div_tb();
	reg [31:0] dividend, divisor, data_expected;
	reg clock, enable;
	
	wire ready, exception;
	wire [31:0] result;
	
	div tester (result, ready, exception, enable, clock, dividend, divisor);
	
	initial
	begin
		clock = 1'b0;
		test_1();
		
		$stop;
	end
	
	always
		#10 assign clock = ~clock;
	
	task test_1;
		begin
			 $display("test 11: starting (small division)");
			  @(negedge clock);
			  assign dividend = 32'd10;
			  assign divisor = 32'd2;
			  assign enable = 1'b1;
			  assign data_expected = 32'd5;

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
		  
		  $stop;
		end
	endtask
endmodule
