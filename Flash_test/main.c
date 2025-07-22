#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "mss_uart.h"
#include "mss_sys_services.h"
#include "mss_spi.h"
#include "winbondflash.h"
#include <stdbool.h>
#include "CMSIS/system_m2sxxx.h"
#define BUFFER_SIZE 2048


#define WRITE_CMD   0xAA
#define READ_CMD    0xBB

// mss_uart_instance_t * const gp_my_uart = &g_mss_uart1; //PC
mss_uart_instance_t * const gp_my_uart = &g_mss_uart0; //STM32



//void flush_uart_fifo(mss_uart_instance_t *uart)
//{
//    /* Enquanto o LSR indicar que há dado disponível, leia e descarte */
//    while ( uart->hw_reg->LSR & 0x01 ) {
//        volatile uint8_t dummy = uart->hw_reg->RBR;
//        (void)dummy;
//    }
//}

size_t UART_Polled_Rx(mss_uart_instance_t *this_uart,
                     uint8_t *rx_buff,
                     size_t  buff_size)
{
    size_t rx_size = 0U;

    /* 1) limpa todo o FIFO antes de cada quadro */
    while ( this_uart->hw_reg->LSR & 0x01 ) {
        volatile uint8_t d = this_uart->hw_reg->RBR;
        (void)d;
    }

    /* 2) agora leia exatamente buff_size bytes */
    while ( rx_size < buff_size ) {
        /* espera até ter pelo menos um byte */
        while ( (this_uart->hw_reg->LSR & 0x01) == 0U ) { }
        rx_buff[rx_size++] = this_uart->hw_reg->RBR;
    }

    return rx_size;
}


size_t UART_Polled_Rx_Sync(mss_uart_instance_t *uart,
                           uint8_t *rx_buff,
                           size_t   buff_size)
{
    size_t i;
    uint8_t b;

    while ( uart->hw_reg->LSR & 0x01 ) {
        (void)uart->hw_reg->RBR;
    }

    /* 2) procure o HEADER */
    do {
        while ( (uart->hw_reg->LSR & 0x01) == 0U ) { }
        b = uart->hw_reg->RBR;
    } while ( b != WRITE_CMD && b != READ_CMD);

    rx_buff[0] = b;

    /* 3) leia o restante do pacote */
    for ( i = 1; i < buff_size; ++i ) {
        while ( (uart->hw_reg->LSR & 0x01) == 0U ) { }
        rx_buff[i] = uart->hw_reg->RBR;
    }

    return buff_size;
}



//size_t
//UART_Polled_Rx
//(
//    mss_uart_instance_t * this_uart,
//    uint8_t * rx_buff,
//    size_t buff_size
//)
//{
//    size_t rx_size = 0U;
//
//
//    while( rx_size < buff_size )
//    {
//       while ( ((this_uart->hw_reg->LSR) & 0x1) != 0U  )
//       {
//           rx_buff[rx_size] = this_uart->hw_reg->RBR;
//           ++rx_size;
//       }
//    }
//
//    return rx_size;
//}


/*
 * **************************
 *  Function Name: calculate_crc16
 *  @brief     : Calcula o checksum CRC16 para um array de bytes.
 *  @param     : data   - Ponteiro para o array de bytes para o qual o CRC16 sera
 *                        calculado.
 *  @param     : length - Numero de bytes no array.
 *  @retval    : Valor CRC16 como inteiro de 16 bits sem sinal.
 * **************************
 */

uint16_t calculate_crc16(const uint8_t *data, size_t length)
{
    uint16_t crc = 0xFFFF;  // Valor inicial do CRC
    uint16_t poly = 0xA001; // Polinômio gerador (CRC-16)

    for (size_t i = 0; i < length; i++) {
        crc ^= data[i]; // XOR com o próximo byte de dados

        for (uint8_t bit = 0; bit < 8; bit++) {
            if (crc & 0x0001) {
                crc = (crc >> 1) ^ poly; // Desloca e XOR com o polinômio
            } else {
                crc >>= 1; // Apenas desloca
            }
        }
    }

    return crc; // Retorna o CRC calculado
}
int main()
{

    uint8_t cmd[7];
    uint8_t op;
    uint16_t block;
    uint16_t word;
    uint16_t crc;
    uint32_t errors;
    uint16_t pagina = 0;

    uint8_t rx_buff[BUFFER_SIZE+1]; //tamanho de uma página
    uint16_t crc_local;
    uint8_t cmd_resp[9];

    MSS_SYS_init(MSS_SYS_NO_EVENT_HANDLER);
    FLASH_init();
    FLASH_reset();
    FLASH_global_unprotect();
    //FLASH_chip_erase();

    MSS_UART_init( gp_my_uart,
                MSS_UART_57600_BAUD,
                      MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

/*
    cmd[0] = 0xbb;
    cmd[1] = 0;
    cmd[2] = 0b1000000;
    cmd[3] = 0xaa;
    cmd[4] = 0xaa;

    memset(rx_buff, 0, sizeof(rx_buff));
    FLASH_program((uint32_t)0, (uint8_t *)rx_buff, sizeof(rx_buff));

*/

    crc_local = calculate_crc16((uint8_t *)cmd,5);
    while(1)
    {
        UART_Polled_Rx_Sync(gp_my_uart, cmd, 7);
        //MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"k", 1 );
        op = (uint8_t)cmd[0];
        block = (uint8_t)cmd[1]<<8|(uint8_t)cmd[2];
        word = (uint8_t)cmd[3]<<8|(uint8_t)cmd[4];
        crc = (uint8_t)cmd[5]<<8|(uint8_t)cmd[6];

        crc_local = calculate_crc16((uint8_t *)cmd,5);
        //MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"k", 1 );


        if(op == 0xaa) //comando escrita na flash
        {
            FLASH_reset();
            FLASH_erase_128k_block((uint32_t)(block<<16)); //apaga o bloco

            for (int i = 0; i < BUFFER_SIZE; i += 2) {  // carrega página com a palavra recebida
                rx_buff[i] = (word >> 8) & 0xFF ;
                rx_buff[i + 1] = word & 0xFF;
            }

            pagina = block;
            for(int i=0; i < 64; i++)
            {
                FLASH_program((pagina<<16), rx_buff, BUFFER_SIZE); //programa página
                pagina = pagina + 1;                              //incrementa página
            }


            if(crc == crc_local)
           {
               MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"k", 1 );
           }else
           {
               MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"e", 1 );
           }


        }
        else if(op == 0xbb)// comando leitura na flash
        {
            FLASH_reset();
            errors = 0;
            memset(rx_buff, 0x00, sizeof(rx_buff));                   //limpa buffer
            pagina = block;
            for(int i=0; i < 64; i++)
            {
                FLASH_read((pagina<<16), rx_buff, BUFFER_SIZE + 1);    //ler página (dummy byte + 2048)
                pagina = pagina + 1;                              //incrementa página

              for(int j = 1; j < BUFFER_SIZE+1; j+=2)            // contador de erros
              {
                    uint16_t num = rx_buff[j]<<8|rx_buff[j+1];
                    if(num != word)
                    {
                        errors++;
                    }
              }
            }
        }
        else
        {
           MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"e", 1 );
        }

          if(crc == crc_local)
          {
              //monta comando
              cmd_resp[0] = cmd[0];
              cmd_resp[1] = cmd[1];
              cmd_resp[2] = cmd[2];
              cmd_resp[3] = errors>>24;
              cmd_resp[4] = errors>>16;
              cmd_resp[5] = errors>>8;
              cmd_resp[6] = errors;

              crc_local = calculate_crc16((uint8_t *)cmd_resp,7);

              cmd_resp[7] = crc_local>>8;
              cmd_resp[8] = crc_local;

              MSS_UART_polled_tx( gp_my_uart, cmd_resp, 9 );  //envia comando
          }else
          {
              MSS_UART_polled_tx( gp_my_uart, (const uint8_t * )"e", 1 );
          }

    }


return 0;
}
