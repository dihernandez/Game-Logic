`timescale 1ns / 1ps

module hp_countdown (
     input clk,
     input reset,
     input [6:0] hp,
     
     output [3:0] ones_digit,
     output [3:0] tens_digit,
     output [3:0] hundred_digit
);

    logic[3:0] tens_counter = 1;
    logic[6:0] interval;
    logic[6:0] hp_old;

    logic [3:0] player_ones_digit, player_tens_digit, player_hundred_digit;
    assign ones_digit = player_ones_digit;
    assign tens_digit = player_tens_digit;
    assign hundred_digit = player_hundred_digit;
    
    
    always @(posedge clk) begin
         hp_old <= hp;
         interval <= hp_old - hp; // never increments, just decrements, UNTESTED AS OF 1/17  2PM note (1/22) what if it goes negative?
    
        if(reset) begin
            player_ones_digit <= 0;
            player_tens_digit <= 0;
            player_hundred_digit <= 1;
        end else if(hp == 100) begin
            player_ones_digit <= 0;
            player_tens_digit <= 0;
            player_hundred_digit <= 1;
        end else if(hp == 0) begin // if we've reached 0 countdown this round
                player_ones_digit <= 0;
                player_tens_digit <= 0;
                player_hundred_digit <= 0;
        end else begin
            if (hp < 100) begin
                player_hundred_digit <= 0;
            end
            
            if (interval == 5) begin
                player_ones_digit <= player_ones_digit == 0 ? 5 : 0;
                if(player_tens_digit == 0) begin
                    player_tens_digit <= 9;
                end else begin
                    player_tens_digit <= player_ones_digit == 5 ? player_tens_digit : player_tens_digit - 1; 
                end
            end else if (interval == 10) begin
                player_tens_digit <= player_tens_digit == 0 ? 9 : player_tens_digit - 1;
                // player ones digit stays same
            end else begin
                //unsuported interval, do nothing
            end        
                
         end
        //end
    end
endmodule
