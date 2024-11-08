`timescale 1ns/1ns
module assertion_tb();

    parameter LENGTH = 64, WIDTH = 16;

	reg clk = 1'b0, rst = 1'b0, input_valid = 1'b0, start = 1'b0;
	reg [WIDTH-1:0] FIR_input; 
	wire [2*WIDTH+5:0] FIR_output;
	wire output_valid;

	FIR #(LENGTH, WIDTH) UUT(.clk(clk), .rst(rst), .FIR_input(FIR_input), .input_valid(input_valid), .FIR_output(FIR_output), .output_valid(output_valid));

    logic signed [WIDTH-1:0] inputs_array [0:LENGTH];
    initial begin
        $readmemb("inputs.txt", inputs_array);
    end
    
    logic signed [2*WIDTH+5:0] outputs_array [0:LENGTH];
    initial begin
        $readmemb("outputs.txt", outputs_array);
    end

    int input_number = 0;
    always #1 begin clk = !clk; if (start) FIR_input = inputs_array[input_number]; end

    always @(posedge output_valid) begin
        if (start) begin
            input_number = input_number + 1;
            input_valid = 1;
            if (input_number == 100) $stop;
        end
    end

    initial begin
        FIR_input = 0;
        #3 rst = 1;
        #5 rst = 0;
        #37 begin input_valid = 1; start = 1;
        end
    end


    property check_multiplier;
        @(posedge clk) disable iff(input_number > 10) (input_valid == 1) |-> ((UUT.datapath.coeff * UUT.datapath.reg_input) == UUT.datapath.mult_out);
    endproperty
    muliplier_assert : assert property (check_multiplier) $display($stime,,, "\t\t mult pass"); else $display($stime,,, "\t\t mult fail");

    property check_adder;
        @(posedge clk) disable iff(input_number > 4) (1'b1==1'b1) |->((UUT.datapath.reg_mult_out + UUT.datapath.reg_add_out) == UUT.datapath.add_out);
    endproperty
    checkingAdd: assert property (check_adder) $display($stime,,,"\t\t add pass"); else $display($stime,,,"\t\t add fail");

    property check_output;
        @(posedge clk) $rose(output_valid) |-> (FIR_output == outputs_array[input_number-1]);
    endproperty 
    checkOut: assert property (check_output) $display($stime,,,"\t\t output fail "); else $display($stime,,,"\t\t output pass");

    property check_controller_signal;
        @(posedge clk) disable iff(input_number > 6) (UUT.controller.ps == 4) |-> ($past(UUT.controller.coeffs_counter_en) == 1'b1);
    endproperty
    checkingCtrlAddr: assert property (check_controller_signal) $display($stime,,,"\t\t counter count pass"); 
    else $display($stime,,,"\t\t counter count fail");

    property check_controller_sequence;
       @(posedge clk) disable iff(input_number > 40) $rose(input_valid) |=> (UUT.controller.ps == 1) ##1 (UUT.controller.ps == 2) ##1 (UUT.controller.ps == 3);
    endproperty
    checkStates: assert property (check_controller_sequence) $display($stime,,,"\t\t controller pass"); else $display($stime,,,"\tC\t controller fail");


endmodule
