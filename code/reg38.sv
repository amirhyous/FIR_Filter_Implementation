module areg38 (clk, rst, load, in, out);

	/*parameter WIDTH = 16; 

	input clk, rst, load;
	input [2*WIDTH+5:0] in;
	output [2*WIDTH+5:0] out;
	reg [2*WIDTH+5:0] out_reg;

	always @(posedge clk or posedge rst or posedge load) begin
	if (rst)
	out_reg = 38'd0;
	else if (clk == 1 && load ==1)
	out_reg = in;
	end
	assign out = out_reg;*/

	parameter WIDTH = 16; 

	input clk, rst, load;
	input [2*WIDTH+5:0] in;
	output logic [2*WIDTH+5:0] out;

    initial begin
        out = 0;
    end

   always@(posedge clk, posedge rst) begin
        if(rst)
            out <= 0;
        else if(load)
            out <= in;
    end
endmodule
