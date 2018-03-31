`timescale 1 ns / 100 ps
module processor_tb();
   reg clock, reset;
	
	wire [31:0] reg1,
					reg2,
					reg3,
					reg4,
					reg5,
					r31,
					address_imem,
					pc,
					q_imem,
					temp;
	
	skeleton tester (clock, reset);
	
	assign reg1 = tester.my_regfile.regfile32[1];
	assign reg2 = tester.my_regfile.regfile32[2];
	assign reg3 = tester.my_regfile.regfile32[3];
	assign reg4 = tester.my_regfile.regfile32[4];
	assign reg5 = tester.my_regfile.regfile32[5];
	assign r31 	= tester.my_regfile.regfile32[31];
	
	assign address_imem = {20'b0, tester.address_imem};
	assign pc	= tester.my_processor.pc;
	assign q_imem = tester.q_imem;
	assign temp = tester.my_processor.w_rd;
	
	initial begin
		clock = 0;
		reset = 0;
		
		#2000 $stop;
	end
   
	always #10 clock = ~clock;

endmodule
