module FIR_datapath (clk, rst, input_reg_ld, add_reg_ld, add_reg_rst, mult_reg_ld, mult_reg_rst, coeffs_counter_rst,
	coeffs_counter_en, FIR_input,
	counter_coeffs, FIR_output);

	parameter LENGTH = 64;
	parameter WIDTH = 16;

	input clk, rst, input_reg_ld, add_reg_ld, add_reg_rst, mult_reg_ld, mult_reg_rst, coeffs_counter_rst, coeffs_counter_en;
	input signed  [WIDTH-1:0] FIR_input;
	output signed [7:0] counter_coeffs;
	output signed  [2*WIDTH+5:0] FIR_output;

	wire signed  [WIDTH-1:0] coeff, reg_input;
	wire signed  [2*WIDTH+5:0] mult_out, add_out, reg_add_out, reg_mult_out;

	reg signed [WIDTH-1:0] coeffs_mem [0:LENGTH-1];
	initial
	begin
		$readmemb("coeffs.txt",coeffs_mem);
	end
	assign coeff =  coeffs_mem[counter_coeffs]; 
 	
	add #(WIDTH) add1(.in1(reg_add_out), .in2(reg_mult_out), .out(add_out));
	mult #(WIDTH) mult1(.in1(coeff), .in2(reg_input), .out(mult_out));
	areg38 #(WIDTH) add_reg(.clk(clk), .rst(add_reg_rst), .load(add_reg_ld), .in(add_out), .out(reg_add_out)); 
	areg38 #(WIDTH) mult_reg(.clk(clk), .rst(rst), .load(mult_reg_ld), .in(mult_out), .out(reg_mult_out)); 
	input_memory #(LENGTH, WIDTH) input_reg(.clk(clk), .rst(rst), .load(input_reg_ld), .in(FIR_input),
		.counter(counter_coeffs), .out(reg_input)); 
	counter coeffs_counter(.clk(clk), .rst(coeffs_counter_rst), .en(coeffs_counter_en), .out(counter_coeffs));
	assign FIR_output = reg_add_out>>>1;
	
endmodule
