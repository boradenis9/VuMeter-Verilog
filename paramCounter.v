module paramCounter ( clk, rst, enable, count );
parameter Olength=0;
parameter modO=0;
parameter iv={Olength{1'b0}};
input clk, rst, enable;
output [Olength:0] count;
reg [Olength:0] count_ff, count_nxt;
assign count = count_ff;

always @ (*) begin 
//proces combina?ional, declan?at cand se schimb? un semnal din interior
count_nxt = count_ff;
if( enable ) count_nxt = count_ff + 1'b1;
if(count_ff== modO-1) count_nxt='d0;
end

always @ (posedge clk or negedge rst) begin 
// proces secven?ial declan?at de front cresc?tor de clk sau rst
      if (!rst) begin
      	count_ff <= iv;
      end 
      else begin
           count_ff <= count_nxt;
      end
 end
endmodule