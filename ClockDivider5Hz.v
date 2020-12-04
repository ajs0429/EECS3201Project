// (C) 2020, Adam Silverman/Tuan Dau
module ClockDivider5Hz(
	input cin,
	output cout
);
reg[25:0] counter = 26'd0;
parameter DIVISOR = 26'd10_000_000;

always @(posedge cin)
begin
	counter <= counter + 26'd1;
	if (counter >= (DIVISOR - 1))
		counter <= 26'd0;
end
assign cout = (counter < DIVISOR / 2) ? 1'b0 : 1'b1;
endmodule