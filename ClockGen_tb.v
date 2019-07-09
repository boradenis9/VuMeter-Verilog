`timescale 1ns/10ps
module ClockGen_tb;
reg clk, rst_;
wire Uclk;
initial begin

	clk=1'b0;

	forever begin
	#5 clk = ~clk;
end
end 

initial begin
	rst_=1'b0;
	#5 rst_=1'b1;
end

ClockGen #(.a(100000000),.b(153600),.Olength(10)) DUT(.clk(clk),.rst_(rst_),.Uclk(Uclk));

endmodule