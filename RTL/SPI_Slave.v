module SPI_Slave (                  
   input  wire         clk,        
   input  wire         rst_n,      
   input  wire         MOSI,       
   input  wire         ss_n,       
   input  wire [7:0]   tx_data,    
   input  wire         tx_valid,   
   output reg          MISO,       
   output reg  [9:0]   rx_data,    
   output reg          rx_valid    
);

    localparam IDLE        = 3'd0;   
    localparam CHK_CMD     = 3'd1;   
    localparam WRITE       = 3'd2;   
    localparam READ_ADD    = 3'd3;   
    localparam READ_DATA   = 3'd4;

    (* fsm_encoding = "one_hot" *)
    reg [2:0] cs, ns;               
    reg HasAddr;

    reg[3:0] receiving_counter;
    reg[9:0] receiving_shift_reg;
    wire     receiving_complete = ((cs == WRITE || cs == READ_ADD) && (receiving_counter == 4'd9));

    reg[3:0] transfering_counter; 
    reg[7:0] transfering_shift_reg;
    wire     transfering_complete = (cs == READ_DATA && transfering_counter == 4'd8);  

    always @(posedge clk) begin
        if (~rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end

    always @(*) begin
        if (ss_n) begin
            ns = IDLE;
        end else begin
            case (cs)
                IDLE:     ns = CHK_CMD;
                CHK_CMD:  ns = ~MOSI ? WRITE : (HasAddr ? READ_DATA : READ_ADD);
                WRITE:    ns = receiving_complete   ? CHK_CMD : WRITE;
                READ_ADD: ns = receiving_complete   ? CHK_CMD : READ_ADD;
                READ_DATA:ns = transfering_complete ? CHK_CMD : READ_DATA;
                default:  ns = IDLE;
            endcase
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            receiving_counter   <= 4'd0;
            receiving_shift_reg <= 10'd0;
            rx_data             <= 10'd0;
            rx_valid            <= 1'b0;
            HasAddr             <= 1'b0;
        end else begin
            rx_valid <= 1'b0;

            if (cs == WRITE || cs == READ_ADD) begin
                if (receiving_counter == 4'd9) begin
                    rx_data  <= {receiving_shift_reg[8:0], MOSI};
                    rx_valid <= 1'b1;
                    receiving_counter   <= 4'd0;
                    receiving_shift_reg <= 10'd0;
                    if (cs == READ_ADD)
                        HasAddr <= 1'b1;
                end else begin
                    receiving_shift_reg <= {receiving_shift_reg[8:0], MOSI};
                    receiving_counter   <= receiving_counter + 1'b1;
                end
            end else begin
                receiving_counter   <= 4'd0;
                receiving_shift_reg <= 10'd0;
            end

            if ((cs == CHK_CMD) && (MOSI == 1'b1) && HasAddr) begin
                rx_valid <= 1'b1;
                rx_data  <= {2'b11, 8'd0};
            end

            if ((cs == READ_DATA) && transfering_complete)
                HasAddr <= 1'b0;
        end
    end

    always @(negedge clk) begin
        if (~rst_n) begin
            MISO <= 1'b1;
            transfering_counter <= 4'd0;
        end else begin
            if (cs != READ_DATA) begin
                transfering_counter  <= 4'd0;
                MISO <= 1'b1;   
            end else if (cs == READ_DATA && tx_valid) begin
                if (transfering_counter == 0) begin
                    {MISO, transfering_shift_reg} <= {tx_data, 1'b0};
                    transfering_counter <= transfering_counter + 1'b1;
                end else if (transfering_counter < 8) begin
                    {MISO, transfering_shift_reg} <= {transfering_shift_reg, 1'b0};
                    transfering_counter <= transfering_counter + 1'b1;
                end
            end
        end
    end

endmodule