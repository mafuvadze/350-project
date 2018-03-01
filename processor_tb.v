`timescale 1 ns / 100 ps
module processor_tb();
   reg clock, reset;
	
	wire [31:0] reg1,
					reg2,
					reg3,
					reg4,
					reg5,
					data,
					q_imem;
	wire [11:0] PC,
					address_dmem;
	wire			wren;
	
	skeleton tester (clock, reset);
	
	assign reg1 = tester.my_regfile.reg_1.out;
	assign reg2 = tester.my_regfile.reg_2.out;
	assign reg3 = tester.my_regfile.reg_3.out;
	assign reg4 = tester.my_regfile.reg_4.out;
	assign reg5 = tester.my_regfile.reg_5.out;
	
	assign data = tester.my_processor.data;
	assign PC = tester.address_imem;
	assign q_imem = tester.q_imem;
	assign wren = tester.my_processor.wren;
	assign address_dmem = tester.my_processor.address_dmem;
	
	initial begin
		clock = 0;
		reset = 0;
		
		#1000 $stop;
	end
   
	always #10 clock = ~clock;

endmodule
