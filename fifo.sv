module fifo (
    input logic clk,
    input logic rst_n,

    input logic [7:0] data_in,
    input logic write_en,

    output logic [7:0] data_out,
    input logic read_en
);
    
    logic [7:0] mem [256:0];
    logic [9:0] wr_ptr;
    logic [9:0] rd_ptr;

    always_ff @( posedge clk or negedge rst_n ) begin : WR_PTR_LOGIC
        if (!rst_n) begin
            wr_ptr <= 0;
        end else begin
            if (write_en) begin
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    always_ff @( posedge clk or negedge rst_n ) begin : RD_PTR_LOGIC
        if (!rst_n) begin
            rd_ptr <= 0;
        end else begin
            if (read_en) begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

    always_ff @( posedge clk or negedge rst_n ) begin : WRITE_DATA
        if (write_en) begin
            mem[wr_ptr] <= data_in;
        end
    end

    always_ff @( posedge clk or negedge rst_n ) begin : READ_DATA
        if (read_en) begin
            data_out <= mem[rd_ptr];
        end
    end

endmodule