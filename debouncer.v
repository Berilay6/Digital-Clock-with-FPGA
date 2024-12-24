`timescale 1ns / 1ps



module debouncer (
    input clk,           
    input btn_in,         
    output reg btn_out    
);

    reg [15:0] counter;   
    reg btn_sync_0, btn_sync_1; 

   
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end

   
    always @(posedge clk) begin
        if (btn_sync_1 == btn_out) begin
            counter <= 0; 
        end else begin
            counter <= counter + 1; 
            if (counter == 16'hFFFF) begin
                btn_out <= ~btn_out; 
            end
        end
    end

endmodule

