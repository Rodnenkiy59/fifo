`timescale 10ps/1ps

module fifo_tb ();

    logic clk;
    logic rst_n;

    logic [7:0] data_in;
    logic       write_en;

    logic [7:0] data_out;
    logic       read_en;

    always begin
        #10 clk = !clk;
    end

    initial begin
        clk = 0;
        rst_n = 0;
        data_in = '0;
        write_en = '0;
        read_en = 0;

        #100 rst_n = 1;

        #1000;
        data_gen(data_in, write_en, clk, 5);
        #100;
        data_read(10);
        #100;
        $stop;
    end

    fifo DUT(
        .clk        (clk),
        .rst_n      (rst_n),

        .data_in    (data_in),
        .write_en   (write_en),

        .data_out   (data_out),
        .read_en    (read_en),

        .read_valid (),
        .empty      (),
        .full       ()
    );

    task automatic data_gen(ref logic [7:0] data_in, ref logic write_en, ref logic clk, input int size);
    begin
        int i;
        for (i=0;i<size;i=i+1) begin
            @(posedge clk);
            data_in = i;
            write_en = 1;
        end
        data_in = 0;
        write_en = 0;
    end
    endtask

    task data_read(input int size);
        int i;
        begin
            for (i=0;i<size;i=i+1) begin
                @(posedge clk);
                read_en = 1;
            end
            read_en = 0;
        end
    endtask

endmodule
