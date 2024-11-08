module FIR (clk, rst, FIR_input, input_valid, FIR_output, output_valid);

	parameter LENGTH = 64;
	parameter WIDTH = 16;

	input clk, rst, input_valid;
	output output_valid;
	input signed  [WIDTH-1:0] FIR_input;
	output signed  [2*WIDTH+5:0] FIR_output;

	wire input_reg_ld, add_reg_ld, coeffs_counter_en, add_reg_rst, mult_reg_ld, mult_reg_rst, coeffs_counter_rst;
	wire [7:0] counter_coeffs;

	FIR_datapath #(LENGTH, WIDTH) datapath(.clk(clk), .rst(rst), .input_reg_ld(input_reg_ld), .add_reg_ld(add_reg_ld), 
		.add_reg_rst(add_reg_rst), .mult_reg_ld(mult_reg_ld),
		.mult_reg_rst(mult_reg_rst), .coeffs_counter_rst(coeffs_counter_rst), 
		.coeffs_counter_en(coeffs_counter_en), .FIR_input(FIR_input),
		.counter_coeffs(counter_coeffs), .FIR_output(FIR_output));

	FIR_controller #(LENGTH) controller(.clk(clk), .rst(rst), .input_valid(input_valid), .counter_coeffs(counter_coeffs),
		.input_reg_ld(input_reg_ld), .add_reg_ld(add_reg_ld), .add_reg_rst(add_reg_rst), .mult_reg_ld(mult_reg_ld),
		.mult_reg_rst(mult_reg_rst), .coeffs_counter_rst(coeffs_counter_rst), .coeffs_counter_en(coeffs_counter_en),
		.output_valid(output_valid));

endmodule


