module UART  ( clk, rst_, rx, data_o);
input clk, rst_, rx;
output [7:0] data_o;
//Cabluri cu memorie 
localparam IDLE= 3'd0;
localparam DET_START= 3'd1;
localparam COLECT_DATA= 3'd2;
localparam DET_STOP= 3'd3;
localparam ERR= 3'd4;
reg[2:0] st_ff;
reg[2:0] st_nxt;
reg[7:0] data_nxt,data_ff;
reg rst_b;
wire count1;
wire rst_c;
wire[3:0] cnt_o1;
wire[3:0] cnt_o2;
reg enablec1;
reg enablec2;
reg[2:0]i;
wire maj;
assign rst_c=rst_b&&rst_;
//Instantiere counter
counter16 c1 (.clk(clk),.rst(rst_c),.enable(enablec1),.count(cnt_o1));
counter8 c2 (.clk(clk),.rst(rst_c),.enable(enablec2),.count(cnt_o2));
//asignare iesire
assign data_o= data_ff;
assign maj=((i[0]+i[1]+i[2]) >=2'd2) ? 1'b1 : 1'b0;
assign count1=(~cnt_o2[0]&&~cnt_o2[1]&&~cnt_o2[2]&&cnt_o2[3]);
//sablon rtl
always @ (*) begin 
data_nxt = data_ff;
if(cnt_o1=='d7)
i={i[2:1],rx};
else if(cnt_o1=='d8)
i={i[2],rx,i[0]};
else if(cnt_o1=='d9)
i={rx,i[1:0]};
        case(st_ff)
            IDLE:begin enablec1='d0;
			enablec2='d0;
			rst_b='d0;
		 if(rx) begin st_nxt=IDLE;
				i='d1;
 end
                else if(!rx) begin st_nxt=DET_START;
				   enablec1=1'b1;
				   rst_b = 1'b1; end end
            DET_START: if(cnt_o1=='d15 && maj=='d0) begin st_nxt=COLECT_DATA; end
                else begin st_nxt=IDLE; end
            COLECT_DATA: if(count1) begin//maj voter
				 st_nxt=DET_STOP; end
                else if(!count1) begin st_nxt=COLECT_DATA;
				       if(cnt_o1=='d15)
					begin data_nxt[cnt_o2]=maj;
					      enablec2='d1; end
					else enablec2='d0; end
	    DET_STOP:begin enablec2='d0;
		 if(cnt_o1=='d15 && maj=='d1) begin st_nxt=IDLE; end
			else begin st_nxt=ERR; end end
	    ERR:if(rx) begin st_nxt=IDLE; end
		else begin st_nxt=ERR; end
	    default: st_nxt=IDLE;
                   
endcase



end

always @ (posedge clk or negedge rst_) begin 
      if (!rst_) begin
      	data_ff <= 8'b0;
      	st_ff<=IDLE;
      end 
      else begin
           data_ff <= data_nxt;
           st_ff<=st_nxt;
      end
 end
endmodule