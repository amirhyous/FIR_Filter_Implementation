module input_memory (clk, rst, load, in, counter, out);

	parameter LENGTH = 64, WIDTH = 16;

	input clk, rst, load;
	input [WIDTH-1:0] in;
	input [7:0] counter;
	output [WIDTH-1:0] out;

	wire signed [WIDTH-1:0] in_mem [0:LENGTH];

	genvar i;
	generate
	for(i = 0; i < LENGTH; i = i + 1) begin : in_regs
		areg areg1(.clk(clk), .rst(rst), .load(load), .in(in_mem[i]), .out(in_mem[i+1]));
	end
	endgenerate

	assign in_mem[0] = in;
	assign out = in_mem[counter+1]; 

endmodule
