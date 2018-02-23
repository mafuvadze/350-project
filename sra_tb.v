`timescale 1 ns / 100 ps
module sra_tb();
	reg [31:0] in;
	reg [4:0] amt;
	
	wire [31:0] out;
	
	sra test(.out(out), .in(in), .amt(amt));
	
	initial
	begin
		test_1();
		test_2();
		
		$stop;
	end
	
	task test_1;
		begin
			in = 32'd48252424;
			amt = 5'd7;
			
			#300
			
			if (out == (in >> amt)) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
				$display("expected %b got %b", (in >> amt), out);
			end
		end
	endtask
	
	task test_2;
		begin
			in = 32'd48252424;
			amt = 5'd3;
			
			#300
			
			if (out == (in >> amt)) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
				$display("expected %b got %b", (in >> amt), out);
			end
		end
	endtask

	
endmodule
