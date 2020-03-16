open_project hls_fir1ch_prj
set_top fir_filter
add_files ../rtl/fir.cpp
add_files -tb ../tb/fir_test.cpp
add_files -tb data

############ SOLUTION0 and its variants ###################

# baseline solution0: no directives at all
open_solution "solution0"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
csim_design -clean
csynth_design

# as solution0 plus PIPELINE the internal loop
open_solution "solution0_b"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
set_directive_pipeline "fir_filter/Shift_Accum_Loop"
csynth_design

# as solution0_b plus complete PARTITION of the shift_reg ARRAY
open_solution "solution0_c"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
set_directive_array_partition -type complete -dim 1 "fir_filter" shift_reg
set_directive_pipeline "fir_filter/Shift_Accum_Loop"
csynth_design

# as solution0_c plus UNROLL completely the internal loop
open_solution "solution0_d"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
set_directive_array_partition -type complete -dim 1 "fir_filter" shift_reg
set_directive_pipeline "fir_filter/Shift_Accum_Loop"
set_directive_unroll -factor 16 "fir_filter/Shift_Accum_Loop"
csynth_design

# as solution0_d plus complete PARTITION of the c ARRAY 
open_solution "solution0_e"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
set_directive_array_partition -type complete -dim 1 "fir_filter" shift_reg
set_directive_pipeline "fir_filter/Shift_Accum_Loop"
set_directive_unroll -factor 16 "fir_filter/Shift_Accum_Loop"
set_directive_array_partition -type complete -dim 1 "fir_filter" c
csynth_design

############ SOLUTION1 and its variants ###################

# solution1_II1: all arrays partitioned and PIPELINE at top level with II=1
open_solution "solution1_II1"
set_part  {xc7z020clg484-1}
create_clock -period 10 -name default
set_directive_array_partition -type complete -dim 1 "fir_filter" c
set_directive_array_partition -type complete -dim 1 "fir_filter" shift_reg
set_directive_pipeline -II 1 "fir_filter"
csynth_design
cosim_design
export_design -evaluate verilog -format ip_catalog