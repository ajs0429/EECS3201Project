module MotorPWM(
	input cin,
	input dir, // 1 for forward, 0 for backward
	input enable,
	input[7:0] duty_cycle,
	output reg enable_pwm,
	output out1,
	output out2
);

assign out1 = ~dir;
assign out2 = dir;

reg[7:0] count = 8'd0;

always @(posedge cin)
begin
	count <= count + 8'd1;
	enable_pwm <= enable & ((count <= duty_cycle) ? 1'b1 : 1'b0);
end
endmodule
