module VUMETRU(clk,rst_,rx,data_o);
input clk, rst_, rx;
output [7:0] data_o;
wire Uclk;

UART a(.clk(Uclk),.rst_(rst_),.rx(rx),.data_o(data_o));
ClockGen #(.a(50000000),.b(153600),.Olength(10)) DUT(.clk(clk),.rst_(rst_),.Uclk(Uclk));


endmodule
