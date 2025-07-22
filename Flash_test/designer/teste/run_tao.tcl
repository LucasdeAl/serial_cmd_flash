set_device -family {SmartFusion2} -die {M2S025} -speed {STD}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp_pcie_hotreset.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\Actel\DirectCore\CoreResetP\7.1.100\rtl\vlog\core\coreresetp.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\work\teste_sb\CCC_0\teste_sb_CCC_0_FCCC.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\work\teste_sb\FABOSC_0\teste_sb_FABOSC_0_OSC.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\work\teste_sb_MSS\teste_sb_MSS.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\work\teste_sb\teste_sb.v}
read_verilog -mode system_verilog {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\component\work\teste\teste.v}
set_top_level {teste}
map_netlist
check_constraints {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\designer\teste\synthesis.fdc}
