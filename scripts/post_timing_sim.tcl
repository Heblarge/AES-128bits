open_project ./vivado_project/vivado_project.xpr
update_compile_order -fileset sources_1
open_run synth_1 -name synth_1
launch_simulation -mode post-synthesis -type timing
close_sim
exit