module median_top #(
    parameter W = 430,
    parameter H = 554
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,
    output wire [7:0]  pixel_out,
    output reg         vld
);

    reg [7:0] line_buf1 [0:W-1];
    reg [7:0] line_buf2 [0:W-1]; 
    
    reg [7:0] p [0:8];
    reg [7:0] pixel_out_reg; 
    
    reg [9:0]  x_in, y_in;       
    reg [9:0]  x_out, y_out;
    reg [19:0] global_cnt;   

    localparam [19:0] LATENCY    = W[19:0] + 20'd2; 
    localparam [19:0] FRAME_SIZE = W[19:0] * H[19:0];
    localparam [19:0] TOTAL_CYCLES = FRAME_SIZE + LATENCY;

    wire [7:0] med_val;
    wire is_border = (x_out == 0 || x_out == W[9:0]-10'd1 || y_out == 0 || y_out == H[9:0]-10'd1);

    // Buffer + sliding Window 3x3
    always @(posedge clk) begin
        if (rst) begin
            x_in <= 10'd0; 
            y_in <= 10'd0;
            p[0] <= 8'd0; p[1] <= 8'd0; p[2] <= 8'd0;
            p[3] <= 8'd0; p[4] <= 8'd0; p[5] <= 8'd0;
            p[6] <= 8'd0; p[7] <= 8'd0; p[8] <= 8'd0;
        end else begin
            // update coor
            if (x_in == W[9:0] - 10'd1) begin
                x_in <= 10'd0;
                if (y_in == H[9:0] - 10'd1) y_in <= 10'd0; 
                else y_in <= y_in + 10'd1;
            end else x_in <= x_in + 10'd1;

            // update line buff RAM
            line_buf1[x_in] <= pixel_in;
            line_buf2[x_in] <= line_buf1[x_in];

            // slide window
            // col 1
            p[6] <= pixel_in;        p[7] <= p[6]; p[8] <= p[7];
            // col 2
            p[3] <= line_buf1[x_in]; p[4] <= p[3]; p[5] <= p[4];
            // oldest 
            p[0] <= line_buf2[x_in]; p[1] <= p[0]; p[2] <= p[1];
        end
    end

    // sort
    median sort_inst (
        .p0(p[0]), .p1(p[1]), .p2(p[2]),
        .p3(p[3]), .p4(p[4]), .p5(p[5]),
        .p6(p[6]), .p7(p[7]), .p8(p[8]),
        .median(med_val)
    );

    // output handler
    always @(posedge clk) begin
        if (rst) begin
            global_cnt <= 20'd0;
            vld <= 1'b0;
            x_out <= 10'd0; 
            y_out <= 10'd0;
            pixel_out_reg <= 8'd0;
        end else begin
            if (global_cnt < TOTAL_CYCLES) 
                global_cnt <= global_cnt + 20'd1;

            if (global_cnt >= LATENCY && global_cnt < TOTAL_CYCLES) begin
                vld <= 1'b1;
                if (is_border)
                    pixel_out_reg <= p[4]; // boder case
                else
                    pixel_out_reg <= med_val;

                if (x_out == W[9:0] - 10'd1) begin
                    x_out <= 10'd0;
                    if (y_out == H[9:0] - 10'd1) y_out <= 10'd0;
                    else y_out <= y_out + 10'd1;
                end else x_out <= x_out + 10'd1;
            end else begin
                vld <= 1'b0;
            end
        end
    end

    assign pixel_out = pixel_out_reg;

endmodule