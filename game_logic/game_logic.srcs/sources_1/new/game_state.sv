`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 07:31:21 PM
// Design Name: 
// Module Name: game_state
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module game_state(
    input vclock_in,        // 65MHz clock
    input reset_in,         // 1 to initialize module
    input [10:0] p1_x_in, // player 1's x position
    input [10:0] p2_x_in,  // player 2's x position
    input p1_kick,
    input p1_punch,
    input p2_kick,
    input p2_punch,
    
    output [1:0] p1_state,
    output [1:0] p2_state,
    output[6:0] p1_hitpoints,
    output[6:0] p2_hitpoints
    );
    
    parameter AT_REST = 2'b00;
    parameter KICKING = 2'b01;
    parameter PUNCHING = 2'b10;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;
 
    logic[6:0] p1_hp, p2_hp;
    assign p1_hitpoints = p1_hp;
    assign p2_hitpoints = p2_hp;
    
    logic[8:0] distance_p1_to_p2; 
    
    // keep track of when hit action was initiated
    // what behaviour to expect when value is exceeded
    logic[8:0] p1_hit_time_stamp = 0;
    logic[8:0] p2_hit_time_stamp = 0;
    logic[8:0] cycle_counter = 0;
    
    logic[2:0] player_1_state = AT_REST;
    logic[2:0] p1_next_state;
    logic[2:0] player_2_state = AT_REST;
    logic[2:0] p2_next_state;
    assign p1_state = player_1_state;
    assign p2_state = player_2_state;
    
    // handle p1 state logic. NOTE: can interact wtih state 2 logic
    always @(posedge vclock_in) begin
        cycle_counter <= cycle_counter + 1; // only need one counter
        player_1_state <= p1_next_state;
        distance_p1_to_p2 = p2_x_in - p1_x_in;
        case(p1_state)
            AT_REST: begin // stay here unless signals to move or attack
                if(p1_punch &&  distance_p1_to_p2 < PUNCHING_DISTANCE) begin
                    p1_next_state <= PUNCHING;
                    p1_hit_time_stamp <= cycle_counter;
                end
                if(p1_punch &&  distance_p1_to_p2 < KICKING_DISTANCE) begin
                    p1_next_state <= KICKING;
                    p1_hit_time_stamp <= cycle_counter;
                end
            end
            
            PUNCHING: begin
                // handle both in punching state
                if(p2_state == PUNCHING) begin
                    if(p1_hit_time_stamp < p2_hit_time_stamp) begin
                        p2_hp <= p2_hp - 5;
                    end
                end else begin
                    p2_hp <= p2_hp - 5;
                end
                p1_next_state <= AT_REST;
            end
            
            KICKING: begin
                // handle both in punching state
                if(p2_state == KICKING) begin
                    if(p1_hit_time_stamp < p2_hit_time_stamp) begin
                        p2_hp <= p2_hp - 10;
                    end
                end else begin
                    p2_hp <= p2_hp - 10;
                end
                p1_next_state <= AT_REST;
            end
            
            default: p1_next_state <= AT_REST;
        endcase
    end
    
    // handle p2 state logic. NOTE: can interact wtih state 1 logic
    always @(posedge vclock_in) begin
        player_2_state <= p2_next_state;
        case(p2_state)
            AT_REST: begin
                if(p2_punch && distance_p1_to_p2 < PUNCHING_DISTANCE) begin
                    p2_next_state <= PUNCHING;
                    p2_hit_time_stamp <= cycle_counter;
                end
                if(p2_kick && distance_p1_to_p2 < KICKING_DISTANCE) begin
                    p2_next_state <= KICKING;
                    p2_hit_time_stamp <= cycle_counter;
                end
            end
            
            PUNCHING: begin
                // handle both in punching state
                if(p1_state == PUNCHING) begin
                    if(p2_hit_time_stamp < p1_hit_time_stamp) begin
                        p1_hp <= p1_hp - 5;
                    end
                end else begin
                    p1_hp <= p1_hp - 5;
                end
                p2_next_state <= AT_REST; 
            end
            
            
            KICKING: begin
                // handle both in punching state
                if(p1_state == KICKING) begin
                    if(p2_hit_time_stamp < p1_hit_time_stamp) begin
                        p1_hp <= p1_hp - 10;
                    end
                end else begin
                    p1_hp <= p1_hp - 10;
                end
                p2_next_state <= AT_REST;
            end
        
        default: p2_next_state <= AT_REST;
        endcase
    end

endmodule
