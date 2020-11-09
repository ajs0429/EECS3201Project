module ClockDivider2K(
	input cin,
	output cout
);
reg[14:0] counter = 15'd0;
parameter DIVISOR = 15'd25_000;

always @(posedge cin)
begin
	counter <= counter + 15'd1;
	if (counter >= (DIVISOR - 1))
		counter <= 15'd0;
end
assign cout = (counter < DIVISOR / 2) ? 1'b0 : 1'b1;
endmodule