`timescale 1ns / 1ps


module yil(
    input clk,
    input reset,
    input stop,
    input yil_azalt,
    input yil_arttir,
    output reg [15:0] yil
    );
    reg [15:0] yil_next;
    reg kontrol, kontrol_next;
    
    initial begin
        yil = 2024;
        kontrol=1;
    end
    
    
    always @* begin
    
        kontrol_next = kontrol;
        
        if(yil_arttir && kontrol) begin
       
                yil_next = yil + 1;
                kontrol_next=0;            
        end 
        
         if(yil_azalt && kontrol) begin
        
                yil_next = yil - 1;
                kontrol_next=0;            
        end 
        
        if(!yil_arttir && !yil_azalt) begin
            kontrol_next=1;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            kontrol <= 1;
            yil <= 1;
        end
        else begin
            kontrol <= kontrol_next;
            yil <= yil_next;
        end
    end
endmodule
