`timescale 1ns / 1ps


module dakika(
    input clk,
    input dakika_arttir,
    input reset,
    input stop,
    input arttir_buton,
    input azalt_buton,
    output reg saat_arttir,
    output reg saat_azalt,
    output reg [5:0] dakika
    );
    
    reg [5:0] dakika_next;
    reg kontrol, kontrol_next;
    
    initial begin
        saat_arttir = 0;
        saat_azalt = 0;
        dakika = 30;
        kontrol=1;
    end
    
    always@* begin
    
        dakika_next = dakika;
        saat_arttir = 0;
        saat_azalt = 0;
        kontrol_next=kontrol;
        
        if(stop) begin
            if(arttir_buton && !azalt_buton && kontrol) begin
            
                if(dakika>=59)begin
                    dakika_next = 0;
                    saat_arttir = 1;
                end else begin
                    dakika_next = dakika + 1;
                end
                kontrol_next =0;
            end
            else if(azalt_buton && !arttir_buton && kontrol) begin
            
                if(dakika<=0)begin
                    dakika_next = 59;
                    saat_azalt = 1;
                end else begin
                    dakika_next = dakika - 1;
                end
                kontrol_next=0;
            end 
        end
         if(dakika_arttir && kontrol) begin
        
            if(dakika>=59)begin
                dakika_next = 0;
                saat_arttir = 1;
            end else begin
                dakika_next = dakika + 1;
            end
            kontrol_next=0;            
        end 
        
        if(!arttir_buton && !azalt_buton && !dakika_arttir) begin
            kontrol_next=1;
        end
        
    end
    
    always@(posedge clk or posedge reset) begin  //senkron
    
        if(reset) begin
            dakika <= 30;
            kontrol <= 1;
        end else begin
        
            dakika <= dakika_next;
            kontrol <= kontrol_next;
        end
    end
   
    
endmodule
