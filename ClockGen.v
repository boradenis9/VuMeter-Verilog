module ClockGen( clk, rst_, Uclk );
input clk, rst_;
output Uclk;
parameter a=0;
parameter b=0;
parameter c=a/b;
parameter Olength=0;
reg Uclk_ff;
reg Uclk_nxt;
wire[Olength-1:0] cnt_o;
paramCounter #(.Olength(Olength),.modO(c)) c1(.clk(clk),.rst(rst_),.enable(1),.count(cnt_o));
assign Uclk=Uclk_ff;
always @ (*) begin
Uclk_nxt=Uclk_ff;
if(cnt_o==c-1)
	Uclk_nxt='b1;
else Uclk_nxt='b0;

end

always @ (posedge clk or negedge rst_) begin 
      if (!rst_) begin
      	Uclk_ff <= 'b0;
      end 
      else begin
           Uclk_ff <= Uclk_nxt;
      end
 end
endmodule
