`timescale 1ns/10ps
module VUMETRU_tb;
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
	#104166.25 rx = 1'b1;
	#104167.75 rx = 1'b0;
	#104165.52 rx = 1'b0;
	#104166.25 rx = 1'b1;
	#104165.75 rx = 1'b0;
	#104167.75 rx = 1'b1;
	#104168.25 rx = 1'b0;
	#104166.25 rx = 1'b0;

	#104165.55 rx = 1'b1;
	#104167.20 rx = 1'b0;
	#104165.25 rx = 1'b0;
	#104165.75 rx = 1'b1;
	#104165.52 rx = 1'b1;
	#104165.25 rx = 1'b0;
	#104165.75 rx = 1'b1;
	#104165.75 rx = 1'b0;
	#104165.25 rx = 1'b1;
	#104165.25 rx = 1'b1;
	#104165.55 rx = 1'b1;
end

VUMETRU DUT(.clk(clk),.rst_(rst_),.rx(rx),.data_o(data_o));

endmodule