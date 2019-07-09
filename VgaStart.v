module VgaStart #(parameter H_Rez=640, parameter V_Rez=480) ( clk, rst_, hs, vs, R, G, B);
input clk, rst_;
output [2:0]R, G;
output [1:0]B;
output hs, vs;

//Definire stari automat
localparam SHFP = 3'd0;
localparam SHSYNC = 3'd1;
localparam SHBP = 3'd2;
localparam SHDISP = 3'd3;
localparam SVFP = 3'd4;
localparam SVSYNC = 3'd5;
localparam SVBP = 3'd6;
localparam SVDISP = 3'd7;

//Definire parametri VGA
localparam HFP = 16; 
localparam HSYNC = 96;
localparam HBP = 48; 
localparam HFULL = 800;
localparam VFP = 10;
localparam VSYNC = 2;
localparam VBP = 33;
localparam VFULL = 525;

//Cabluri cu memorie
reg [2:0]st0_ff, st0_nxt, st1_ff, st1_nxt;
reg hs_ff, hs_nxt, vs_ff, vs_nxt;
reg [2:0]R_ff,G_ff,R_nxt,G_nxt;
reg [1:0]B_ff,B_nxt;


//Asignari iesiri;
assign hs=hs_ff;
assign vs=vs_ff;
assign R=R_ff;
assign G=G_ff;
assign B=B_ff;

//Declaratii semnale ajutatoare
reg [9:0]h_count_ff, v_count_ff, h_count_nxt, v_count_nxt;
reg active_ff, active_nxt;
reg [9:0]x_ff, x_nxt;
reg [8:0]y_ff, y_nxt;

//sablon rtl
always @ (*) 
begin

R_nxt = R_ff;
B_nxt = B_ff;
G_nxt = G_ff;
x_nxt = x_ff;
y_nxt = y_ff;
active_nxt = active_ff;
hs_nxt = hs_ff;
vs_nxt = vs_ff;
h_count_nxt = h_count_ff;
v_count_nxt = v_count_ff;
    case(st0_ff)
        SHFP:   begin
                    h_count_nxt = h_count_ff + 1;  
                
                    if(h_count_ff == HFP-1)
                        begin   
                            st0_nxt = SHSYNC;
                            hs_nxt = 1;
                        end
                    else 
                        st0_nxt = SHFP;

                end
        SHSYNC: begin   
                    h_count_nxt = h_count_ff +1;

                    if ( h_count_ff == HFP+HSYNC-1 )
                        begin
                            st0_nxt = SHBP;
                            hs_nxt = 0;
                        end
                    else
                        st0_nxt = SHSYNC;
                end
        SHBP:   begin
                    h_count_nxt = h_count_ff +1;
                    
                    if( h_count_ff == HFP+HSYNC+HBP-1 )
                        begin
                            st0_nxt = SHDISP;
                            active_nxt = 1;
                            G_nxt = 'b011;
                        end
                    else
                        st0_nxt = SHBP;        
                end
        SHDISP: begin
                    h_count_nxt = h_count_ff+1;
                    x_nxt = x_ff + 1;

                    if( h_count_ff == 799 )
                        begin
                            st0_nxt = SHFP;
                            active_nxt = 0;
                            if(y_ff == 479)
                              y_nxt = y_ff;
                            else 
                              y_nxt=y_ff+1;
                            if(v_count_ff == 524)
                              begin
                              v_count_nxt = 0;
                              y_nxt=0;
                              end
                            else
                              begin
                              v_count_nxt = v_count_ff + 1;
                              end

                            
                            x_nxt = 0;
                            h_count_nxt = 0;
                        end
                    else
                        st0_nxt = SHDISP;

                    
                end
    endcase

    case(st1_ff)
        SVDISP: begin
                if(y_ff == 479)
                  y_nxt = y_ff;
                if( v_count_ff == 480 )
                    begin
                        st1_nxt = SVFP;
                        active_nxt = 0;
                    end
                else
                    st1_nxt = SVDISP;
                end
        SVFP:   begin
                    active_nxt = 0;
                     
                    if( v_count_ff == 480+VFP)
                        begin    
                            st1_nxt=SVSYNC;
                            vs_nxt = 1;
                        end
                    else
                        st1_nxt = SVFP;
                end
        SVSYNC: begin
                    active_nxt = 0;
                    
                    if( v_count_ff == 480+VFP+VSYNC )
                        begin
                            st1_nxt = SVBP;
                            vs_nxt = 0;
                        end
                    else
                        st1_nxt = SVSYNC;
                end
        SVBP:   begin
                    active_nxt = 0;

                    if( v_count_ff == 0)
                        begin
                            st1_nxt = SVDISP;
                            y_nxt = 0;
                            v_count_nxt = 0;
                        end
                    else 
                        st1_nxt = SVBP;
                end
    endcase
    
   if(active_ff)
     R_nxt =0;
   else 
   begin
    R_nxt =0 ;
    G_nxt =0 ;
    B_nxt =0 ; 
  end
  
    
    if(y_ff >=0 && y_ff <80 && active_ff)
     begin 
       R_nxt = 'b111;
       G_nxt = 0;
       B_nxt = 0;
     end
    if(y_ff >=80 && y_ff <160 && active_ff)
     begin 
       R_nxt = 'b111;
       G_nxt = 'b011;
       B_nxt = 0;
     end 
    if(y_ff >=160 && y_ff <240 && active_ff)
     begin 
       R_nxt = 'b111;
       G_nxt = 'b111;
       B_nxt = 0;
     end 
    if(y_ff >=240 && y_ff <320 && active_ff)
     begin 
       R_nxt = 0;
       G_nxt = 'b011;
       B_nxt = 0;
     end  
    if(y_ff >=320 && y_ff <400 && active_ff)
     begin 
       G_nxt = 0;
       R_nxt = 0;
       B_nxt = 'b11;
     end 
    if(y_ff >=400 && y_ff <480 && active_ff)
     begin 
       R_nxt = 'b011;
       B_nxt = 'b01;
       G_nxt =0;
    end 

end

always @ (posedge clk or negedge rst_)
    begin 
        if(!rst_)
            begin 
                R_ff <= 0;
                G_ff <= 0;
                B_ff <= 0;
                
                hs_ff <= 0;
                vs_ff <= 0;
                h_count_ff <= 0;
                v_count_ff <= 0;
                active_ff <= 0;
                x_ff <= 0;
                y_ff <= 0;
                st0_ff <= SHFP;
                st1_ff <= SVDISP;
            end
        else 
            begin 
                R_ff <= R_nxt;
                G_ff <= G_nxt;
                B_ff <= B_nxt;
                x_ff <= x_nxt;
                y_ff <= y_nxt;
                active_ff <= active_nxt;
                h_count_ff <= h_count_nxt;
                v_count_ff <= v_count_nxt;
                hs_ff <= hs_nxt;
                vs_ff <= vs_nxt;
                st0_ff <= st0_nxt;
                st1_ff <= st1_nxt;
            end
    end
endmodule 