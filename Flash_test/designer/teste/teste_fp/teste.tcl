open_project -project {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\designer\teste\teste_fp\teste.pro}
enable_device -name {M2S025} -enable 1
set_programming_file -name {M2S025} -file {C:\Users\Lucas\Documents\EscritaFlash\Flash_test\designer\teste\teste.ppd}
set_programming_action -action {PROGRAM} -name {M2S025} 
run_selected_actions
save_project
close_project
