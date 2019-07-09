`timescale 1ns/10ps
module Uart_tb;
reg clk, rst_;
reg rx;
wire [7:0] data_o;
initial begin
		
	clk=1'b0;

	forever begin
	#5 clk = ~clk;
end
end 

initial begin
	rst_=1'b0;
	rx=1'b1; 
	#5 rst_=1'b1;
	#150 rx=1'b0;
	#160.25 rx = 1'b1;
	#160.75 rx = 1'b0;
	#160.52 rx = 1'b0;
	#159.25 rx = 1'b1;
	#158.75 rx = 1'b0;
	#159.75 rx = 1'b1;
	#161.25 rx = 1'b0;
	#160.25 rx = 1'b0;
	#160.55 rx = 1'b1;
	#197 rx = 1'b0;
	#160.25 rx = 1'b0;
	#160.75 rx = 1'b1;
	#160.52 rx = 1'b1;
	#159.25 rx = 1'b0;
	#158.75 rx = 1'b1;
	#159.75 rx = 1'b0;
	#161.25 rx = 1'b1;
	#160.25 rx = 1'b1;
	#160.55 rx = 1'b1;
	#300 $finish;
end

UART DUT(.clk(clk),.rst_(rst_),.rx(rx),.data_o(data_o));

endmodule