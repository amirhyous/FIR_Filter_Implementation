module FIR_controller(clk, rst, input_valid, 
	counter_coeffs,
	input_reg_ld, add_reg_ld, add_reg_rst, mult_reg_ld, mult_reg_rst, coeffs_counter_rst, 
	coeffs_counter_en, output_valid);

	parameter LENGTH = 64;

	localparam [2:0] start = 0, mult = 1, add = 2, outputgen = 3, finish = 4;

	input clk, rst, input_valid;
	input [7:0] counter_coeffs;
	output reg input_reg_ld, add_reg_ld, add_reg_rst, mult_reg_ld, mult_reg_rst, coeffs_counter_rst, 
		coeffs_counter_en ,output_valid;

	reg [2:0] ps, ns;

	always @(ps or input_valid ) begin

		ns = start;
		case(ps)
		start: if(input_valid == 1'b0)	ns = start;
			else	ns = mult;
		mult:	ns = add;
		add:	ns = outputgen;
		outputgen: if (counter_coeffs == LENGTH - 1) 	ns = finish;
			else	ns = add;	
		finish: ns = start;
		default: ns = start;
		endcase;
	end

	always @(ps or input_valid ) begin

		input_reg_ld = 1'b0;
		add_reg_ld = 1'b0;
		add_reg_rst = 1'b0;
		mult_reg_ld = 1'b0;
		mult_reg_rst = 1'b0;
		coeffs_counter_en = 1'b0;
		output_valid = 1'b0;

		case(ps)
		start: begin mult_reg_rst = 1'b1; add_reg_rst = 1'b1; coeffs_counter_rst = 1'b1; end
		mult: begin input_reg_ld = 1'b1; coeffs_counter_rst = 1'b0; end
		add: begin mult_reg_ld = 1'b1; add_reg_ld = 1'b1; end
		outputgen:  coeffs_counter_en = 1'b1; 
		finish: output_valid = 1'b1;
		default: begin 
			input_reg_ld = 1'b0;
			add_reg_ld = 1'b0;
			add_reg_rst = 1'b0;
			mult_reg_ld = 1'b0;
			mult_reg_rst = 1'b0;
			coeffs_counter_en = 1'b0;
			output_valid = 1'b0;
			end
		endcase
	end

	always @(posedge clk,posedge rst) begin
		if(rst)
		ps <= start;
		else 
		ps <= ns;
	end

endmodule


