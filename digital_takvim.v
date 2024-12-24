`timescale 1ns / 1ps


module digital_takvim(
    input clk,
    input reset,
    input [5:0] LedSwitch,
    input speed,
    input Stop_buton,
    input Dakika_arttir_buton,
    input Dakika_azalt_buton,
    input Saat_arttir_buton,
    input Saat_azalt_buton,
    output reg [6:0] segment,
    output [3:0] sayac,
    output [5:0] saniye
    );
    
    wire [5:0] dakika, saat, gun, ay; 
    wire [15:0]yil;
    
    reg stop, stop_next, kontrol, kontrol_next;
    
    wire Dar, Sar, Saz, Gar, Gaz, Aar, Aaz, Yar, Yaz;
    reg [3:0] bcd_dakika [1:0];
    reg [3:0] bcd_saat [1:0];
    
    wire Saat_azalt_buton_c, Saat_arttir_buton_c, Dakika_azalt_buton_c, Dakika_arttir_buton_c, Stop_buton_c;
    
    saniye u_saniye(
        .clk(clk),
        .reset(reset),
        .ledSwitch(LedSwitch),
        .stop(stop),
        .speed(speed),
        .dakika_arttir(Dar),
        .saniye(saniye)
        );
        
    dakika u_dakika(
        .clk(clk),
        .dakika_arttir(Dar),
        .reset(reset),
        .stop(stop),
        .arttir_buton(Dakika_arttir_buton_c),
        .azalt_buton(Dakika_azalt_buton_c),
        .saat_arttir(Sar),
        .saat_azalt(Saz),
        .dakika(dakika)
        );
        
    saat u_saat(
        .clk(clk),
        .saat_arttir(Sar),
        .saat_azalt(Saz),
        .reset(reset),
        .stop(stop),
        .arttir_buton(Saat_arttir_buton_c),
        .azalt_buton(Saat_azalt_buton_c),
        .gun_arttir(Gar),
        .gun_azalt(Gaz),
        .saat(saat)
        );
        
    gun u_gun(
        .clk(clk),
        .reset(reset),
        .stop(stop),
        .gun_azalt(Gaz),
        .gun_arttir(Gar),
        .ay_arttir(Aar),
        .ay_azalt(Aaz),
        .gun(gun)
        );
        
    ay u_ay(
        .clk(clk),
        .reset(reset),
        .stop(stop),
        .ay_azalt(Aaz),
        .ay_arttir(Aar),
        .yil_arttir(Yar),
        .yil_azalt(Yaz),
        .ay(ay)
        );
        
    yil u_yil(
        .clk(clk),
        .reset(reset),
        .stop(stop),
        .yil_azalt(Yaz),
        .yil_arttir(Yar),
        .yil(yil)
        );
        
    wire [6:0] segD0, segD1, segS0, segS1;
    reg [3:0] sayac_next;
    reg [31:0] milisayac, milisayac_next;
    reg [3:0] sayac_r;
    assign sayac = ~sayac_r;
    
    seven_segment_display D0(
        .num( bcd_dakika[0] ),
        .segments(segD0)
    );
    seven_segment_display D1(
        .num( bcd_dakika[1] ),
        .segments(segD1)
    );
    seven_segment_display S0(
        .num( bcd_saat[0] ),
        .segments(segS0)
    );
    seven_segment_display S1(
        .num( bcd_saat[1] ),
        .segments(segS1)
    );
    
    debouncer d1(
        .clk(clk),           
        .btn_in(Stop_buton),         
        . btn_out(Stop_buton_c)
    );
    
    debouncer d2(
        .clk(clk),           
        .btn_in(Dakika_arttir_buton),         
        . btn_out(Dakika_arttir_buton_c)
    );
    
    debouncer d3(
        .clk(clk),           
        .btn_in(Dakika_azalt_buton),         
        . btn_out(Dakika_azalt_buton_c)
    );
    
    debouncer d4(
        .clk(clk),           
        .btn_in(Saat_arttir_buton),         
        . btn_out(Saat_arttir_buton_c)
    );
    
    debouncer d5(
        .clk(clk),           
        .btn_in(Saat_azalt_buton),         
        . btn_out(Saat_azalt_buton_c)
    );
    
    initial begin
        stop = 0;
        kontrol = 1;
        milisayac = 1;
        sayac_r = 1;
    end
    
    always@* begin
    
        milisayac_next = milisayac;
        stop_next = stop;
        kontrol_next = kontrol;
        sayac_next = sayac_r;
        
        if(Stop_buton_c && kontrol) begin
            stop_next = ~stop;
            kontrol_next = 0;
        end
        else if(!Stop_buton_c) begin
            kontrol_next = 1;
        end
        
        bcd_dakika[0] = dakika%10;
        bcd_dakika[1] = (dakika - (dakika%10))/10;
        
        bcd_saat[0] = saat%10;
        bcd_saat[1] = (saat - (saat%10))/10;
        
        case(sayac_r)
            1:segment = segD0;
            2:segment = segD1;
            4:segment = segS0;
            8:segment = segS1;
        endcase
        
        if(milisayac >= 10**5)begin
            milisayac_next = 1;
        end else begin
            milisayac_next = milisayac + 1;
        end
        
        if(sayac_r==8 && milisayac == 1)begin
            sayac_next = 1;
        end else if(milisayac == 1) begin
            sayac_next = sayac_r*2;
        end
    end
    
    always@(posedge clk) begin
        
        milisayac <= milisayac_next;
        stop <= stop_next;
        kontrol <= kontrol_next;
        sayac_r <= sayac_next;
    end
    
endmodule
