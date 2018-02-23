`timescale 1 ns / 100 ps
module bitwise_and_tb();
	reg [31:0] in_0, in_1;
	wire [31:0] out_0, out_1;
	
	bitwise_or bw_or(.out(out_0), .in_1(in_1), .in_0(in_0));
	bitwise_and bw_and(.out(out_1), .in_1(in_1), .in_0(in_0));
	
	initial
	begin
		test_1();
		test_2();
		test_3();
		
		$stop;
	end
	
	task test_1;
		begin
			in_0 = 32'd1646;
			in_1 = 32'd5184;
			#10
			
			$display("<< BITWISE OR TEST >>");
			if (out_0 == 32'd5742) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd5742, out_0);
			end
			
			$display("<< BITWISE AND TEST >>");
			if (out_1 == 32'd1088) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd1088, out_1);
			end
		end
	endtask
	
	task test_2;
		begin
			in_0 = 32'd783424;
			in_1 = 32'd8472456;
			#10
			
			$display("<< BITWISE OR TEST >>");
			if (out_0 == 32'd9172936) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd9172936, out_0);
			end
			
			$display("<< BITWISE AND TEST >>");
			if (out_1 == 32'd82944) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd82944, out_1);
			end
		end
	endtask
	
	task test_3;
		begin
			in_0 = 32'd267482;
			in_1 = 32'd817648;
			#10
			
			$display("<< BITWISE OR TEST >>");
			if (out_0 == 32'd818682) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd818682, out_0);
			end
			
			$display("<< BITWISE AND TEST >>");
			if (out_1 == 32'd266448) begin
				$display("PASSED");
			end else begin
				$display("FAILED: expected %d got %d", 32'd266448, out_1);
			end
		end
	endtask
	
endmodule
