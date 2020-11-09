module Adam3201Project(
    input [9:0] SW,
	 input MAX10_CLK1_50,
    output [9:0] LEDR,
	 output [35:0] GPIO,
	 output [6:0] HEX5, HEX2, HEX1, HEX0
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

// Construct 500 kHz clock (gives a very close to 2 kHz PWM cycle)
wire Clock500K;
ClockDivider500K cdiv500k(MAX10_CLK1_50, Clock500K);

// Enables the motor controller
wire enable = SW[0];
seg7 h5(enable ? 8'b1111_1110 : 8'b0, HEX5);

// Adjusts duty cycle (255 = always on, 0 = always off, 127 = 50% on)
wire[7:0] duty_cycle = SW[9:2];
assign LEDR[9:2] = duty_cycle;
seg7 h0(duty_cycle % 10, HEX0);
seg7 h1((duty_cycle % 100) / 10, HEX1);
seg7 h2((duty_cycle % 1000) / 100, HEX2);

// PWM drivers
MotorPWM motor1(Clock500K, 1'b1, enable, duty_cycle, GPIO[11], GPIO[13], GPIO[15]);
MotorPWM motor2(Clock500K, 1'b1, enable, duty_cycle, GPIO[21], GPIO[17], GPIO[19]);

// LEDs representing PWM output (for debug)
assign LEDR[1] = GPIO[11];
assign LEDR[0] = GPIO[21];
endmodule