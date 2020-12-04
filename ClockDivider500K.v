// (C) 2020, Adam Silverman/Tuan Dau
module ClockDivider500K(
	input cin,
	output cout
);
reg[18:0] counter = 18'd0;
parameter DIVISOR = 18'd100;

always @(posedge cin)
begin
	counter <= counter + 18'd1;
	if (counter >= (DIVISOR - 1))
		counter <= 18'd0;
end
assign cout = (counter < DIVISOR / 2) ? 1'b0 : 1'b1;
endmodule