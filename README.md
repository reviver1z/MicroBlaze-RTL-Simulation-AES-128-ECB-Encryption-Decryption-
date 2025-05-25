# MicroBlaze-RTL-Simulation-AES-128-ECB-Encryption-Decryption-
Based on my previous GitHub repository: 
https://github.com/reviver1z/MicroBlaze-RTL-Simulation

##I implemented TinyAES using AES ECB 128 mode.
-Optional explanation of the algorithm:
It takes as input a 16-byte plaintext and a 16-byte key and produces a 16-byte ciphertext.

##So now, during simulation in vivado when I press 'Run All', the following appear:

The original (plain) sum

The encrypted (ciphertext) sum

The decrypted (plaintext) sum.

##Specifically, for the TinyAES algorithm, I used the following GitHub repository:
https://github.com/kokke/tiny-AES-c

##SIMULATION OF A MICROBLAZE PROCESSOR ON AN FPGA USING VITIS 2023.2 AND ENCRYPTION/DECRYPTION OF DATA:
SDK Folder Contains helloworld.c *(VITIS : application program), aes.c *(INCLUDE IN SOURCES VITIS: application program), aes.h *(INCLUDE IN INCLUDES VITIS: application program).
VIVADO Folder Contains testbench.vhd *(VIVADO : testbench).
array_sum.pdf Contains instructions *(FOLLOW : along).
