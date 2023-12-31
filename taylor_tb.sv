`timescale 1ns / 1ps

module taylor_tb;
reg clock, reset, start;
reg [23:0] angle_in;
wire ready_out;
wire [23:0] cos_out;
real real_cos, real_angle;
parameter FXP_MUL = 1024.0;

taylor_rtl taylor_rtl_inst(clock, reset, start, ready_out, angle_in, cos_out);

// Clock generator
initial
 clock <= 1'b1;
always
    #5 clock <= ~clock;

// Reset signal
initial
begin
    reset <= 1'b1;
    #10 reset <= 1'b0;
end

// Stimuli signals
initial
begin
    angle_in <= 0.0; // Modify value in fixed-point [2:10]
    start <= 1'b0;
    #20 start <= 1'b1;
    #30 start <= 1'b0;
end
// Catch output
always @ (posedge ready_out)
begin
    #10 real_cos = cos_out /FXP_MUL;
    #10 real_angle = angle_in /FXP_MUL;
    $display("angle=%f, cos=%f", real_angle, real_cos);
    #10 angle_in <= angle_in + 0.1 * FXP_MUL; // Modify value in fixed-point [2:10]
    #20 start <= 1'b0;
    #20 start <= 1'b1;
    if (angle_in > 1.5 * FXP_MUL )
      $stop; 
end
endmodule