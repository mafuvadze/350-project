module comp_32_tb();
	reg [31:0] in_0, in_1;
	reg enable;
	wire neq, lt;
	
	comp_32 test(.isNotEqual(neq), .isLessThan(lt), .enable(enable), .in_0(in_0), .in_1(in_1));
	
	initial
	begin
		test_1();
		test_2();
		
		$stop;
	end
	
	task test_1;
		begin
			enable = 1'b1;
			in_0 = 32'd45;
			in_1 = 32'd45;
			
			#50
			
			if (neq == 1'b0 && lt == 1'b0) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
			end
		end
	endtask
	
	task test_2;
		begin
			enable = 1'b1;
			in_0 = 32'd87;
			in_1 = 32'd458;
			
			#50
			
			if (neq == 1'b1 && lt == 1'b1) begin
				$display("PASSED");
			end else begin
				$display("FAILED");
			end
		end
	endtask
	
endmodule
