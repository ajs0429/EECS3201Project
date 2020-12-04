// (C) 2020, Adam Silverman/Tuan Dau
module sonic(
   input clock,
	output trig,
	input echo,
	output reg [32:0] distance
);


reg [20:0] counter;
reg [32:0] us_counter = 0;

reg _trig = 1'b0;

assign trig = _trig;

always @(posedge clock) begin
	counter <= counter + 1;
	
	if(counter % 2000000 == 0) begin // 40ms action
		_trig <= 1'b1;
	end
		
	if (counter % 500 == 0 && _trig) begin // 50MHz => 50 cycles per microsecond => 500 cycles per 10 microseconds
		_trig <= 1'b0;
	end

	if (counter % 50 == 0) begin
		if (echo) begin
			us_counter <= us_counter + 1;
		end else if (us_counter) begin
			distance <= us_counter / 58;
			us_counter <= 0;
		end
	end
end

endmodule