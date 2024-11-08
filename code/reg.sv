module areg (clk, rst, load, in, out);

	parameter WIDTH = 16; 

	input clk, rst, load;
	input [WIDTH-1:0] in;
	output logic [WIDTH-1:0] out;

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
