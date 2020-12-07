// (C) 2020, Adam Silverman/Tuan Dau
module Adam3201Project(
   input [9:0] SW,
   input [1:0] KEY,
   input MAX10_CLK1_50,
   output [9:0] LEDR,
   input G9,
   output G8, G11, G13, G15, G17, G19, G21,
   output [7:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
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
assign LEDR[5:2] = 7'b0;
assign HEX5[7] = 1;
assign HEX4[7] = 1;
assign HEX2[7] = 1;
assign HEX1[7] = 1;
assign HEX0[7] = 1;

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
wire[1:0] switch_pos_1 = SW[9:8] + 1;
wire[7:0] duty_cycle_1 = (switch_pos_1 << 6) - 8'd1;
seg7 h4(SW[9:8] + 4'd1, HEX4);

assign LEDR[7:6] = SW[7:6];
wire[1:0] switch_pos_2 = SW[7:6] + 1;
wire[7:0] duty_cycle_2 = (switch_pos_2 << 6) - 8'd1;
seg7 h3(SW[7:6] + 4'd1, HEX3);
assign HEX3[7] = 1'b0;

// PWM drivers
reg direction_1 = 1;
reg direction_2 = 1;
MotorPWM motor1(Clock500K, direction_1, enable, duty_cycle_1, G11, G13, G15);
MotorPWM motor2(Clock500K, direction_2, enable, duty_cycle_2, G21, G17, G19);

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
							 
// Autonomy, determine whether or not car is far enough from object
wire turn = SW[1]; // enable this to turn around instead of move back
assign LEDR[1] = SW[1];
reg [15:0] isClose;
reg moveBack;

wire Clock5;
ClockDivider5Hz(MAX10_CLK1_50, Clock5);

always @(posedge Clock5) begin
	if (distance < 20) begin
		isClose = isClose << 1;
		isClose[0] = 1;
	end else begin
		isClose = isClose << 1;
		isClose[0] = 0;
	end

	moveBack = |isClose;

	if (moveBack) begin
		direction_1 = 0;
		direction_2 = turn;
	end else begin
		direction_1 = 1;
		direction_2 = 1;
	end
end							 
endmodule
