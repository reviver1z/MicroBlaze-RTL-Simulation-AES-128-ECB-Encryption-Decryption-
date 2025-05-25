# MicroBlaze-RTL-Simulation-AES-128-ECB-Encryption-Decryption-
Based on my previous GitHub repository: 
https://github.com/reviver1z/MicroBlaze-RTL-Simulation

I implemented TinyAES using AES ECB 128 mode.
-Optional explanation of the algorithm:
It takes as input a 16-byte plaintext and a 16-byte key and produces a 16-byte ciphertext.

So now, during simulation in vivado when I press 'Run All', the following appear:

The original (plain) sum

The encrypted (ciphertext) sum

The decrypted (plaintext) sum.

Specifically, for the TinyAES algorithm, I used the following GitHub repository:
https://github.com/kokke/tiny-AES-c

SIMULATION OF A MICROBLAZE PROCESSOR ON AN FPGA USING VITIS 2023.2 AND ENCRYPTION/DECRYPTION OF DATA:

SDK Folder Contains helloworld.c *(VITIS : application program), aes.c *(INCLUDE IN SOURCES VITIS: application program), aes.h *(INCLUDE IN INCLUDES VITIS: application program).

VIVADO Folder Contains testbench.vhd *(VIVADO : testbench).

array_sum.pdf Contains instructions *(FOLLOW : along).

**Note:** The multiline comments made in `helloworld.c` and `testbench.vhd` refer to the parts of the code that will be used in my next repository for bit-flip injection in the MicroBlaze RTL Simulation system. The goal is to demonstrate how a fault can alter the result of the sum of an array of 9 float values (1.0+2.0+3.0+4.0+5.0+6.0+7.0+8.0+9.0=45.0)
