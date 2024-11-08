`timescale 1ns/1ns
module TB();

	reg clk = 1'b0, rst = 1'b0, input_valid = 1'b0;
	reg [15:0] FIR_input; 
	wire [37:0] FIR_output;
	wire output_valid;

	FIR UUT(clk, rst, FIR_input, input_valid, FIR_output, output_valid);
	always #5 clk = ~clk;
	initial begin

	#13 rst = 1'b1;
	#11 rst = 1'b0;
	#13 FIR_input = 16'b0000000100100101;

	#11 input_valid = 1'b1;
	#11 input_valid = 1'b0;
	
	#2000 FIR_input = 16'b0000111000010001;

	#11 input_valid = 1'b1;
	#11 input_valid = 1'b0;
	
	#2000 FIR_input = 16'b0000100010011101;

	#11 input_valid = 1'b1;
	#11 input_valid = 1'b0;

	#2000 FIR_input = 16'b1111100101100000;

	#11 input_valid = 1'b1;
	#11 input_valid = 1'b0;

	#2000 FIR_input = 16'b1111011000111010;

	#11 input_valid = 1'b1;
	#11 input_valid = 1'b0;

	#2000 $stop;
	end

endmodule
	
