

### pt_setup.tcl file              ###





puts "RM-Info: Running script [info script]\n"
### Start of PrimeTime Runtime Variables ###

##########################################################################################
# PrimeTime Variables PrimeTime Reference Methodology script
# Script: pt_setup.tcl
# Version: S-2021.06-SP4 (January 19, 2022)
# Copyright (C) 2008-2021 Synopsys All rights reserved.
##########################################################################################


######################################
# Report and Results Directories
######################################


set REPORTS_DIR "reports"
set RESULTS_DIR "results"

######################################
# Design Setup
######################################
set search_path ". $ADDITIONAL_SEARCH_PATH $search_path"

# DESIGN_NAME is checked for existence from common_setup.tcl
if {[string length $DESIGN_NAME] > 0} {
} else {
set DESIGN_NAME                   ""  ;#  The name of the top-level design
}

######################################
# Restore Session DMSA Setup
######################################
# Provide an array of saved sessions to be restored as dmsa scenarios
# The syntax will be restore_session_dmsa(scenario_name) "saved_session_name"
#       1. restore_session_dmsa(func_slow) "ss_func_slow"
#       2. restore_session_dmsa(func_fast) "ss_func_fast"

set restore_session_dmsa(name) "session"

######################################
# Make Reporting Directories
######################################
# make REPORTS_DIR
file mkdir $REPORTS_DIR

# make RESULTS_DIR
file mkdir $RESULTS_DIR








######################################
# Setting Number of Hosts and Licenses
######################################
# Set the number of hosts and licenses for compute resource efficient ECO
# Make sure you have sufficient RAM and free disk space in multi_scenario_working_directory
# otherwise it may result in unexpected slowdowns and crashes without proper stack traces
set num_of_scenarios [array size restore_session_dmsa]
if {$num_of_scenarios < 4} {
        set dmsa_num_of_hosts $num_of_scenarios
} elseif {$num_of_scenarios >= 4 && $num_of_scenarios <= 8} {
        set dmsa_num_of_hosts 4
} else {
        if {[expr ceil([expr $num_of_scenarios/4.0])] > 8} {
                set dmsa_num_of_hosts [expr int(ceil([expr $num_of_scenarios/4.0]))]
        } else {
                set dmsa_num_of_hosts 8
        }
}
set dmsa_num_of_licenses $dmsa_num_of_hosts





######################################
# Fix ECO DRC Setup
######################################
# specify a list of allowable buffers to use for fixing DRC
# Example: set eco_drc_buf_list "BUF4 BUF8 BUF12"
set eco_drc_buf_list ""




######################################
# Physically Aware ECO Setup
######################################
# Specify a list of files for physically aware ECO
# Example: set LEF_FILES "lef1.lef lef2.lef ..."
set LEF_FILES ""
#
# Example: set DEF_FILES "def1.def def2.def ..."
set DEF_FILES ""


#set Hyperscale variables
set HS_TOP_CONTEXT_PATH ""
set HS_BLK_PATH ""
set HS_BLK ""
set context_dir_gx ""
set context_dir_gy ""
set context_merge_A2_A4 ""



# PrimeSheild setup
# Please uncomment below setup in order to use PrimeSheild analysis
# set ps_enable_analysis true
######################################
# End
######################################

### End of PrimeTime Runtime Variables ###
puts "RM-Info: Completed script [info script]\n"
