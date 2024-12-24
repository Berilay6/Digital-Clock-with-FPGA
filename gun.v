`timescale 1ns / 1ps


module gun(
    input clk,
    input reset,
    input stop,
    input gun_azalt,
    input gun_arttir,
    output reg ay_arttir,
    output reg ay_azalt,
    output reg [5:0]gun
    );
    
    reg [5:0] gun_next;
    reg kontrol, kontrol_next;
    
    initial begin
        ay_arttir = 0;
        ay_azalt = 0;
        gun = 1;
        kontrol=1;
    end
    
    
    always @* begin
    
        kontrol_next = kontrol;
        
        if(gun_arttir && kontrol) begin
        
            if(gun>=30)begin
                gun_next = 1;
                ay_arttir = 1;
            end else begin
                gun_next = gun + 1;
            end
            kontrol_next=0;            
        end 
        
         if(gun_azalt && kontrol) begin
        
            if(gun<=1)begin
                gun_next = 30;
                ay_azalt = 1;
            end else begin
                gun_next = gun - 1;
            end
            kontrol_next=0;            
        end 
        
        if(!gun_arttir && !gun_azalt) begin
            kontrol_next=1;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            kontrol <= 1;
            ay_arttir <= 0;
            ay_azalt <= 0;
            gun <= 1;
        end
        else begin
            kontrol <= kontrol_next;
            gun <= gun_next;
        end
    end
    
    
endmodule
