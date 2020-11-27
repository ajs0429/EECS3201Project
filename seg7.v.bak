// code previously from lab 2
module seg7(
    input [3:0] d,
    output [6:0] segments
);
	assign segments[6] = (~d[3] & ~d[2] & ~d[1]) | (d[2] & ((~d[3] & d[1] & d[0]) | (d[3] & ~d[1] & ~d[0])));
	assign segments[5] = ((~d[3] & ~d[2]) & (d[1] | d[0])) | ((d[2] & d[0]) & (d[3] ^ d[1]));
	assign segments[4] = (~d[3] & ((~d[2] & d[0]) | (d[2] & ~d[1]) | (d[2] & d[1] & d[0]))) | (d[3] & ~d[2] & ~d[1] & d[0]);
	assign segments[3] = (~d[3] & ((~d[2] & ~d[1] & d[0]) | (d[2] & ~d[1] & ~d[0]) | (d[2] & d[1] & d[0]))) | (d[3] & ((~d[2] & (d[1] ^ d[0])) | (d[2] & d[1] & d[0])));
	assign segments[2] = (~d[3] & ~d[2] & d[1] & ~d[0]) | (d[3] & d[2] & ~(~d[1] & d[0]));
	assign segments[1] = (~d[3] & ((d[2] & ~d[1] & d[0]) | (d[2] & d[1] & ~d[0]))) | (d[3] & ((~d[2] & d[1] & d[0]) | (d[2] & ~(~d[1] & d[0]))));
	assign segments[0] = (~d[3] & ((~d[2] & ~d[1] & d[0]) | (d[2] & ~d[1] & ~d[0]))) | (d[3] & d[0] & (d[2] ^ d[1]));
endmodule