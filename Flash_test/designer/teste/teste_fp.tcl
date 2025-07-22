new_project \
         -name {teste} \
         -location {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\designer\teste\teste_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S025} \
         -name {M2S025}
enable_device \
         -name {M2S025} \
         -enable {TRUE}
save_project
close_project
