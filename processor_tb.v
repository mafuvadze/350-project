`timescale 1 ns / 100 ps
module processor_tb();
   reg clock, reset;
	
	wire [31:0] reg1,
					reg2,
					reg3,
					reg4,
					reg5,
					rstatus,
					r31,
					data,
					data_writeReg,
					q_imem,
					q_dmem;
	wire [13:0]	ctrl;
	wire [11:0] PC,
					address_dmem,
					address_imem;
	wire [4:0]	ctrl_writeReg;
	wire			wren,
					ctrl_writeEnable,
					branch_taken;

	
	skeleton tester (clock, reset);
	
	assign reg1 = tester.my_regfile.reg_1.out;
	assign reg2 = tester.my_regfile.reg_2.out;
	assign reg3 = tester.my_regfile.reg_3.out;
	assign reg4 = tester.my_regfile.reg_4.out;
	assign reg5 = tester.my_regfile.reg_5.out;
	assign rstatus = tester.my_regfile.reg_30.out;
	assign r31 = tester.my_regfile.reg_31.out;
	
	assign data = tester.my_processor.data;
	assign data_writeReg = tester.my_processor.data_writeReg;
	assign PC = tester.address_imem;
	assign q_imem = tester.q_imem;
	assign q_dmem = tester.q_dmem;
	assign address_dmem = tester.my_processor.address_dmem;
	assign address_imem = tester.my_processor.address_imem;
	assign wren = tester.my_processor.wren;
	assign ctrl_writeEnable = tester.my_processor.ctrl_writeEnable;
	assign ctrl_writeReg = tester.my_processor.ctrl_writeReg;
	assign branch_taken = tester.my_processor.execute_branch_taken_latched;
	assign ctrl = tester.my_processor.execute_ctrls_latched;
	
	initial begin
		clock = 0;
		reset = 0;
		
		#2000 $stop;
	end
   
	always #10 clock = ~clock;

endmodule
