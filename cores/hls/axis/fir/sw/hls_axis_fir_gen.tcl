#
# Copyright 2019 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create a project
open_project -reset proj_cpp_FIR

# Add design files
add_files ./rtl/cpp_FIR.cpp
add_files ./rtl/cpp_FIR.h
# Add test bench & files
add_files -tb ./tb/cpp_FIR_test.cpp
add_files -tb ./rtl/cpp_FIR.h
add_files -tb ./rtl/data/cpp_FIR.inc
add_files -tb ./tb/result.golden.dat

# Set the top-level function
set_top cpp_FIR

# ########################################################
# Create a solution
open_solution -reset solution1
# Define technology and clock rate
set_part  {xc7z020clg484-1}
create_clock -period 4

# Source x_hls.tcl to determine which steps to execute
source ./sw/x_hls.tcl
csim_design
# Set any optimization directives
# End of directives

if {$hls_exec == 1} {
	# Run Synthesis and Exit
	csynth_design
	
} elseif {$hls_exec == 2} {
	# Run Synthesis, RTL Simulation and Exit
	csynth_design
	
	cosim_design
} elseif {$hls_exec == 3} { 
	# Run Synthesis, RTL Simulation, RTL implementation and Exit
	csynth_design
	
	cosim_design
	export_design
} else {
	# Default is to exit after setup
	csynth_design
}

exit