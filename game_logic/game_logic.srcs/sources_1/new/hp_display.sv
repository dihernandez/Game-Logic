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
     input[6:0] countdown_interval,
     input clk,
     input reset,
     
     output [6:0] hp,
     output [3:0] ones_digit,
     output [3:0] tens_digit,
     output [3:0] hundred_digit
);

    logic[6:0] counter = hp;
    logic[3:0] tens_counter = 0;

    logic [3:0] player_ones_digit, player_tens_digit, player_hundred_digit;
    assign ones_digit = player_ones_digit;
    assign tens_digit = player_tens_digit;
    assign hundred_digit = player_hundred_digit;
    
    
    always @(posedge clk) begin
        if(reset) begin
            counter = hp;
        end
        
        if(counter) begin
            player_tens_digit = counter % 100;
            player_ones_digit = counter % 10;     
        end
    end


endmodule
