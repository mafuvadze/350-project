`timescale 1 ns / 100 ps
module processor_tb();
   reg clock, reset;
	
	wire [31:0] reg1,
					reg2,
					q_imem;
	wire [11:0] PC;
	
	skeleton tester (clock, reset);
	
	assign reg1 = tester.my_regfile.reg_1.out;
	assign reg2 = tester.my_regfile.reg_2.out;
	
	assign PC = tester.address_imem;
	assign q_imem = tester.q_imem;
	
	initial begin
		clock = 0;
		reset = 0;
		
		#1000 $stop;
	end
   
	always #10 clock = ~clock;

endmodule
