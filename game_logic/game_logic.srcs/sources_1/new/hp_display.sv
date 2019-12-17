`timescale 1ns / 1ps

module hp_display(
 // calculate hp digitsinput clk_65mhz,
 input
    
 );
 
     logic [6:0] player_1_hp, player_2_hp;
    
    logic [3:0] p1_ones_digit, p1_tens_digit, p1_hundred_digit;
    logic [3:0] p2_ones_digit, p2_tens_digit, p2_hundred_digit;
    assign p1_ones_digit = player_1_hp; 
    assign p2_ones_digit = 9;
    logic [6:0] p1_hp_old, p2_hp_old;
    
    
    always @(posedge clk_65mhz) begin
        p1_hp_old <= player_1_hp;
        if(player_1_hp == 100) begin
                p1_ones_digit <= 0;
                p1_tens_digit <= 0;
                p1_hundred_digit <= 1;
        end else if (p1_hp_old == player_1_hp - 5) begin
            p1_hundred_digit <= 0;
                p1_ones_digit <= (p1_ones_digit == 0) ? 5 : 0;
            if(p1_tens_digit == 0 && (p1_ones_digit == 5)) begin
                p1_tens_digit <= 9;
            end else begin
                p1_tens_digit <= (p1_ones_digit == 5) ? p1_tens_digit : p1_tens_digit - 1; 
            end
        end else if (p1_hp_old == player_1_hp - 10) begin
            p1_hundred_digit <= 0;
            // ones stays same
            if(p1_tens_digit == 0) begin
               p1_tens_digit <= 9; 
            end else begin
                p1_tens_digit <= p1_tens_digit - 1;
            end
        end else if(player_1_hp > p1_hp_old) begin
            p1_hundred_digit <= 0;
            p1_tens_digit <= 0;
            p1_ones_digit <= 0;
        end
    end
endmodule
