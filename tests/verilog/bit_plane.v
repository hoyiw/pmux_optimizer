module bit_plane (
    input  wire [4:0]  index,
    input  wire [47:0] d0,
    input  wire [47:0] d1,
    input  wire [47:0] d2,
    input  wire [47:0] d3,
    input  wire [47:0] d4,
    input  wire [47:0] d5,
    input  wire [47:0] d6,
    input  wire [47:0] d7,
    input  wire [47:0] d8,
    input  wire [47:0] d9,
    output reg  [47:0] y
);
    always @* begin
        case (index)
            5'd0: y = d0;
            5'd1: y = d1;
            5'd2: y = {d0[47:16], 16'h0000};
            5'd3: y = {d1[47:24], d2[23:0]};
            5'd4: y = {24'h000000, d3[23:0]};
            5'd5: y = d4;
            5'd6: y = {d4[47:32], 32'h00000000};
            5'd7: y = {32'h00000000, d5[15:0]};
            5'd8: y = d6;
            5'd9: y = {16'h0000, d7[31:0]};
            default: y = 48'hffffffffffff;
        endcase
    end
endmodule
