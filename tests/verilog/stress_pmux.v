module stress_pmux (
    input  wire [4:0]  idx,
    input  wire [31:0] i0,
    input  wire [31:0] i1,
    input  wire [31:0] i2,
    input  wire [31:0] i3,
    input  wire [31:0] i4,
    input  wire [31:0] i5,
    input  wire [31:0] i6,
    input  wire [31:0] i7,
    input  wire [31:0] i8,
    input  wire [31:0] i9,
    input  wire [31:0] i10,
    input  wire [31:0] i11,
    input  wire [31:0] i12,
    input  wire [31:0] i13,
    input  wire [31:0] i14,
    input  wire [31:0] i15,
    input  wire [31:0] mask,
    output reg  [31:0] y
);
    always @* begin
        y = {32{1'b0}};
        case (idx)
            5'd0:  y = i0;
            5'd1:  y = i1 & mask;
            5'd2:  y = i2;
            5'd3:  y = {i3[30:0], 1'b0};
            5'd4:  y = i4 ^ mask;
            5'd5:  y = i2;
            5'd6:  y = i6;
            5'd7:  y = {16'h0000, i7[15:0]};
            5'd8:  y = i8;
            5'd9:  y = i8;
            5'd10: y = i10 & mask;
            5'd11: y = i11;
            5'd12: y = {i12[15:0], 16'h0000};
            5'd13: y = i11;
            5'd14: y = i14;
            5'd15: y = {31'h00000000, i15[0]};
            5'd16: y = i0;
            5'd17: y = i1;
            5'd18: y = 32'hcafebabe;
            5'd19: y = 32'h12345678;
            5'd20: y = i4;
            5'd21: y = i5;
            5'd22: y = i6;
            5'd23: y = i7;
            default: y = 32'hdeadbeef;
        endcase
    end

endmodule
