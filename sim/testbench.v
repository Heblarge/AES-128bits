`timescale 1ns/1ps

module testbench();

parameter N = 128;
parameter T = 10;
parameter N_tests = 10;

reg clk;
reg encryptor_rst, decryptor_rst;
reg [N-1:0] key = 0;
reg [127:0] plain_text_in, cipher_text_in;
wire [127:0] plain_text_out, cipher_text_out;

reg [N-1:0] keys [9:0];
reg [127:0] plain_texts [N_tests-1:0];
reg [127:0] cipher_tests [N_tests-1:0];

Encrypt #(
    .N(128),
    .Nr(10),
    .Nk(4)
) Encrypt_uut (
    .clk(clk),
    .rst(encryptor_rst),
    .key_in(key),
    .in_1(plain_text_in),
    .out(cipher_text_out)
);

Decrypt #(
    .N(128),
    .Nr(10),
    .Nk(4)
) Decrypt_uut (
    .clk(clk),
    .rst(decryptor_rst),
    .key_in(key),
    .in_1(cipher_text_in),
    .out(plain_text_out)
);

always #(T/2) clk <= ~clk;

integer i;
initial begin
    clk <= 0;
    $readmemh("D:/Xilinx_Unified_2020.2_1118_1232/project_5/sim/key.txt", keys);
    $readmemh("D:/Xilinx_Unified_2020.2_1118_1232/project_5/sim/plain_text.txt", plain_texts);
    $readmemh("D:/Xilinx_Unified_2020.2_1118_1232/project_5/sim/cipher_text.txt", cipher_tests);
    for (i = 0; i < N_tests; i = i + 1) begin
        encryptor_rst <= 1;
        decryptor_rst <= 1;
        #20;
        key <= keys[i];
        plain_text_in <= plain_texts[i];
        cipher_text_in <= cipher_tests[i];
        encryptor_rst <= 0;
        decryptor_rst <= 0;
        #50;
        if (cipher_text_out == cipher_tests[i]) begin
            $display("encryptor PASS, plain_text_in: %032h, key: %032h, cipher_text_out: %032h", plain_text_in, key, cipher_text_out);
        end
        else begin
            $display("encryptor FAIL, plain_text_in: %032h, key: %032h, cipher_text_out: %032h", plain_text_in, key, cipher_text_out);
        end
        
        if (plain_text_out == plain_texts[i]) begin
            $display("decryptor PASS, cipher_text_in: %032h, key: %032h, plain_text_out: %032h", cipher_text_in, key, plain_text_out);
        end
        else begin
            $display("decryptor FAIL, cipher_text_in: %032h, key: %032h, plain_text_out: %032h", cipher_text_in, key, plain_text_out);
        end
    end
    #20;
end

endmodule