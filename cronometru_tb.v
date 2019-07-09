`timescale 1ns/10ps
module counter_tb;
reg clk, rst;
reg start, stop;
wire [3:0] us;
wire [2:0] zs;
initial begin
	start=1'b1;
	stop=1'b0; 
	rst=1'b1;
	clk=1'b0;
	#5 rst=1'b0;
	forever begin
	#5 clk = ~clk;
end
end
initial begin
	#10 start=1'b0;
	#1000 stop= 1'b1;
end
counter DUT(.clk(clk),.rst(rst),.start(start),.stop(stop),.us(us),.zs(zs));
endmodule
