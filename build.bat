

rd /s /q .\vivado_project
del /q *.log *.jou *.str



CALL vivado -mode batch -source scripts\sim.tcl -notrace
CALL vivado -mode batch -source scripts\synthesis_post_timing.tcl -notrace
CALL vivado -mode batch -source scripts\post_timing_sim.tcl -notrace



