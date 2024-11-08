module mult (in1, in2, out);

	parameter WIDTH = 16;

	input signed [WIDTH-1:0] in1, in2;
	output signed  [2*WIDTH+5:0] out;

	assign out = in1 * in2;

endmodule

