`timescale 1ns / 1ps

// decimal counter
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
        if(reset) begin
            tens_counter <= 1;
            player_ones_digit <= 0;
            player_tens_digit <= 0;
            player_hundred_digit <= 1;
        end else if(hp == 100) begin
            player_ones_digit <= 0;
            player_tens_digit <= 0;
            player_hundred_digit <= 1;
        end else begin
            hp_old <= hp;
            interval <= hp_old - hp; // never increments, just decrements, UNTESTED AS OF 1/17  2PM note (1/22) what if it goes negative?
            player_ones_digit <= hp % 10; 
            player_tens_digit <= 10 - tens_counter;
       

            if(hp <= interval) begin // if we've reached 0 countdown this round
                player_ones_digit <= 0;
                player_tens_digit <= 0;
                player_hundred_digit <= 0;
            end else begin
                if (hp < 100) begin
                    player_hundred_digit <= 0;
                end
                
                if(interval > player_ones_digit && tens_counter < 10) begin // if interval is greater than ones digit, we decrement tens by 1; note cannot decrement by > 10 and still be accurate
                    tens_counter <= tens_counter + 1;
                end else if (tens_counter == 10) begin
                    tens_counter <= 1;
                    player_tens_digit <= 0;
                end                
                
            end
        end
    end
endmodule
