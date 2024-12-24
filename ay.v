`timescale 1ns / 1ps


module ay( 
    input clk,
    input reset,
    input stop,
    input ay_azalt,
    input ay_arttir,
    output reg yil_arttir,
    output reg yil_azalt,
    output reg [5:0] ay
    );
    
    reg [5:0] ay_next;
    reg kontrol, kontrol_next;
    
    initial begin
        yil_arttir = 0;
        yil_azalt = 0;
        ay = 1;
        kontrol=1;
    end
    
    
    always @* begin
    
        kontrol_next = kontrol;
        
        if(ay_arttir && kontrol) begin
        
            if(ay>=12)begin
                ay_next = 1;
                yil_arttir = 1;
            end else begin
                ay_next = ay + 1;
            end
            kontrol_next=0;            
        end 
        
         if(ay_azalt && kontrol) begin
        
            if(ay<=1)begin
                ay_next = 12;
                yil_azalt = 1;
            end else begin
                ay_next = ay - 1;
            end
            kontrol_next=0;            
        end 
        
        if(!ay_arttir && !ay_azalt) begin
            kontrol_next=1;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            kontrol <= 1;
            yil_arttir <= 0;
            yil_azalt <= 0;
            ay <= 1;
        end
        else begin
            kontrol <= kontrol_next;
            ay <= ay_next;
        end
    end
endmodule
