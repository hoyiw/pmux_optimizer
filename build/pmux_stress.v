module pmux_stress (
    input wire [31:0] d0,
    input wire [31:0] d1,
    input wire [31:0] d2,
    input wire [31:0] d3,
    input wire [31:0] d4,
    input wire [31:0] d5,
    input wire [31:0] d6,
    input wire [31:0] d7,
    input wire [31:0] d8,
    input wire [31:0] d9,
    input wire [31:0] d10,
    input wire [31:0] d11,
    input wire [31:0] d12,
    input wire [31:0] d13,
    input wire [31:0] d14,
    input wire [31:0] d15,
    input wire [4:0] idx0,
    input wire [4:0] idx1,
    input wire [4:0] idx2,
    input wire [4:0] idx3,
    input wire [4:0] idx4,
    input wire [4:0] idx5,
    input wire [4:0] idx6,
    input wire [4:0] idx7,
    input wire [4:0] idx8,
    input wire [4:0] idx9,
    input wire [4:0] idx10,
    input wire [4:0] idx11,
    input wire [4:0] idx12,
    input wire [4:0] idx13,
    input wire [4:0] idx14,
    input wire [4:0] idx15,
    input wire [4:0] idx16,
    input wire [4:0] idx17,
    input wire [4:0] idx18,
    input wire [4:0] idx19,
    input wire [4:0] idx20,
    input wire [4:0] idx21,
    input wire [4:0] idx22,
    input wire [4:0] idx23,
    input wire [4:0] idx24,
    input wire [4:0] idx25,
    input wire [4:0] idx26,
    input wire [4:0] idx27,
    input wire [4:0] idx28,
    input wire [4:0] idx29,
    input wire [4:0] idx30,
    input wire [4:0] idx31,
    input wire [4:0] idx32,
    input wire [4:0] idx33,
    input wire [4:0] idx34,
    input wire [4:0] idx35,
    input wire [4:0] idx36,
    input wire [4:0] idx37,
    input wire [4:0] idx38,
    input wire [4:0] idx39,
    input wire [4:0] idx40,
    input wire [4:0] idx41,
    input wire [4:0] idx42,
    input wire [4:0] idx43,
    input wire [31:0] seed,
    output reg [31:0] y0,
    output reg [31:0] y1,
    output reg [31:0] y2,
    output reg [31:0] y3,
    output reg [31:0] y4,
    output reg [31:0] y5,
    output reg [31:0] y6,
    output reg [31:0] y7,
    output reg [31:0] y8,
    output reg [31:0] y9,
    output reg [31:0] y10,
    output reg [31:0] y11,
    output reg [31:0] y12,
    output reg [31:0] y13,
    output reg [31:0] y14,
    output reg [31:0] y15,
    output reg [31:0] y16,
    output reg [31:0] y17,
    output reg [31:0] y18,
    output reg [31:0] y19,
    output reg [31:0] y20,
    output reg [31:0] y21,
    output reg [31:0] y22,
    output reg [31:0] y23,
    output reg [31:0] y24,
    output reg [31:0] y25,
    output reg [31:0] y26,
    output reg [31:0] y27,
    output reg [31:0] y28,
    output reg [31:0] y29,
    output reg [31:0] y30,
    output reg [31:0] y31,
    output reg [31:0] y32,
    output reg [31:0] y33,
    output reg [31:0] y34,
    output reg [31:0] y35,
    output reg [31:0] y36,
    output reg [31:0] y37,
    output reg [31:0] y38,
    output reg [31:0] y39,
    output reg [31:0] y40,
    output reg [31:0] y41,
    output reg [31:0] y42,
    output reg [31:0] y43
);
    always @* begin
        case (idx0)
            5'd0: y0 = d0;
            5'd1: y0 = d1;
            5'd2: y0 = d2;
            5'd3: y0 = d3;
            5'd4: y0 = d4;
            5'd5: y0 = d5;
            5'd6: y0 = d6;
            5'd7: y0 = d7;
            5'd8: y0 = d8;
            5'd9: y0 = d9;
            5'd10: y0 = d10;
            5'd11: y0 = d11;
            5'd12: y0 = d12;
            5'd13: y0 = d13;
            5'd14: y0 = d14;
            5'd15: y0 = d15;
            default: y0 = seed ^ 1;
        endcase
    end
    always @* begin
        case (idx1)
            5'd0: y1 = (d0 ^ seed);
            5'd1: y1 = (d1 ^ seed);
            5'd2: y1 = (d2 ^ seed);
            5'd3: y1 = (d3 ^ seed);
            5'd4: y1 = (d4 ^ seed);
            5'd5: y1 = (d5 ^ seed);
            5'd6: y1 = (d6 ^ seed);
            5'd7: y1 = (d7 ^ seed);
            5'd8: y1 = (d8 ^ seed);
            5'd9: y1 = (d9 ^ seed);
            5'd10: y1 = (d10 ^ seed);
            5'd11: y1 = (d11 ^ seed);
            5'd12: y1 = (d12 ^ seed);
            5'd13: y1 = (d13 ^ seed);
            5'd14: y1 = (d14 ^ seed);
            5'd15: y1 = (d15 ^ seed);
            default: y1 = seed ^ 2;
        endcase
    end
    always @* begin
        case (idx2)
            5'd0: y2 = {(d0 << 3), d0 >> (29)};
            5'd1: y2 = {(d1 << 3), d1 >> (29)};
            5'd2: y2 = {(d2 << 3), d2 >> (29)};
            5'd3: y2 = {(d3 << 3), d3 >> (29)};
            5'd4: y2 = {(d4 << 3), d4 >> (29)};
            5'd5: y2 = {(d5 << 3), d5 >> (29)};
            5'd6: y2 = {(d6 << 3), d6 >> (29)};
            5'd7: y2 = {(d7 << 3), d7 >> (29)};
            5'd8: y2 = {(d8 << 3), d8 >> (29)};
            5'd9: y2 = {(d9 << 3), d9 >> (29)};
            5'd10: y2 = {(d10 << 3), d10 >> (29)};
            5'd11: y2 = {(d11 << 3), d11 >> (29)};
            5'd12: y2 = {(d12 << 3), d12 >> (29)};
            5'd13: y2 = {(d13 << 3), d13 >> (29)};
            5'd14: y2 = {(d14 << 3), d14 >> (29)};
            5'd15: y2 = {(d15 << 3), d15 >> (29)};
            default: y2 = seed ^ 3;
        endcase
    end
    always @* begin
        case (idx3)
            5'd0: y3 = (d0 + 4);
            5'd1: y3 = (d1 + 4);
            5'd2: y3 = (d2 + 4);
            5'd3: y3 = (d3 + 4);
            5'd4: y3 = (d4 + 4);
            5'd5: y3 = (d5 + 4);
            5'd6: y3 = (d6 + 4);
            5'd7: y3 = (d7 + 4);
            5'd8: y3 = (d8 + 4);
            5'd9: y3 = (d9 + 4);
            5'd10: y3 = (d10 + 4);
            5'd11: y3 = (d11 + 4);
            5'd12: y3 = (d12 + 4);
            5'd13: y3 = (d13 + 4);
            5'd14: y3 = (d14 + 4);
            5'd15: y3 = (d15 + 4);
            default: y3 = seed ^ 4;
        endcase
    end
    always @* begin
        case (idx4)
            5'd0: y4 = d0;
            5'd1: y4 = d1;
            5'd2: y4 = d2;
            5'd3: y4 = d3;
            5'd4: y4 = d4;
            5'd5: y4 = d5;
            5'd6: y4 = d6;
            5'd7: y4 = d7;
            5'd8: y4 = d8;
            5'd9: y4 = d9;
            5'd10: y4 = d10;
            5'd11: y4 = d11;
            5'd12: y4 = d12;
            5'd13: y4 = d13;
            5'd14: y4 = d14;
            5'd15: y4 = d15;
            default: y4 = seed ^ 5;
        endcase
    end
    always @* begin
        case (idx5)
            5'd0: y5 = (d0 ^ seed);
            5'd1: y5 = (d1 ^ seed);
            5'd2: y5 = (d2 ^ seed);
            5'd3: y5 = (d3 ^ seed);
            5'd4: y5 = (d4 ^ seed);
            5'd5: y5 = (d5 ^ seed);
            5'd6: y5 = (d6 ^ seed);
            5'd7: y5 = (d7 ^ seed);
            5'd8: y5 = (d8 ^ seed);
            5'd9: y5 = (d9 ^ seed);
            5'd10: y5 = (d10 ^ seed);
            5'd11: y5 = (d11 ^ seed);
            5'd12: y5 = (d12 ^ seed);
            5'd13: y5 = (d13 ^ seed);
            5'd14: y5 = (d14 ^ seed);
            5'd15: y5 = (d15 ^ seed);
            default: y5 = seed ^ 6;
        endcase
    end
    always @* begin
        case (idx6)
            5'd0: y6 = {(d0 << 1), d0 >> (31)};
            5'd1: y6 = {(d1 << 1), d1 >> (31)};
            5'd2: y6 = {(d2 << 1), d2 >> (31)};
            5'd3: y6 = {(d3 << 1), d3 >> (31)};
            5'd4: y6 = {(d4 << 1), d4 >> (31)};
            5'd5: y6 = {(d5 << 1), d5 >> (31)};
            5'd6: y6 = {(d6 << 1), d6 >> (31)};
            5'd7: y6 = {(d7 << 1), d7 >> (31)};
            5'd8: y6 = {(d8 << 1), d8 >> (31)};
            5'd9: y6 = {(d9 << 1), d9 >> (31)};
            5'd10: y6 = {(d10 << 1), d10 >> (31)};
            5'd11: y6 = {(d11 << 1), d11 >> (31)};
            5'd12: y6 = {(d12 << 1), d12 >> (31)};
            5'd13: y6 = {(d13 << 1), d13 >> (31)};
            5'd14: y6 = {(d14 << 1), d14 >> (31)};
            5'd15: y6 = {(d15 << 1), d15 >> (31)};
            default: y6 = seed ^ 7;
        endcase
    end
    always @* begin
        case (idx7)
            5'd0: y7 = (d0 + 8);
            5'd1: y7 = (d1 + 8);
            5'd2: y7 = (d2 + 8);
            5'd3: y7 = (d3 + 8);
            5'd4: y7 = (d4 + 8);
            5'd5: y7 = (d5 + 8);
            5'd6: y7 = (d6 + 8);
            5'd7: y7 = (d7 + 8);
            5'd8: y7 = (d8 + 8);
            5'd9: y7 = (d9 + 8);
            5'd10: y7 = (d10 + 8);
            5'd11: y7 = (d11 + 8);
            5'd12: y7 = (d12 + 8);
            5'd13: y7 = (d13 + 8);
            5'd14: y7 = (d14 + 8);
            5'd15: y7 = (d15 + 8);
            default: y7 = seed ^ 8;
        endcase
    end
    always @* begin
        case (idx8)
            5'd0: y8 = d0;
            5'd1: y8 = d1;
            5'd2: y8 = d2;
            5'd3: y8 = d3;
            5'd4: y8 = d4;
            5'd5: y8 = d5;
            5'd6: y8 = d6;
            5'd7: y8 = d7;
            5'd8: y8 = d8;
            5'd9: y8 = d9;
            5'd10: y8 = d10;
            5'd11: y8 = d11;
            5'd12: y8 = d12;
            5'd13: y8 = d13;
            5'd14: y8 = d14;
            5'd15: y8 = d15;
            default: y8 = seed ^ 9;
        endcase
    end
    always @* begin
        case (idx9)
            5'd0: y9 = (d0 ^ seed);
            5'd1: y9 = (d1 ^ seed);
            5'd2: y9 = (d2 ^ seed);
            5'd3: y9 = (d3 ^ seed);
            5'd4: y9 = (d4 ^ seed);
            5'd5: y9 = (d5 ^ seed);
            5'd6: y9 = (d6 ^ seed);
            5'd7: y9 = (d7 ^ seed);
            5'd8: y9 = (d8 ^ seed);
            5'd9: y9 = (d9 ^ seed);
            5'd10: y9 = (d10 ^ seed);
            5'd11: y9 = (d11 ^ seed);
            5'd12: y9 = (d12 ^ seed);
            5'd13: y9 = (d13 ^ seed);
            5'd14: y9 = (d14 ^ seed);
            5'd15: y9 = (d15 ^ seed);
            default: y9 = seed ^ 10;
        endcase
    end
    always @* begin
        case (idx10)
            5'd0: y10 = {(d0 << 2), d0 >> (30)};
            5'd1: y10 = {(d1 << 2), d1 >> (30)};
            5'd2: y10 = {(d2 << 2), d2 >> (30)};
            5'd3: y10 = {(d3 << 2), d3 >> (30)};
            5'd4: y10 = {(d4 << 2), d4 >> (30)};
            5'd5: y10 = {(d5 << 2), d5 >> (30)};
            5'd6: y10 = {(d6 << 2), d6 >> (30)};
            5'd7: y10 = {(d7 << 2), d7 >> (30)};
            5'd8: y10 = {(d8 << 2), d8 >> (30)};
            5'd9: y10 = {(d9 << 2), d9 >> (30)};
            5'd10: y10 = {(d10 << 2), d10 >> (30)};
            5'd11: y10 = {(d11 << 2), d11 >> (30)};
            5'd12: y10 = {(d12 << 2), d12 >> (30)};
            5'd13: y10 = {(d13 << 2), d13 >> (30)};
            5'd14: y10 = {(d14 << 2), d14 >> (30)};
            5'd15: y10 = {(d15 << 2), d15 >> (30)};
            default: y10 = seed ^ 11;
        endcase
    end
    always @* begin
        case (idx11)
            5'd0: y11 = (d0 + 12);
            5'd1: y11 = (d1 + 12);
            5'd2: y11 = (d2 + 12);
            5'd3: y11 = (d3 + 12);
            5'd4: y11 = (d4 + 12);
            5'd5: y11 = (d5 + 12);
            5'd6: y11 = (d6 + 12);
            5'd7: y11 = (d7 + 12);
            5'd8: y11 = (d8 + 12);
            5'd9: y11 = (d9 + 12);
            5'd10: y11 = (d10 + 12);
            5'd11: y11 = (d11 + 12);
            5'd12: y11 = (d12 + 12);
            5'd13: y11 = (d13 + 12);
            5'd14: y11 = (d14 + 12);
            5'd15: y11 = (d15 + 12);
            default: y11 = seed ^ 12;
        endcase
    end
    always @* begin
        case (idx12)
            5'd0: y12 = d0;
            5'd1: y12 = d1;
            5'd2: y12 = d2;
            5'd3: y12 = d3;
            5'd4: y12 = d4;
            5'd5: y12 = d5;
            5'd6: y12 = d6;
            5'd7: y12 = d7;
            5'd8: y12 = d8;
            5'd9: y12 = d9;
            5'd10: y12 = d10;
            5'd11: y12 = d11;
            5'd12: y12 = d12;
            5'd13: y12 = d13;
            5'd14: y12 = d14;
            5'd15: y12 = d15;
            default: y12 = seed ^ 13;
        endcase
    end
    always @* begin
        case (idx13)
            5'd0: y13 = (d0 ^ seed);
            5'd1: y13 = (d1 ^ seed);
            5'd2: y13 = (d2 ^ seed);
            5'd3: y13 = (d3 ^ seed);
            5'd4: y13 = (d4 ^ seed);
            5'd5: y13 = (d5 ^ seed);
            5'd6: y13 = (d6 ^ seed);
            5'd7: y13 = (d7 ^ seed);
            5'd8: y13 = (d8 ^ seed);
            5'd9: y13 = (d9 ^ seed);
            5'd10: y13 = (d10 ^ seed);
            5'd11: y13 = (d11 ^ seed);
            5'd12: y13 = (d12 ^ seed);
            5'd13: y13 = (d13 ^ seed);
            5'd14: y13 = (d14 ^ seed);
            5'd15: y13 = (d15 ^ seed);
            default: y13 = seed ^ 14;
        endcase
    end
    always @* begin
        case (idx14)
            5'd0: y14 = {(d0 << 3), d0 >> (29)};
            5'd1: y14 = {(d1 << 3), d1 >> (29)};
            5'd2: y14 = {(d2 << 3), d2 >> (29)};
            5'd3: y14 = {(d3 << 3), d3 >> (29)};
            5'd4: y14 = {(d4 << 3), d4 >> (29)};
            5'd5: y14 = {(d5 << 3), d5 >> (29)};
            5'd6: y14 = {(d6 << 3), d6 >> (29)};
            5'd7: y14 = {(d7 << 3), d7 >> (29)};
            5'd8: y14 = {(d8 << 3), d8 >> (29)};
            5'd9: y14 = {(d9 << 3), d9 >> (29)};
            5'd10: y14 = {(d10 << 3), d10 >> (29)};
            5'd11: y14 = {(d11 << 3), d11 >> (29)};
            5'd12: y14 = {(d12 << 3), d12 >> (29)};
            5'd13: y14 = {(d13 << 3), d13 >> (29)};
            5'd14: y14 = {(d14 << 3), d14 >> (29)};
            5'd15: y14 = {(d15 << 3), d15 >> (29)};
            default: y14 = seed ^ 15;
        endcase
    end
    always @* begin
        case (idx15)
            5'd0: y15 = (d0 + 16);
            5'd1: y15 = (d1 + 16);
            5'd2: y15 = (d2 + 16);
            5'd3: y15 = (d3 + 16);
            5'd4: y15 = (d4 + 16);
            5'd5: y15 = (d5 + 16);
            5'd6: y15 = (d6 + 16);
            5'd7: y15 = (d7 + 16);
            5'd8: y15 = (d8 + 16);
            5'd9: y15 = (d9 + 16);
            5'd10: y15 = (d10 + 16);
            5'd11: y15 = (d11 + 16);
            5'd12: y15 = (d12 + 16);
            5'd13: y15 = (d13 + 16);
            5'd14: y15 = (d14 + 16);
            5'd15: y15 = (d15 + 16);
            default: y15 = seed ^ 16;
        endcase
    end
    always @* begin
        case (idx16)
            5'd0: y16 = d0;
            5'd1: y16 = d1;
            5'd2: y16 = d2;
            5'd3: y16 = d3;
            5'd4: y16 = d4;
            5'd5: y16 = d5;
            5'd6: y16 = d6;
            5'd7: y16 = d7;
            5'd8: y16 = d8;
            5'd9: y16 = d9;
            5'd10: y16 = d10;
            5'd11: y16 = d11;
            5'd12: y16 = d12;
            5'd13: y16 = d13;
            5'd14: y16 = d14;
            5'd15: y16 = d15;
            default: y16 = seed ^ 17;
        endcase
    end
    always @* begin
        case (idx17)
            5'd0: y17 = (d0 ^ seed);
            5'd1: y17 = (d1 ^ seed);
            5'd2: y17 = (d2 ^ seed);
            5'd3: y17 = (d3 ^ seed);
            5'd4: y17 = (d4 ^ seed);
            5'd5: y17 = (d5 ^ seed);
            5'd6: y17 = (d6 ^ seed);
            5'd7: y17 = (d7 ^ seed);
            5'd8: y17 = (d8 ^ seed);
            5'd9: y17 = (d9 ^ seed);
            5'd10: y17 = (d10 ^ seed);
            5'd11: y17 = (d11 ^ seed);
            5'd12: y17 = (d12 ^ seed);
            5'd13: y17 = (d13 ^ seed);
            5'd14: y17 = (d14 ^ seed);
            5'd15: y17 = (d15 ^ seed);
            default: y17 = seed ^ 18;
        endcase
    end
    always @* begin
        case (idx18)
            5'd0: y18 = {(d0 << 1), d0 >> (31)};
            5'd1: y18 = {(d1 << 1), d1 >> (31)};
            5'd2: y18 = {(d2 << 1), d2 >> (31)};
            5'd3: y18 = {(d3 << 1), d3 >> (31)};
            5'd4: y18 = {(d4 << 1), d4 >> (31)};
            5'd5: y18 = {(d5 << 1), d5 >> (31)};
            5'd6: y18 = {(d6 << 1), d6 >> (31)};
            5'd7: y18 = {(d7 << 1), d7 >> (31)};
            5'd8: y18 = {(d8 << 1), d8 >> (31)};
            5'd9: y18 = {(d9 << 1), d9 >> (31)};
            5'd10: y18 = {(d10 << 1), d10 >> (31)};
            5'd11: y18 = {(d11 << 1), d11 >> (31)};
            5'd12: y18 = {(d12 << 1), d12 >> (31)};
            5'd13: y18 = {(d13 << 1), d13 >> (31)};
            5'd14: y18 = {(d14 << 1), d14 >> (31)};
            5'd15: y18 = {(d15 << 1), d15 >> (31)};
            default: y18 = seed ^ 19;
        endcase
    end
    always @* begin
        case (idx19)
            5'd0: y19 = (d0 + 20);
            5'd1: y19 = (d1 + 20);
            5'd2: y19 = (d2 + 20);
            5'd3: y19 = (d3 + 20);
            5'd4: y19 = (d4 + 20);
            5'd5: y19 = (d5 + 20);
            5'd6: y19 = (d6 + 20);
            5'd7: y19 = (d7 + 20);
            5'd8: y19 = (d8 + 20);
            5'd9: y19 = (d9 + 20);
            5'd10: y19 = (d10 + 20);
            5'd11: y19 = (d11 + 20);
            5'd12: y19 = (d12 + 20);
            5'd13: y19 = (d13 + 20);
            5'd14: y19 = (d14 + 20);
            5'd15: y19 = (d15 + 20);
            default: y19 = seed ^ 20;
        endcase
    end
    always @* begin
        case (idx20)
            5'd0: y20 = d0;
            5'd1: y20 = d1;
            5'd2: y20 = d2;
            5'd3: y20 = d3;
            5'd4: y20 = d4;
            5'd5: y20 = d5;
            5'd6: y20 = d6;
            5'd7: y20 = d7;
            5'd8: y20 = d8;
            5'd9: y20 = d9;
            5'd10: y20 = d10;
            5'd11: y20 = d11;
            5'd12: y20 = d12;
            5'd13: y20 = d13;
            5'd14: y20 = d14;
            5'd15: y20 = d15;
            default: y20 = seed ^ 21;
        endcase
    end
    always @* begin
        case (idx21)
            5'd0: y21 = (d0 ^ seed);
            5'd1: y21 = (d1 ^ seed);
            5'd2: y21 = (d2 ^ seed);
            5'd3: y21 = (d3 ^ seed);
            5'd4: y21 = (d4 ^ seed);
            5'd5: y21 = (d5 ^ seed);
            5'd6: y21 = (d6 ^ seed);
            5'd7: y21 = (d7 ^ seed);
            5'd8: y21 = (d8 ^ seed);
            5'd9: y21 = (d9 ^ seed);
            5'd10: y21 = (d10 ^ seed);
            5'd11: y21 = (d11 ^ seed);
            5'd12: y21 = (d12 ^ seed);
            5'd13: y21 = (d13 ^ seed);
            5'd14: y21 = (d14 ^ seed);
            5'd15: y21 = (d15 ^ seed);
            default: y21 = seed ^ 22;
        endcase
    end
    always @* begin
        case (idx22)
            5'd0: y22 = {(d0 << 2), d0 >> (30)};
            5'd1: y22 = {(d1 << 2), d1 >> (30)};
            5'd2: y22 = {(d2 << 2), d2 >> (30)};
            5'd3: y22 = {(d3 << 2), d3 >> (30)};
            5'd4: y22 = {(d4 << 2), d4 >> (30)};
            5'd5: y22 = {(d5 << 2), d5 >> (30)};
            5'd6: y22 = {(d6 << 2), d6 >> (30)};
            5'd7: y22 = {(d7 << 2), d7 >> (30)};
            5'd8: y22 = {(d8 << 2), d8 >> (30)};
            5'd9: y22 = {(d9 << 2), d9 >> (30)};
            5'd10: y22 = {(d10 << 2), d10 >> (30)};
            5'd11: y22 = {(d11 << 2), d11 >> (30)};
            5'd12: y22 = {(d12 << 2), d12 >> (30)};
            5'd13: y22 = {(d13 << 2), d13 >> (30)};
            5'd14: y22 = {(d14 << 2), d14 >> (30)};
            5'd15: y22 = {(d15 << 2), d15 >> (30)};
            default: y22 = seed ^ 23;
        endcase
    end
    always @* begin
        case (idx23)
            5'd0: y23 = (d0 + 24);
            5'd1: y23 = (d1 + 24);
            5'd2: y23 = (d2 + 24);
            5'd3: y23 = (d3 + 24);
            5'd4: y23 = (d4 + 24);
            5'd5: y23 = (d5 + 24);
            5'd6: y23 = (d6 + 24);
            5'd7: y23 = (d7 + 24);
            5'd8: y23 = (d8 + 24);
            5'd9: y23 = (d9 + 24);
            5'd10: y23 = (d10 + 24);
            5'd11: y23 = (d11 + 24);
            5'd12: y23 = (d12 + 24);
            5'd13: y23 = (d13 + 24);
            5'd14: y23 = (d14 + 24);
            5'd15: y23 = (d15 + 24);
            default: y23 = seed ^ 24;
        endcase
    end
    always @* begin
        case (idx24)
            5'd0: y24 = d0;
            5'd1: y24 = d1;
            5'd2: y24 = d2;
            5'd3: y24 = d3;
            5'd4: y24 = d4;
            5'd5: y24 = d5;
            5'd6: y24 = d6;
            5'd7: y24 = d7;
            5'd8: y24 = d8;
            5'd9: y24 = d9;
            5'd10: y24 = d10;
            5'd11: y24 = d11;
            5'd12: y24 = d12;
            5'd13: y24 = d13;
            5'd14: y24 = d14;
            5'd15: y24 = d15;
            default: y24 = seed ^ 25;
        endcase
    end
    always @* begin
        case (idx25)
            5'd0: y25 = (d0 ^ seed);
            5'd1: y25 = (d1 ^ seed);
            5'd2: y25 = (d2 ^ seed);
            5'd3: y25 = (d3 ^ seed);
            5'd4: y25 = (d4 ^ seed);
            5'd5: y25 = (d5 ^ seed);
            5'd6: y25 = (d6 ^ seed);
            5'd7: y25 = (d7 ^ seed);
            5'd8: y25 = (d8 ^ seed);
            5'd9: y25 = (d9 ^ seed);
            5'd10: y25 = (d10 ^ seed);
            5'd11: y25 = (d11 ^ seed);
            5'd12: y25 = (d12 ^ seed);
            5'd13: y25 = (d13 ^ seed);
            5'd14: y25 = (d14 ^ seed);
            5'd15: y25 = (d15 ^ seed);
            default: y25 = seed ^ 26;
        endcase
    end
    always @* begin
        case (idx26)
            5'd0: y26 = {(d0 << 3), d0 >> (29)};
            5'd1: y26 = {(d1 << 3), d1 >> (29)};
            5'd2: y26 = {(d2 << 3), d2 >> (29)};
            5'd3: y26 = {(d3 << 3), d3 >> (29)};
            5'd4: y26 = {(d4 << 3), d4 >> (29)};
            5'd5: y26 = {(d5 << 3), d5 >> (29)};
            5'd6: y26 = {(d6 << 3), d6 >> (29)};
            5'd7: y26 = {(d7 << 3), d7 >> (29)};
            5'd8: y26 = {(d8 << 3), d8 >> (29)};
            5'd9: y26 = {(d9 << 3), d9 >> (29)};
            5'd10: y26 = {(d10 << 3), d10 >> (29)};
            5'd11: y26 = {(d11 << 3), d11 >> (29)};
            5'd12: y26 = {(d12 << 3), d12 >> (29)};
            5'd13: y26 = {(d13 << 3), d13 >> (29)};
            5'd14: y26 = {(d14 << 3), d14 >> (29)};
            5'd15: y26 = {(d15 << 3), d15 >> (29)};
            default: y26 = seed ^ 27;
        endcase
    end
    always @* begin
        case (idx27)
            5'd0: y27 = (d0 + 28);
            5'd1: y27 = (d1 + 28);
            5'd2: y27 = (d2 + 28);
            5'd3: y27 = (d3 + 28);
            5'd4: y27 = (d4 + 28);
            5'd5: y27 = (d5 + 28);
            5'd6: y27 = (d6 + 28);
            5'd7: y27 = (d7 + 28);
            5'd8: y27 = (d8 + 28);
            5'd9: y27 = (d9 + 28);
            5'd10: y27 = (d10 + 28);
            5'd11: y27 = (d11 + 28);
            5'd12: y27 = (d12 + 28);
            5'd13: y27 = (d13 + 28);
            5'd14: y27 = (d14 + 28);
            5'd15: y27 = (d15 + 28);
            default: y27 = seed ^ 28;
        endcase
    end
    always @* begin
        case (idx28)
            5'd0: y28 = d0;
            5'd1: y28 = d1;
            5'd2: y28 = d2;
            5'd3: y28 = d3;
            5'd4: y28 = d4;
            5'd5: y28 = d5;
            5'd6: y28 = d6;
            5'd7: y28 = d7;
            5'd8: y28 = d8;
            5'd9: y28 = d9;
            5'd10: y28 = d10;
            5'd11: y28 = d11;
            5'd12: y28 = d12;
            5'd13: y28 = d13;
            5'd14: y28 = d14;
            5'd15: y28 = d15;
            default: y28 = seed ^ 29;
        endcase
    end
    always @* begin
        case (idx29)
            5'd0: y29 = (d0 ^ seed);
            5'd1: y29 = (d1 ^ seed);
            5'd2: y29 = (d2 ^ seed);
            5'd3: y29 = (d3 ^ seed);
            5'd4: y29 = (d4 ^ seed);
            5'd5: y29 = (d5 ^ seed);
            5'd6: y29 = (d6 ^ seed);
            5'd7: y29 = (d7 ^ seed);
            5'd8: y29 = (d8 ^ seed);
            5'd9: y29 = (d9 ^ seed);
            5'd10: y29 = (d10 ^ seed);
            5'd11: y29 = (d11 ^ seed);
            5'd12: y29 = (d12 ^ seed);
            5'd13: y29 = (d13 ^ seed);
            5'd14: y29 = (d14 ^ seed);
            5'd15: y29 = (d15 ^ seed);
            default: y29 = seed ^ 30;
        endcase
    end
    always @* begin
        case (idx30)
            5'd0: y30 = {(d0 << 1), d0 >> (31)};
            5'd1: y30 = {(d1 << 1), d1 >> (31)};
            5'd2: y30 = {(d2 << 1), d2 >> (31)};
            5'd3: y30 = {(d3 << 1), d3 >> (31)};
            5'd4: y30 = {(d4 << 1), d4 >> (31)};
            5'd5: y30 = {(d5 << 1), d5 >> (31)};
            5'd6: y30 = {(d6 << 1), d6 >> (31)};
            5'd7: y30 = {(d7 << 1), d7 >> (31)};
            5'd8: y30 = {(d8 << 1), d8 >> (31)};
            5'd9: y30 = {(d9 << 1), d9 >> (31)};
            5'd10: y30 = {(d10 << 1), d10 >> (31)};
            5'd11: y30 = {(d11 << 1), d11 >> (31)};
            5'd12: y30 = {(d12 << 1), d12 >> (31)};
            5'd13: y30 = {(d13 << 1), d13 >> (31)};
            5'd14: y30 = {(d14 << 1), d14 >> (31)};
            5'd15: y30 = {(d15 << 1), d15 >> (31)};
            default: y30 = seed ^ 31;
        endcase
    end
    always @* begin
        case (idx31)
            5'd0: y31 = (d0 + 32);
            5'd1: y31 = (d1 + 32);
            5'd2: y31 = (d2 + 32);
            5'd3: y31 = (d3 + 32);
            5'd4: y31 = (d4 + 32);
            5'd5: y31 = (d5 + 32);
            5'd6: y31 = (d6 + 32);
            5'd7: y31 = (d7 + 32);
            5'd8: y31 = (d8 + 32);
            5'd9: y31 = (d9 + 32);
            5'd10: y31 = (d10 + 32);
            5'd11: y31 = (d11 + 32);
            5'd12: y31 = (d12 + 32);
            5'd13: y31 = (d13 + 32);
            5'd14: y31 = (d14 + 32);
            5'd15: y31 = (d15 + 32);
            default: y31 = seed ^ 32;
        endcase
    end
    always @* begin
        case (idx32)
            5'd0: y32 = d0;
            5'd1: y32 = d1;
            5'd2: y32 = d2;
            5'd3: y32 = d3;
            5'd4: y32 = d4;
            5'd5: y32 = d5;
            5'd6: y32 = d6;
            5'd7: y32 = d7;
            5'd8: y32 = d8;
            5'd9: y32 = d9;
            5'd10: y32 = d10;
            5'd11: y32 = d11;
            5'd12: y32 = d12;
            5'd13: y32 = d13;
            5'd14: y32 = d14;
            5'd15: y32 = d15;
            default: y32 = seed ^ 33;
        endcase
    end
    always @* begin
        case (idx33)
            5'd0: y33 = (d0 ^ seed);
            5'd1: y33 = (d1 ^ seed);
            5'd2: y33 = (d2 ^ seed);
            5'd3: y33 = (d3 ^ seed);
            5'd4: y33 = (d4 ^ seed);
            5'd5: y33 = (d5 ^ seed);
            5'd6: y33 = (d6 ^ seed);
            5'd7: y33 = (d7 ^ seed);
            5'd8: y33 = (d8 ^ seed);
            5'd9: y33 = (d9 ^ seed);
            5'd10: y33 = (d10 ^ seed);
            5'd11: y33 = (d11 ^ seed);
            5'd12: y33 = (d12 ^ seed);
            5'd13: y33 = (d13 ^ seed);
            5'd14: y33 = (d14 ^ seed);
            5'd15: y33 = (d15 ^ seed);
            default: y33 = seed ^ 34;
        endcase
    end
    always @* begin
        case (idx34)
            5'd0: y34 = {(d0 << 2), d0 >> (30)};
            5'd1: y34 = {(d1 << 2), d1 >> (30)};
            5'd2: y34 = {(d2 << 2), d2 >> (30)};
            5'd3: y34 = {(d3 << 2), d3 >> (30)};
            5'd4: y34 = {(d4 << 2), d4 >> (30)};
            5'd5: y34 = {(d5 << 2), d5 >> (30)};
            5'd6: y34 = {(d6 << 2), d6 >> (30)};
            5'd7: y34 = {(d7 << 2), d7 >> (30)};
            5'd8: y34 = {(d8 << 2), d8 >> (30)};
            5'd9: y34 = {(d9 << 2), d9 >> (30)};
            5'd10: y34 = {(d10 << 2), d10 >> (30)};
            5'd11: y34 = {(d11 << 2), d11 >> (30)};
            5'd12: y34 = {(d12 << 2), d12 >> (30)};
            5'd13: y34 = {(d13 << 2), d13 >> (30)};
            5'd14: y34 = {(d14 << 2), d14 >> (30)};
            5'd15: y34 = {(d15 << 2), d15 >> (30)};
            default: y34 = seed ^ 35;
        endcase
    end
    always @* begin
        case (idx35)
            5'd0: y35 = (d0 + 36);
            5'd1: y35 = (d1 + 36);
            5'd2: y35 = (d2 + 36);
            5'd3: y35 = (d3 + 36);
            5'd4: y35 = (d4 + 36);
            5'd5: y35 = (d5 + 36);
            5'd6: y35 = (d6 + 36);
            5'd7: y35 = (d7 + 36);
            5'd8: y35 = (d8 + 36);
            5'd9: y35 = (d9 + 36);
            5'd10: y35 = (d10 + 36);
            5'd11: y35 = (d11 + 36);
            5'd12: y35 = (d12 + 36);
            5'd13: y35 = (d13 + 36);
            5'd14: y35 = (d14 + 36);
            5'd15: y35 = (d15 + 36);
            default: y35 = seed ^ 36;
        endcase
    end
    always @* begin
        case (idx36)
            5'd0: y36 = d0;
            5'd1: y36 = d1;
            5'd2: y36 = d2;
            5'd3: y36 = d3;
            5'd4: y36 = d4;
            5'd5: y36 = d5;
            5'd6: y36 = d6;
            5'd7: y36 = d7;
            5'd8: y36 = d8;
            5'd9: y36 = d9;
            5'd10: y36 = d10;
            5'd11: y36 = d11;
            5'd12: y36 = d12;
            5'd13: y36 = d13;
            5'd14: y36 = d14;
            5'd15: y36 = d15;
            default: y36 = seed ^ 37;
        endcase
    end
    always @* begin
        case (idx37)
            5'd0: y37 = (d0 ^ seed);
            5'd1: y37 = (d1 ^ seed);
            5'd2: y37 = (d2 ^ seed);
            5'd3: y37 = (d3 ^ seed);
            5'd4: y37 = (d4 ^ seed);
            5'd5: y37 = (d5 ^ seed);
            5'd6: y37 = (d6 ^ seed);
            5'd7: y37 = (d7 ^ seed);
            5'd8: y37 = (d8 ^ seed);
            5'd9: y37 = (d9 ^ seed);
            5'd10: y37 = (d10 ^ seed);
            5'd11: y37 = (d11 ^ seed);
            5'd12: y37 = (d12 ^ seed);
            5'd13: y37 = (d13 ^ seed);
            5'd14: y37 = (d14 ^ seed);
            5'd15: y37 = (d15 ^ seed);
            default: y37 = seed ^ 38;
        endcase
    end
    always @* begin
        case (idx38)
            5'd0: y38 = {(d0 << 3), d0 >> (29)};
            5'd1: y38 = {(d1 << 3), d1 >> (29)};
            5'd2: y38 = {(d2 << 3), d2 >> (29)};
            5'd3: y38 = {(d3 << 3), d3 >> (29)};
            5'd4: y38 = {(d4 << 3), d4 >> (29)};
            5'd5: y38 = {(d5 << 3), d5 >> (29)};
            5'd6: y38 = {(d6 << 3), d6 >> (29)};
            5'd7: y38 = {(d7 << 3), d7 >> (29)};
            5'd8: y38 = {(d8 << 3), d8 >> (29)};
            5'd9: y38 = {(d9 << 3), d9 >> (29)};
            5'd10: y38 = {(d10 << 3), d10 >> (29)};
            5'd11: y38 = {(d11 << 3), d11 >> (29)};
            5'd12: y38 = {(d12 << 3), d12 >> (29)};
            5'd13: y38 = {(d13 << 3), d13 >> (29)};
            5'd14: y38 = {(d14 << 3), d14 >> (29)};
            5'd15: y38 = {(d15 << 3), d15 >> (29)};
            default: y38 = seed ^ 39;
        endcase
    end
    always @* begin
        case (idx39)
            5'd0: y39 = (d0 + 40);
            5'd1: y39 = (d1 + 40);
            5'd2: y39 = (d2 + 40);
            5'd3: y39 = (d3 + 40);
            5'd4: y39 = (d4 + 40);
            5'd5: y39 = (d5 + 40);
            5'd6: y39 = (d6 + 40);
            5'd7: y39 = (d7 + 40);
            5'd8: y39 = (d8 + 40);
            5'd9: y39 = (d9 + 40);
            5'd10: y39 = (d10 + 40);
            5'd11: y39 = (d11 + 40);
            5'd12: y39 = (d12 + 40);
            5'd13: y39 = (d13 + 40);
            5'd14: y39 = (d14 + 40);
            5'd15: y39 = (d15 + 40);
            default: y39 = seed ^ 40;
        endcase
    end
    always @* begin
        case (idx40)
            5'd0: y40 = d0;
            5'd1: y40 = d1;
            5'd2: y40 = d2;
            5'd3: y40 = d3;
            5'd4: y40 = d4;
            5'd5: y40 = d5;
            5'd6: y40 = d6;
            5'd7: y40 = d7;
            5'd8: y40 = d8;
            5'd9: y40 = d9;
            5'd10: y40 = d10;
            5'd11: y40 = d11;
            5'd12: y40 = d12;
            5'd13: y40 = d13;
            5'd14: y40 = d14;
            5'd15: y40 = d15;
            default: y40 = seed ^ 41;
        endcase
    end
    always @* begin
        case (idx41)
            5'd0: y41 = (d0 ^ seed);
            5'd1: y41 = (d1 ^ seed);
            5'd2: y41 = (d2 ^ seed);
            5'd3: y41 = (d3 ^ seed);
            5'd4: y41 = (d4 ^ seed);
            5'd5: y41 = (d5 ^ seed);
            5'd6: y41 = (d6 ^ seed);
            5'd7: y41 = (d7 ^ seed);
            5'd8: y41 = (d8 ^ seed);
            5'd9: y41 = (d9 ^ seed);
            5'd10: y41 = (d10 ^ seed);
            5'd11: y41 = (d11 ^ seed);
            5'd12: y41 = (d12 ^ seed);
            5'd13: y41 = (d13 ^ seed);
            5'd14: y41 = (d14 ^ seed);
            5'd15: y41 = (d15 ^ seed);
            default: y41 = seed ^ 42;
        endcase
    end
    always @* begin
        case (idx42)
            5'd0: y42 = {(d0 << 1), d0 >> (31)};
            5'd1: y42 = {(d1 << 1), d1 >> (31)};
            5'd2: y42 = {(d2 << 1), d2 >> (31)};
            5'd3: y42 = {(d3 << 1), d3 >> (31)};
            5'd4: y42 = {(d4 << 1), d4 >> (31)};
            5'd5: y42 = {(d5 << 1), d5 >> (31)};
            5'd6: y42 = {(d6 << 1), d6 >> (31)};
            5'd7: y42 = {(d7 << 1), d7 >> (31)};
            5'd8: y42 = {(d8 << 1), d8 >> (31)};
            5'd9: y42 = {(d9 << 1), d9 >> (31)};
            5'd10: y42 = {(d10 << 1), d10 >> (31)};
            5'd11: y42 = {(d11 << 1), d11 >> (31)};
            5'd12: y42 = {(d12 << 1), d12 >> (31)};
            5'd13: y42 = {(d13 << 1), d13 >> (31)};
            5'd14: y42 = {(d14 << 1), d14 >> (31)};
            5'd15: y42 = {(d15 << 1), d15 >> (31)};
            default: y42 = seed ^ 43;
        endcase
    end
    always @* begin
        case (idx43)
            5'd0: y43 = (d0 + 44);
            5'd1: y43 = (d1 + 44);
            5'd2: y43 = (d2 + 44);
            5'd3: y43 = (d3 + 44);
            5'd4: y43 = (d4 + 44);
            5'd5: y43 = (d5 + 44);
            5'd6: y43 = (d6 + 44);
            5'd7: y43 = (d7 + 44);
            5'd8: y43 = (d8 + 44);
            5'd9: y43 = (d9 + 44);
            5'd10: y43 = (d10 + 44);
            5'd11: y43 = (d11 + 44);
            5'd12: y43 = (d12 + 44);
            5'd13: y43 = (d13 + 44);
            5'd14: y43 = (d14 + 44);
            5'd15: y43 = (d15 + 44);
            default: y43 = seed ^ 44;
        endcase
    end
endmodule
