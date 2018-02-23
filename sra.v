module sra(out, in, amt);
	// Input
	input [31:0] in;
	input [4:0] amt;
	
	// Output
	output [31:0] out;
	
	// Wire
	wire [31:0] sra_8, sra_4, sra_2, sra_1;
	
	// Code
	sr1 shift_1(.out(sra_1), .in(in), .enable(amt[0]));
	sr2 shift_2(.out(sra_2), .in(sra_1), .enable(amt[1]));
	sr4 shift_4(.out(sra_4), .in(sra_2), .enable(amt[2]));
	sr8 shift_8(.out(sra_8), .in(sra_4), .enable(amt[3]));
	sr16 shift_16(.out(out), .in(sra_8), .enable(amt[4]));
		
 endmodule
