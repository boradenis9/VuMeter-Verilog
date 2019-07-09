`timescale 1ns/10ps
module VgaStart_tb;
reg clk, rst_;
wire [2:0]R, G;
wire [1:0]B;
wire hs,vs;
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

VgaStart DUT(.clk(clk), .rst_(rst_), .hs(hs), .vs(vs), .R(R), .G(G) ,.B(B));

endmodule