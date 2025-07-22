//////////////////////////////////////////////////////////////////////
// Created by SmartDesign Tue Jul  8 09:08:43 2025
// Version: 2024.1 2024.1.0.3
//////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

// teste
module teste(
    // Inputs
    DEVRST_N,
    MMUART_0_RXD_F2M,
    MMUART_1_RXD_F2M,
    SPI_0_DI_F2M,
    // Outputs
    MMUART_0_TXD_M2F,
    MMUART_1_TXD_M2F,
    SPI_0_CLK_M2F,
    SPI_0_DO_M2F,
    SPI_0_SS0_M2F
);

//--------------------------------------------------------------------
// Input
//--------------------------------------------------------------------
input  DEVRST_N;
input  MMUART_0_RXD_F2M;
input  MMUART_1_RXD_F2M;
input  SPI_0_DI_F2M;
//--------------------------------------------------------------------
// Output
//--------------------------------------------------------------------
output MMUART_0_TXD_M2F;
output MMUART_1_TXD_M2F;
output SPI_0_CLK_M2F;
output SPI_0_DO_M2F;
output SPI_0_SS0_M2F;
//--------------------------------------------------------------------
// Nets
//--------------------------------------------------------------------
wire   DEVRST_N;
wire   MMUART_0_RXD_F2M;
wire   MMUART_0_TXD_M2F_net_0;
wire   MMUART_1_RXD_F2M;
wire   MMUART_1_TXD_M2F_net_0;
wire   SPI_0_CLK_M2F_net_0;
wire   SPI_0_DI_F2M;
wire   SPI_0_DO_M2F_net_0;
wire   SPI_0_SS0_M2F_net_0;
wire   MMUART_0_TXD_M2F_net_1;
wire   MMUART_1_TXD_M2F_net_1;
wire   SPI_0_CLK_M2F_net_1;
wire   SPI_0_DO_M2F_net_1;
wire   SPI_0_SS0_M2F_net_1;
//--------------------------------------------------------------------
// TiedOff Nets
//--------------------------------------------------------------------
wire   VCC_net;
//--------------------------------------------------------------------
// Constant assignments
//--------------------------------------------------------------------
assign VCC_net = 1'b1;
//--------------------------------------------------------------------
// Top level output port assignments
//--------------------------------------------------------------------
assign MMUART_0_TXD_M2F_net_1 = MMUART_0_TXD_M2F_net_0;
assign MMUART_0_TXD_M2F       = MMUART_0_TXD_M2F_net_1;
assign MMUART_1_TXD_M2F_net_1 = MMUART_1_TXD_M2F_net_0;
assign MMUART_1_TXD_M2F       = MMUART_1_TXD_M2F_net_1;
assign SPI_0_CLK_M2F_net_1    = SPI_0_CLK_M2F_net_0;
assign SPI_0_CLK_M2F          = SPI_0_CLK_M2F_net_1;
assign SPI_0_DO_M2F_net_1     = SPI_0_DO_M2F_net_0;
assign SPI_0_DO_M2F           = SPI_0_DO_M2F_net_1;
assign SPI_0_SS0_M2F_net_1    = SPI_0_SS0_M2F_net_0;
assign SPI_0_SS0_M2F          = SPI_0_SS0_M2F_net_1;
//--------------------------------------------------------------------
// Component instances
//--------------------------------------------------------------------
//--------teste_sb
teste_sb teste_sb_0(
        // Inputs
        .FAB_RESET_N      ( VCC_net ), // tied to 1'b1 from definition
        .DEVRST_N         ( DEVRST_N ),
        .MMUART_0_RXD_F2M ( MMUART_0_RXD_F2M ),
        .MMUART_1_RXD_F2M ( MMUART_1_RXD_F2M ),
        .SPI_0_DI_F2M     ( SPI_0_DI_F2M ),
        .SPI_0_CLK_F2M    ( VCC_net ),
        .SPI_0_SS0_F2M    ( VCC_net ),
        // Outputs
        .POWER_ON_RESET_N (  ),
        .INIT_DONE        (  ),
        .FAB_CCC_GL0      (  ),
        .FAB_CCC_LOCK     (  ),
        .MSS_READY        (  ),
        .MMUART_0_TXD_M2F ( MMUART_0_TXD_M2F_net_0 ),
        .MMUART_1_TXD_M2F ( MMUART_1_TXD_M2F_net_0 ),
        .SPI_0_DO_M2F     ( SPI_0_DO_M2F_net_0 ),
        .SPI_0_CLK_M2F    ( SPI_0_CLK_M2F_net_0 ),
        .SPI_0_SS0_M2F    ( SPI_0_SS0_M2F_net_0 ),
        .SPI_0_SS0_M2F_OE (  ) 
        );


endmodule
