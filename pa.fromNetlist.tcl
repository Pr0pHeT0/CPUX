
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name CPUX -dir "/home/qsz/CPUX/planAhead_run_1" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/qsz/CPUX/CPU.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/qsz/CPUX} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "CPU.ucf" [current_fileset -constrset]
add_files [list {CPU.ucf}] -fileset [get_property constrset [current_run]]
link_design
