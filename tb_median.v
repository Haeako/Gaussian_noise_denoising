`timescale 1ns/1ps

module tb_median;
    parameter W=430, H=554;
    reg clk, rst;
    reg [7:0] pixel_in;
    wire [7:0] pixel_out;
    wire vld;
    
    integer fin, fout, r;
    integer out_count = 0;

    median_top #(.W(W), .H(H)) dut (
        .clk(clk), .rst(rst),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out),
        .vld(vld)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        fin = $fopen("pic_input.txt", "r");
        fout = $fopen("pic_output.txt", "w");
        if (fin == 0) begin
            $display("img not found");
            $finish;
        end
        rst = 1; pixel_in = 0;
        #25 rst = 0;
			// streaming input from txt file 
        while (!$feof(fin)) begin
            r = $fscanf(fin, "%d\n", pixel_in);
				// hold
            @(posedge clk);
        end
        // Reset pixel_in
        pixel_in = 0;
		  $fclose(fin); // close input file
		  // let module process image
        while (out_count < W*H) begin
            @(posedge clk);
        end // done
        $fclose(fout); // close output file
        $finish;
    end
    // Output stream
    always @(negedge clk) begin
        if (vld && !rst) begin
            $fwrite(fout, "%d\n", pixel_out);
            out_count = out_count + 1;
            
            // stop case
            if (out_count == W*H) begin
                $display("Done");
            end
        end
    end

endmodule