in this README I will describe the problems I have met during the project

## Encrypt

the top module for Encryption is Encrypt, which mainly consists of 3 parts: **the first part** *is to generate a full key for all rounds, and put them together in a ((128*(Nr + 1)) - 1 : 0) long data, **the second part** is to connect all rounds together incluing the first round and the final round, and **the last part** is to output the final cipher text. each part is controlled by a register, and form a **pipe line**

### KeyExpansion

The two conditional statements play a crucial role in the key expansion process:

```
i % Nk == 0
```

This condition is checked for every `Nk` (number of 32-bit words in the key) iterations. When this condition is true, it means that a new round key needs to be derived from the previous round key.

```
Nk > 6 && i % Nk == 4
```

This condition is checked when the key length is greater than 192 bits (Nk > 6) and the iteration count is a multiple of 4 (after every 128 bits). In this case, the code only needs to apply the S-box substitution to the current word (`w1`) without any rotation or round constant XOR.

all the RoundKeys are put into Fullkey , and assigned them to AddRoundKey modules in Encrypt part.

### aes_en_round

this module achieve the function of each one of the mid_rounds

#### SubBytes

function is used the achieve the substitution of words by S_box

#### ShiftRows

This module uses the most intuitive way to perform shifting operations. It is worth noting that since the data is arranged in descending order, it seems that a right shift is implemented in the code implementation. For example:

```
assign Data_shifted[8+:8] = Data_in[40+:8];
```

this code actually leftshift the first word of the second row by 8 bits.


#### mixcolumn_32bits
In this module, I first used function to implement the matrix operation operator:

```
    function [7:0] pmul_1;
        input [7:0] b;
        begin
            pmul_1 = b;
        end
    endfunction
  
    function [7:0] pmul_2;
        input [7:0] b;
        pmul_2 = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
    endfunction
  
    function [7:0] pmul_3;
        input [7:0] b;
        reg [7:0] two;
        begin
            two = pmul_2(b);
            pmul_3 = two ^ b;
        end
    endfunction
```

The input byte is shifted left by two positions, which effectively multiplies the polynomial by x^2. If the shifted value has its most significant bit set (indicating a degree of 8 or higher), the value 0x1B (which represents x^4 + x^3 + x + 1, the binary representation of x^4 + 1 in GF(2^8)) is XORed with the shifted value.

#### MixColumn
connect 4 mixcolumn_32bits' togther

#### AddRoundKey

Simply do an XOR operation to the input data, where the key is assigned by the KeyExpansion part.

## Decrypt

The primary difference between the Decrypt module and the Encrypt module lies in the order of operations and the manner in which the round keys are applied.

* The initial AddRoundKey operation uses the first round key (derived from the last round key of encryption).
* The intermediate rounds perform the inverse operations in the reverse order: AddRoundKey, InverseMixColumns, InverseShiftRows, and InverseSubBytes.
* The final round omits the InverseMixColumns operation.
* The round keys are applied in the reverse order (from the last round key to the first round key).

### KeyExpansion_D

This part is actually the same as it in Encrypt.

### aes_de_round

this module achieve the function of each one of the mid_rounds

#### InverseShiftRows

shift the words to the opposite direction to it in Encryption.

#### InverseSubBytes

function is used the achieve the substitution of words by inverse_S_box

#### AddRoundKey

Simply do an XOR operation to the input data, where the key is assigned by the KeyExpansion part.

#### invmixcolumn_32bits

The matrix operator in this part is different from it in the encryption algorithm. For specific implementation, please refer to the invmixColumns_32bit.v file.

#### InverseMixColumn
connect 4 invmixcolumn_32bits modules together

## results 
results are shown in Results.pdf


# Script Usage Guide
1.open cmd in in project file
2.use command <Xilinx Installation Path>\Vivado\<Version>\settings64.bat to build up the environment
3.use command .\build.bat to run the code


