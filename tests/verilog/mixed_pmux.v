module mixed_pmux (
    input  wire [4:0]  index,
    input  wire [1:0]  mode,
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [15:0] c,
    input  wire [15:0] d,
    input  wire [15:0] e,
    input  wire [15:0] f,
    input  wire [15:0] g,
    output reg  [15:0] y
);
    reg [15:0] first;
    reg [15:0] second;

    always @* begin
        case (index)
            5'd0: first = a;
            5'd1: first = b;
            5'd2: first = a;
            5'd3: first = c;
            5'd4: first = d;
            5'd5: first = a;
            5'd6: first = b;
            5'd7: first = e;
            5'd8: first = a;
            5'd9: first = f;
            5'd10: first = c;
            5'd11: first = a;
            5'd12: first = g;
            5'd13: first = b;
            5'd14: first = d;
            default: first = 16'h0000;
        endcase
    end

    always @* begin
        case (mode)
            2'd0: second = first;
            2'd1: second = first ^ 16'h00ff;
            2'd2: second = {first[14:0], first[15]};
            default: second = first + 16'h0001;
        endcase
    end

    always @* y = second;
endmodule
