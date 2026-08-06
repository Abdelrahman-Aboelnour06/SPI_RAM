
module SPR_Ram #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
) (
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [9:0]           din,        
    input  wire                 rx_valid,   
    output reg  [7:0]           dout,       
    output reg                  tx_valid    
);

    reg [7:0] mem [0:MEM_DEPTH-1];

    reg [ADDR_SIZE-1:0] wr_addr;
    reg [ADDR_SIZE-1:0] rd_addr;


  
    always @(*) begin
        dout = mem[rd_addr];
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            wr_addr   <= {ADDR_SIZE{1'b0}};
            rd_addr   <= {ADDR_SIZE{1'b0}};
            tx_valid  <= 1'b0;
        end else begin
            if (rx_valid) begin
                case (din[9:8])
                    2'b00: begin  
                        wr_addr <= din[7:0];
                        tx_valid <= 1'b0;  
                    end
                    2'b01: begin  
                        mem[wr_addr] <= din[7:0];
                        tx_valid <= 1'b0;
                    end
                    2'b10: begin  
                        rd_addr <= din[7:0];
                        tx_valid <= 1'b0;
                    end
                    2'b11: begin  
                        tx_valid <= 1'b1;
                    end
                    default: begin
                        tx_valid <= 1'b0;
                    end
                endcase
            end else begin
            end
        end
    end

endmodule