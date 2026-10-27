module single_pmux (
    input  wire [2:0]  sel,
    input  wire [31:0] d0,
    input  wire [31:0] d1,
    input  wire [31:0] d2,
    input  wire [31:0] d3,
    input  wire [31:0] d4,
    input  wire [31:0] d5,
    input  wire [31:0] d6,
    input  wire [31:0] dflt,
    output reg  [31:0] y
);
    always @* begin
        case (sel)
            3'd0: y = d0;
            3'd1: y = d1;
            3'd2: y = d2;
            3'd3: y = d3;
            3'd4: y = d4;
            3'd5: y = d5;
            3'd6: y = d6;
            default: y = dflt;
        endcase
    end
endmodule
