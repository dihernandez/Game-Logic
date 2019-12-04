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
    //.reset_in(reset),         // 1 to initialize module
    input p1_x_in, // player 1's x position
    input p2_x_in,  // player 2's x position
    
    input p1_left,
    input p1_right,
    input p1_kick,
    input p1_punch,
    
    input p2_left,
    input p2_right,
    input p2_kick,
    input p2_punch
    );
    
    parameter AT_REST = 3'b000;
    parameter MOVING_BACKWARDS = 3'b001;
    parameter MOVING_FORWARDS = 3'b010;
    parameter KICKING = 3'b011;
    parameter PUNCHING = 3'b100;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;

    logic[6:0] p1_hitpoints;
    logic[6:0] p2_hitpoints;
 
    
    logic[8:0] distance_p1_to_p2_current;
    logic[8:0] distance_p1_to_p2_previous;

    logic[8:0] distance_p2_to_p1_current;
    logic[8:0] distance_p2_to_p1_previous;  
    
    logic[2:0] state = AT_REST;
    logic[2:0] next_state;
    
    always @(posedge vclock_in) begin
        case(state)
            AT_REST: begin // stay here unless signals to move or attack
                if(p2_punch &&  distance_p2_to_p1_current < PUNCHING_DISTANCE) begin
                    next_state <= PUNCHING;
                end
            end
            
            
            default: state <= AT_REST;
        endcase
    end

    
    
    
endmodule
