`timescale 1 ns / 100 ps
module sr1_tb();
	reg [31:0] in;
	reg enable;
	
	wire [31:0] out;
	
	sr1 test(.out(out), .in(in), .enable(enable));
	
	initial
	begin
		test_1();
		test_2();
		
		$stop;
	end
	
	task test_1;
		begin
			in = 32'd45;
			enable = 1'b1;
			
			#10
			
			if (out == (in >> 1)) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
				$display("expected %b got %b", (in >> 1), out);
			end
		end
	endtask
	
	task test_2;
		begin
			enable = 1'b0;
			
			#10
			
			if (out == in) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
				$display("expected %b got %b", in, out);
			end
		end
	endtask

	
endmodule
