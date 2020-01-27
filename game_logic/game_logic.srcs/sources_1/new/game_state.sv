`timescale 1ns / 1ps

module game_state(
    input pixel_clk,        // 65MHz clock
    input reset_in,         // 1 to initialize module
    input [10:0] p1_x_in, // player 1's x position
    input [10:0] p2_x_in,  // player 2's x position
    input punch,
    input kick,
    
    output [1:0] state,
    output [6:0] hitpoints
    );
    
    parameter AT_REST = 2'b00;
    parameter KICKING = 2'b01;
    parameter PUNCHING = 2'b10;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;
 
    logic[6:0] hp = 100; 

    assign hitpoints = hp;

    logic[11:0] distance_p1_to_p2, distance_p2_to_p1, distance_between;

    logic punch_previous = 0;
    logic kick_previous = 0;
    logic punch_on, kick_on, punch_off, kick_off;
    assign punch_on = ((punch_previous == 0) && (punch == 1)); //check if attack button has been let go
    assign kick_on = ((kick_previous == 0) && (kick == 1));
    assign punch_off = ((punch_previous == 1) && (punch == 0)); //check if attack button has been let go
    assign kick_off = ((kick_previous == 1) && (kick == 0));

    logic[1:0] player_state = AT_REST;
    logic[1:0] next_state;
    assign state = player_state;
      
    always @(posedge pixel_clk) begin
        if (reset_in) begin
            next_state <= AT_REST;
            hp <= 100;
            punch_previous <= 0;
            kick_previous <= 0;
        end else begin
        
            player_state <= next_state;
            punch_previous <= punch;
            kick_previous <= kick;
            
            distance_p1_to_p2 <= p2_x_in - (p1_x_in + 64); // offset for p1 width
            distance_p2_to_p1 <= (p1_x_in + 64) - p2_x_in;
            // account for overflow error
            distance_between <= distance_p1_to_p2 < distance_p2_to_p1 ? distance_p1_to_p2 : distance_p2_to_p1;
            case(state)
                AT_REST: begin // stay here unless signals to move or attack
                    if(punch_on && (distance_between < PUNCHING_DISTANCE)) begin
                         hp <= (hp >= 5) ? (hp - 5) : 0;
                         next_state <= PUNCHING;
                    end else // punching takes precedense over kicking, arbitrary
                    if(kick_on &&  (distance_between < KICKING_DISTANCE)) begin
                        hp <= (hp >= 10) ? (hp - 10) : 0;
                        next_state <= KICKING;
                    end
                end
                
                // keeping states for motion's sake                
                PUNCHING: begin
                    if (punch_off) begin
                        next_state <= AT_REST;
                    end
                end
                
                KICKING: begin
                    if (kick_off) begin
                        next_state <= AT_REST;
                    end
                end
                
                default: next_state <= AT_REST;
            endcase

        end
    end

endmodule
