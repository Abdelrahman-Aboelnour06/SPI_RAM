module tb_SPI_Wrapper ();
    reg  clk;
    reg  rst_n;
    reg  MOSI;
    reg  SS_n;
    wire MISO;

    SPI_Wrapper DUT (
        .MOSI  (MOSI),
        .SS_n  (SS_n),
        .clk   (clk),
        .rst_n (rst_n),
        .MISO  (MISO)
    );

    wire [2:0] debug_state = DUT.SPI.cs;


    initial begin 
    clk = 1'b0;
     forever #5 clk = ~clk;    
     end


    

    initial begin

            rst_n = 1'b0;
            SS_n  = 1'b1;
            MOSI  = 1'b0;
            repeat (3) @(negedge clk);
            rst_n = 1'b1;
            repeat (2) @(negedge clk);    



            @(negedge clk); SS_n = 0;
            // write addr 0x00
            @(negedge clk); MOSI = 0;

            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;

            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;

            @(negedge clk); SS_n = 1;



            @(negedge clk); SS_n = 0;
            // write data 0xAA
            @(negedge clk); MOSI = 0;

            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 1;

            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 0;

            @(negedge clk); SS_n = 1;



            @(negedge clk); SS_n = 0;
            // read_add addr 0x00
            @(negedge clk); MOSI = 1;

            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 0;

            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;

            @(negedge clk); SS_n = 1;

            @(negedge clk); SS_n = 0;
            // read_data from addr 0x00
            @(negedge clk); MOSI = 1;

            @(negedge clk); MOSI = 1;
            @(negedge clk); MOSI = 1;

            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;
            @(negedge clk); MOSI = 0;

            @(negedge clk); SS_n = 0;

            repeat (15) @(negedge clk);

            SS_n=1;

        $stop;


    end

endmodule