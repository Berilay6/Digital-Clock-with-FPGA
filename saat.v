`timescale 1ns / 1ps


module saat(
    input clk,
    input saat_arttir,
    input saat_azalt,
    input reset,
    input stop,
    input arttir_buton,
    input azalt_buton,
    output reg gun_arttir,
    output reg gun_azalt,
    output reg [5:0] saat
    );
    
    reg [5:0]saat_next;
    reg kontrol, kontrol_next;
    
    initial begin
        gun_arttir = 0;
        gun_azalt = 0;
        saat = 18;
        kontrol=1;
    end
    
    always@* begin
        
        saat_next = saat;
        gun_arttir = 0;
        gun_azalt = 0;
        kontrol_next = kontrol;
        
        if(stop) begin
            if(arttir_buton && !azalt_buton && kontrol) begin
            
                if(saat>=23)begin
                    saat_next = 0;
                    gun_arttir = 1;
                end else begin
                    saat_next = saat + 1;
                end
                kontrol_next=0;
            end
            if(((azalt_buton && !arttir_buton) || saat_azalt) && kontrol) begin
            
                if(saat<=0)begin
                    saat_next = 23;
                    gun_azalt = 1;
                end else begin
                    saat_next = saat - 1;
                end
                kontrol_next=0;
            end
        end
         if(saat_arttir && kontrol) begin
        
            if(saat>=23)begin
                saat_next = 0;
                gun_arttir = 1;
            end else begin
                saat_next = saat + 1;
            end
            kontrol_next=0;
        end
        
        if(!arttir_buton && !azalt_buton && !saat_arttir && !saat_azalt) begin
            kontrol_next=1;
        end
    end
    
    always@(posedge clk or posedge reset) begin    //senkron
        if(reset) begin
        
            saat <= 18;
            kontrol <= 1;
        end else begin
        
            saat <= saat_next;
            kontrol <= kontrol_next;
        end
    end
    

    
endmodule
