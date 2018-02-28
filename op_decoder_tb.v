module op_decoder_tb ();
	reg [31:0]	instr;
	reg [4:0]  	counter;
		
	wire 			branch,
					j1,
					j2,
					weDM,
					weReg,
					weRegDM,
					ALUop,
					immediate,
					weStatus,
					weReturn;
	reg 			clock;
					
	op_decoder test (
		branch,
		j1,
		j2,
		weDM,
		weReg,
		weRegDM,
		ALUop,
		immediate,
		weStatus,
		weReturn,
		{counter, 27'b0}
	);
	
	initial
	begin
		clock = 0;
		counter = 5'b0;
		#400 $stop;
	end
	
	always @(posedge clock) begin
			$display ("opcode: %b, ---> %b%b%b%b%b%b%b%b%b%b",
				counter, branch, j1, j2, weDM, weReg, weRegDM, ALUop, immediate, weStatus, weReturn);
			
			counter = counter + 1;
		end
	
	always #10 clock = ~clock;

endmodule
