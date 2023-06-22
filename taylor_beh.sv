module taylor_beh();
// Using Horner's Rule

real t_angle = 0.5; // Example angle

real cos_out = 0, temp_2 = 0;
parameter FXP_MUL = 1024;
parameter FXP_SHIFT = 10;
integer i;

initial begin

    for (i=0; i<10; i = i+1) begin
        temp_2 = t_angle * t_angle;
        cos_out = temp_2 / 720;
        cos_out = - temp_2 / 24 + temp_2 * cos_out;
        cos_out = temp_2 / 2 + temp_2 * cos_out;
        cos_out = 1 - cos_out;
        $display("angle = %f rad, cos = %f", t_angle, cos_out);
        t_angle = t_angle + 0.1;
    end
end
endmodule
