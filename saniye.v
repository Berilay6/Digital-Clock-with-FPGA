`timescale 1ns / 1ps


module saniye(
    input clk,
    input reset,
    input [5:0] ledSwitch,
    input stop,
    input speed,
    output reg dakika_arttir,
    output reg [5:0] saniye
    );
    
    reg [5:0] saniye_next;
    reg ledSwitch_before;
    reg [31:0] sayac;
    reg saniye_clk;
    
    initial begin
        dakika_arttir = 0;
        sayac = 0;
        saniye_clk = 0;
        saniye = 0;
    end
    
    always@ (posedge clk) begin
        
        if(!speed) begin
            if(sayac >= 10**8/2) begin    //saniye uygun yap
                sayac = 1;
                saniye_clk = ~saniye_clk;
            end else begin
                sayac = sayac + 1;
            end
        end else begin
            if(sayac >= 10**8/120) begin    //saniye uygun yap
                sayac = 1;
                saniye_clk = ~saniye_clk;
            end else begin
                sayac = sayac + 1;
            end
        end
    end
    
    always@* begin
        
        saniye_next = saniye;
        dakika_arttir = 0;
        
        if(stop) begin
            if( ledSwitch!=0 ) begin
                saniye_next = ledSwitch;
            end
        end else begin
            if(saniye >= 59) begin
                saniye_next = 0;
                dakika_arttir = 1;
            end
            else begin
                saniye_next = saniye + 1;
            end
        end
    end
    
    always@ (posedge saniye_clk or posedge reset) begin
    
        if(reset) begin
            saniye <= 0;
        end else begin
            saniye <= saniye_next;
        end
    end
    
endmodule
