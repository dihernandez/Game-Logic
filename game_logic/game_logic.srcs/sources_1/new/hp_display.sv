`timescale 1ns / 1ps

module hp_display(
 // calculate hp digits
 input reset,
 input clk_65mhz,
 input [6:0] hp,
 
 output [3:0] ones_digit,
 output [3:0] tens_digit,
 output [3:0] hundred_digit
 );
    
    logic [6:0] hp_old;    
    logic [3:0] player_ones_digit, player_tens_digit, player_hundred_digit;
    assign ones_digit = player_ones_digit;
    assign tens_digit = player_tens_digit;
    assign hundred_digit = player_hundred_digit;
    
    logic cycle_started;
    
    always @(posedge clk_65mhz) begin
        if(reset) begin
            player_hundred_digit <= 1;
            player_tens_digit <= 0;
            player_ones_digit <= 0;
        end else begin
        
        hp_old <= hp;
            if(hp == 100) begin
                    player_ones_digit <= 0;
                    player_tens_digit <= 0;
                    player_hundred_digit <= 1;
            end
            else if (hp_old == hp + 5) begin
                player_hundred_digit <= 0;
                player_ones_digit <= (player_ones_digit == 0) ? 5 : 0;
                if(player_tens_digit == 0 && (player_ones_digit == 0)) begin
                    player_tens_digit <= 9;
                end else begin
                    player_tens_digit <= (player_ones_digit == 5) ? player_tens_digit : player_tens_digit - 1; 
                end
            end else if (hp_old == hp + 10) begin
                player_hundred_digit <= 0;
                // ones stays same
                if(player_tens_digit == 0) begin
                   player_tens_digit <= 9; 
                end else begin
                   player_tens_digit <= player_tens_digit - 1;
                end
            end else if(hp > hp_old) begin // wrap around, hp reaches zero
                player_hundred_digit <= 0;
                player_tens_digit <= 0;
                player_ones_digit <= 0;
            end
        end
        end
endmodule


// decimal counter
module hp_countdown (
     input clk,
     input reset,
     input [6:0] hp,
     
     output [3:0] ones_digit,
     output [3:0] tens_digit,
     output [3:0] hundred_digit
);

    logic[3:0] tens_counter = 0;
    logic[6:0] interval;
    logic[6:0] hp_old;

    logic [3:0] player_ones_digit, player_tens_digit, player_hundred_digit;
    assign ones_digit = player_ones_digit;
    assign tens_digit = player_tens_digit;
    assign hundred_digit = player_hundred_digit;
    
    
    always @(posedge clk) begin
        if(reset) begin
            player_ones_digit <= 0;
            player_tens_digit <= 0;
            player_hundred_digit <= 1;
        end
        hp_old <= hp;
        interval <= hp - hp_old; // never increments, just decrements
        player_ones_digit <= hp % 10; 
        player_tens_digit <= 10 - tens_counter;
        if (hp < 100) begin
            player_hundred_digit = 0;
        end
        
        if(interval > player_ones_digit && tens_counter < 10) begin // if interval is greater than ones digit, we decrement tens by 1; note cannot decrement by > 10 and still be accurate
            tens_counter <= tens_counter + 1;
        end else if (tens_counter == 10) begin
            tens_counter <= 0;
            player_tens_digit <= 0;
        end
    end


endmodule
