module fifo (
    input logic clk,
    input logic rst_n,

    input logic [7:0]   data_in,
    input logic         write_en,

    output logic [7:0]  data_out,
    input  logic        read_en,
    output logic        read_valid
);

logic [7:0] wr_ptr;
logic [7:0] rd_ptr;

logic [7:0] mem [256:0];

logic write_en_sig;
logic read_en_sig;

always_ff @( posedge clk or negedge rst_n) begin : WR_PTR_LOGIC
    if (!rst_n) begin
        wr_ptr <= '0;
    end else begin
        if (write_en_sig) begin
            wr_ptr <= wr_ptr + 1'b1;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin : RD_PTR_LOGIC
    if (!rst_n) begin
        rd_ptr <= '0;
    end else begin
        if (read_en_sig) begin
            rd_ptr <= rd_ptr + 1'b1;
        end
    end
end

always_ff @( posedge clk or negedge rst_n ) begin : MEM_WR
    if (write_en_sig) begin
        mem[wr_ptr] <= data_in;
    end
end

always_ff @( posedge clk or negedge rst_n ) begin : MEM_RD
    if (read_en_sig) begin
        data_out    <= mem[rd_ptr];
        read_valid  <= '1;
    end else begin
        read_valid  <= '0;
    end
end

always_comb begin : WR_RD_SAME_TIME
    if (read_en && write_en) begin
        write_en_sig = 1;
        read_en_sig  = 0;
    end else begin
        write_en_sig = write_en;
        read_en_sig  = read_en;
    end
end

endmodule
