module sll(out, in, amt);
	// Input
	input [31:0] in;
	input [4:0] amt;
	
	// Output
	output [31:0] out;
	
	// Wire
	wire [31:0] sla_8, sla_4, sla_2, sla_1;
	
	// Code
	sl1 shift_1(.out(sla_1), .in(in), .enable(amt[0]));
	sl2 shift_2(.out(sla_2), .in(sla_1), .enable(amt[1]));
	sl4 shift_4(.out(sla_4), .in(sla_2), .enable(amt[2]));
	sl8 shift_8(.out(sla_8), .in(sla_4), .enable(amt[3]));
	sl16 shift_16(.out(out), .in(sla_8), .enable(amt[4]));
		
 endmodule
