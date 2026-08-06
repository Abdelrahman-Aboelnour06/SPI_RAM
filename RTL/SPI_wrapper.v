module SPI_Wrapper #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)  (
    input wire MOSI ,
    input wire SS_n,
    input wire clk,
    input wire rst_n,
    output wire MISO
);

    wire [9:0]rx_data;
    wire rx_valid;
    wire [7:0]tx_data;
    wire tx_valid;



SPI_Slave SPI(
   .clk(clk),   
   .rst_n(rst_n),
   .MOSI(MOSI),
   .ss_n(SS_n),
   .tx_data(tx_data),
   .tx_valid(tx_valid),
   .MISO(MISO),
   .rx_data(rx_data),
   .rx_valid(rx_valid)
);


SPR_Ram #(
    .MEM_DEPTH(MEM_DEPTH),
    .ADDR_SIZE(ADDR_SIZE)
) SPR(
    .clk(clk),
    .rst_n(rst_n),
    .din(rx_data),
    .rx_valid(rx_valid),
    .dout(tx_data),
    .tx_valid(tx_valid)
);




    
endmodule