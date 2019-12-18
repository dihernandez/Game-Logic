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
        hp_old <= hp;
        if(cycle_started == 0) begin
            cycle_started <= 1; //don't enter loop unless we have at least one hp_old value; this is a hack for testing, will need to include start condition in here when in action
        end
        if(cycle_started) begin
            if(hp == 100) begin
                    player_ones_digit <= 0;
                    player_tens_digit <= 0;
                    player_hundred_digit <= 1;
            end else if (hp_old == hp - 5) begin
                player_hundred_digit <= 0;
                    player_ones_digit <= (player_ones_digit == 0) ? 5 : 0;
                if(player_tens_digit == 0 && (player_ones_digit == 5)) begin
                    player_tens_digit <= 9;
                end else begin
                    player_tens_digit <= (player_ones_digit == 5) ? player_tens_digit : player_tens_digit - 1; 
                end
            end else if (hp_old == hp - 10) begin
                player_hundred_digit <= 0;
                // ones stays same
                if(player_tens_digit == 0) begin
                   player_tens_digit <= 9; 
                end else begin
                    player_tens_digit <= player_tens_digit - 1;
                end
            end else if(hp > hp_old) begin
                player_hundred_digit <= 0;
                player_tens_digit <= 0;
                player_ones_digit <= 0;
            end
        end
    end
endmodule
