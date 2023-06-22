`timescale 1ns / 1ps

module taylor_horner_rtl(clock, reset, start, ready_out, angle_in, cos_out );
// Module is using Horner's Rule

// Fixed Point Parameters
parameter integer W = 24; 
parameter FXP_MUL = 1024;
parameter FXP_SHIFT = 10;

//Input, output ports
input clock, reset, start;
input [W-1:0] angle_in;
output reg ready_out;
output reg [W-1:0] cos_out ;

// ~1/6!, ~1/4!, 1/2!
reg signed [W-1:0] divider[0:2] = { 12'b000000000010, 12'b000000101010, 12'b001000000000 };

// State machine
parameter S1 = 4'h00, S2 = 4'h01, S3 = 4'h02, S4 = 4'h03, S5 = 4'h04, S6 = 4'h05, S7 = 4'h06;
reg [2:0] state;

// Temporary variables for calculations
reg signed [W -1:0] angle_2, temp_22, temp_24, temp_26;

always @ (posedge clock)
begin
    if(reset==1'b1)
    begin
        ready_out <= 1'b0;
        state <= S1;
    end
    else
    begin
    case(state)
        S1: begin
            if(start == 1'b1) state <= S2; else state <= S1;
           end
        S2: begin
            angle_2 <= (angle_in * angle_in) / FXP_MUL; // calculating input angle^2
            cos_out  <= 0;
            temp_22 <= 0;
            temp_24 <= 0;
            temp_26 <= 0;
            ready_out <= 0;
            state <= S3; // move to state 3
        end
        S3: begin
            temp_22 <= (angle_2 * divider[2]) >> FXP_SHIFT; //calculating angle^2/2!
            temp_24 <= (angle_2 * divider[1]) >> FXP_SHIFT; //angle^2/4!
            temp_26 <= (angle_2 * divider[0]) >> FXP_SHIFT; //angle^2/6!
            state <= S4; // move to state 4
        end
        S4:begin
            cos_out <= (angle_2 * temp_26) >> FXP_SHIFT; 
            cos_out <= cos_out - temp_24;
            state <= S5; // move to state 5
        end
        S5:begin
            cos_out <= (angle_2 * cos_out) >> FXP_SHIFT;
            cos_out <= temp_22 + cos_out;
            state <= S6; // move to state 6
        end
        S6:begin
            cos_out  <= 1 * FXP_MUL - cos_out;
            ready_out = 1;
            state <= S7; // move to state 7
        end
        S7: begin
            if(start == 1'b1) state <= S7; else state <= S1; // Wait for start
        end
    endcase
    end
end

endmodule