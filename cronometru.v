`timescale 1ns/1ns
module counter  ( clk, rst, start,stop, us,zs );
input clk, rst, start, stop;
output [3:0] us;
output [2:0] zs;
reg [3:0] us_ff, us_nxt;
reg [2:0] zs_ff, zs_nxt;
reg F_ff,F_nxt;
assign us =us_ff;
assign zs=zs_ff;





always @ (*) begin 
//proces combinațional, declanșat cand se schimbă un semnal din interior
us_nxt = us_ff;
zs_nxt = zs_ff;
F_nxt= F_ff;
F_nxt=start|F_ff;

if(stop)
	F_nxt=1'b0;

if(F_ff)
 begin us_nxt = us_ff + 1'b1;
		if(us_ff[3]&&us_ff[0])
		   begin us_nxt=1'b0;
				 zs_nxt = zs_ff+1'b1;
		   end
		if((zs_ff[2]&& zs_ff[0])&&us_ff[3]&&us_ff[0])
		   begin zs_nxt=1'b0;
		   end
 end


end




always @ (posedge clk or posedge rst) begin 
// proces secvențial declanșat de front crescător de clk sau rst
      if (rst) begin
      	us_ff <= 4'b0;
		zs_ff <= 3'b0;
		F_ff <= 1'b0;
      end 
      else begin
           us_ff <= us_nxt;
		   zs_ff <= zs_nxt;
		   F_ff <= F_nxt;
      end
 end
endmodule