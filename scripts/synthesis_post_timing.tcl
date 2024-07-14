open_project ./vivado_project/vivado_project.xpr
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 16 -quiet
wait_on_run synth_1
quit