#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"
#include "aes.h"
//aes.h : AES==Advanced Encryption Standard .//Includes  TinyAES header for AES: (encryption) and (decryption).

int main()
{
    //initialize platform
    init_platform();
    // Buffer to hold the formatted float as a string (My Case:"45.000000"):
    char buff[11];
    //static float array:
    static float arr[9] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0};

    //128-bit encryption key (16 bytes) used for AES-128 ECB mode encryption/decryption:
    uint8_t key[16] = {0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x7f,0x67,0x98,0x3c,0xc0,0x8c};
    //16-byte buffer for AES input/output (1 block of plaintext or ciphertext):
    uint8_t data[16] = {0};

    //Union to convert between float and 32-bit unsigned int (bitwise representation):
    union {
        unsigned int a;
        float b;
    } itof;
    //float variable to store the: SUM OF THE ARRAY.
    float sum = 0.0; 

    //Storing the float values of the array to BRAM as 32-bit and calculating their sum
    for (int i = 0; i < 9; i++) {
        itof.b = arr[i];
        Xil_Out32(XPAR_AXI_BRAM_0_BASEADDRESS + (4 * i), itof.a);
        sum += arr[i];
    }
    //Convert float SUM to 32-bit FORMAT:
    itof.b = sum; 

    //Write The SUM To BRAM:
    Xil_Out32(XPAR_AXI_BRAM_0_BASEADDRESS + (4 * 9), itof.a);

    //Prints SUM:
    //Convert FLOAT of ITOF.B TO a STRING and store it in BUFF:
    sprintf(buff, "%f", itof.b);
    //Print the FORMATTED STRING stored in BUFF to the UART:
    xil_printf("Sum= %s\n\r", buff);

    //AES ENCRYPTION of the SUM:
    struct AES_ctx ctx; //AES context STRUCTURE
    AES_init_ctx(&ctx,key); //Initialize AES context with 128-bit key
    memcpy(data,&itof.b,sizeof(itof.b));//Copy the float SUM into the DATA BUFFER.
    AES_ECB_encrypt(&ctx,data);//ENCRYPT the 16-Byte DATA BUFFER using AES-128 ECB(Electronic Code Book)
    //Print the 16-Byte AES-ENCRYPTED CIPHERTEXT to UART IN HEXADECIMAL:
    xil_printf("Encrypted= ");
    for(int i=0; i<16; i++) { 
    xil_printf("%02x", data[i]);
    if (i < 15) xil_printf("-");//Each Byte Separated by a dash for readability.
     } 
     xil_printf("\n\r");

     //AES DECRYPTION of the SUM:
    AES_ECB_decrypt(&ctx,data); //DECRYPT the 16-Byte AES BUFFER using AES-128 ECB(Electronic Code Book).
    memcpy(&itof.b,data,sizeof(itof.b));//Load Decrypted Float Value From BUFFER Into UNION.
    //Convert FLOAT of ITOF.B TO a STRING and store it in BUFF:
    sprintf(buff,"%f",itof.b);
    //Print the FORMATTED STRING stored in BUFF to the UART:
    xil_printf("Decrypted= %s\n\r", buff);

    cleanup_platform();
    return 0;
}



/*mrRANGER SDK:
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

int main()
{
    init_platform();

    static float arr[9] = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0};
    union {
        unsigned int a;
        float b;
    } itof;
    float sum = 0.0;
    int i;

    // Writing array values to BRAM:
    for(i = 0; i < 9; i++){
         itof.b = arr[i];
         Xil_Out32(XPAR_AXI_BRAM_0_BASEADDRESS + (4 * i), itof.a);// Writing to BRAM.
         sum += arr[i];
    }
    
    itof.b = sum;//Saving : Result : In : UNION
    Xil_Out32(XPAR_AXI_BRAM_0_BASEADDRESS + (4 * 9), itof.a); //Write The sum to BRAM.

    cleanup_platform();
    return 0;
}*/