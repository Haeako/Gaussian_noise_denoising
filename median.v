// Support module
module sort3(
    input  [7:0] a, b, c,
    output [7:0] min, mid, max
);
    wire [7:0] low1, high1, low2, high2, low3, high3;
    assign {low1, high1} = (a < b) ? {a, b} : {b, a};
    assign {low2, high2} = (low1 < c) ? {low1, c} : {c, low1};
    assign {low3, high3} = (high1 < high2) ? {high1, high2} : {high2, high1};
    assign min = low2;
    assign mid = low3;
    assign max = high3;
endmodule

module median(
    input [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8,
    output [7:0] median
);
    wire [7:0] r1_min, r1_mid, r1_max;
    wire [7:0] r2_min, r2_mid, r2_max; 
    wire [7:0] r3_min, r3_mid, r3_max;
    wire [7:0] max_of_mins, mid_of_mids, min_of_maxs;
    wire [7:0] d1, d2, d3, d4, d5, d6, d7, d8;

    // collum sort
    sort3 s1 (.a(p0), .b(p1), .c(p2), .min(r1_min), .mid(r1_mid), .max(r1_max));
    sort3 s2 (.a(p3), .b(p4), .c(p5), .min(r2_min), .mid(r2_mid), .max(r2_max));
    sort3 s3 (.a(p6), .b(p7), .c(p8), .min(r3_min), .mid(r3_mid), .max(r3_max));

    // row sort
    sort3 s_min (.a(r1_min), .b(r2_min), .c(r3_min), .min(d1), .mid(d2), .max(max_of_mins));
    sort3 s_mid (.a(r1_mid), .b(r2_mid), .c(r3_mid), .min(d3), .mid(mid_of_mids), .max(d4));
    sort3 s_max (.a(r1_max), .b(r2_max), .c(r3_max), .min(min_of_maxs), .mid(d5), .max(d6));

    // final sort
    sort3 s_final (.a(max_of_mins), .b(mid_of_mids), .c(min_of_maxs), .min(d7), .mid(median), .max(d8));

endmodule