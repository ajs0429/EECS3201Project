module Adam3201Project(
    input [9:0] SW,
	 input MAX10_CLK1_50,
    output [9:0] LEDR,
	 output [35:0] GPIO,
	 output [6:0] HEX2, HEX1, HEX0
);
/*
Pins:

11 - EN1
13 - OUT1
15 - OUT2
17 - OUT3
19 - OUT4
21 - EN2

*/
wire Clock2K;
ClockDivider2K cdiv2k(MAX10_CLK1_50, Clock2K);

wire enable = SW[0];

wire[7:0] duty_cycle = SW[9:2];
assign LEDR[9:2] = duty_cycle;
seg7 h0(duty_cycle % 10, HEX0);
seg7 h1((duty_cycle % 100) / 10, HEX1);
seg7 h2((duty_cycle % 1000) / 100, HEX2);

MotorPWM motor1(Clock2K, 1'b1, enable, duty_cycle, GPIO[11], GPIO[13], GPIO[15]);
MotorPWM motor2(Clock2K, 1'b1, enable, duty_cycle, GPIO[21], GPIO[17], GPIO[19]);

assign LEDR[1] = GPIO[11];
assign LEDR[0] = GPIO[21];
endmodule