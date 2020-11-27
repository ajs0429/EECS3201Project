module Adam3201Project(
   input [9:0] SW,
   input [1:0] KEY,
   input MAX10_CLK1_50,
   output [9:0] LEDR,
   input G9,
   output G8, G11, G13, G15, G17, G19, G21,
   output [6:0] HEX5, HEX4, HEX2, HEX1, HEX0,
   output [3:0] VGA_B, VGA_G, VGA_R,
   output VGA_HS, VGA_VS
);
/*
Pins:

11 - EN1
13 - OUT1
15 - OUT2
17 - OUT3
19 - OUT4
21 - EN2

9 - Echo
8 - Trig

*/
assign LEDR[7:1] = 7'b0;

// Construct 500 kHz clock (gives a very close to 2 kHz PWM cycle)
wire Clock500K;
ClockDivider500K cdiv500k(MAX10_CLK1_50, Clock500K);

// Enables the motor controller
wire enable = SW[0];
assign LEDR[0] = enable;
seg7 h5(enable ? 4'he : 4'h0, HEX5);

// Adjusts duty cycle to 4 levels - 255 (100%), 191 (75%), 127 (50%), 63 (25%). Has problems starting in levels 1 and 2.
// Recommended to only use level 4.
assign LEDR[9:8] = SW[9:8];
wire[1:0] switch_pos = SW[9:8] + 1;
wire[7:0] duty_cycle = (switch_pos << 6) - 8'd1;
seg7 h4(SW[9:8] + 4'd1, HEX4);

// PWM drivers
MotorPWM motor1(Clock500K, 1'b1, enable, duty_cycle, G11, G13, G15);
MotorPWM motor2(Clock500K, 1'b1, enable, duty_cycle, G21, G17, G19);

// Ultrasonic sensors
wire [32:0] distance;
sonic sonic1(MAX10_CLK1_50, G8, G9, distance);
seg7 h0(distance % 10, HEX0);
seg7 h1((distance % 100) / 10, HEX1);
seg7 h2((distance % 1000) / 100, HEX2);

// VGA
wire VGA_CTRL_CLK;
                   
vga_pll u1(
   .areset(),
   .inclk0(MAX10_CLK1_50),
   .c0(VGA_CTRL_CLK),
   .locked());

   
vga_controller vga_ins(.iRST_n(KEY[0]),
                      .iVGA_CLK(VGA_CTRL_CLK),
							 .distance(distance),
                      .oHS(VGA_HS),
                      .oVS(VGA_VS),
                      .oVGA_B(VGA_B),
                      .oVGA_G(VGA_G),
                      .oVGA_R(VGA_R)); 
endmodule
