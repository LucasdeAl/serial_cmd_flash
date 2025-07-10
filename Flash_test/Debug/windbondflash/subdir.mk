################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../windbondflash/winbondflash.c 

OBJS += \
./windbondflash/winbondflash.o 

C_DEPS += \
./windbondflash/winbondflash.d 


# Each subdirectory must supply rules for building sources it contributes
windbondflash/%.o: ../windbondflash/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM Cross C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Microchip\SoftConsole-v2021.1\extras\workspace.examples\Flash_test\drivers\mss_spi" -I"C:\Microchip\SoftConsole-v2021.1\extras\workspace.examples\Flash_test\drivers\mss_uart" -I"C:\Microchip\SoftConsole-v2021.1\extras\workspace.examples\Flash_test\drivers\mss_sys_services" -I"C:\Microchip\SoftConsole-v2021.1\extras\workspace.examples\Flash_test\drivers\mss_timer" -std=gnu11 --specs=cmsis.specs -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


