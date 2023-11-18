puts "RM-Info: Running script [info script]\n"
#################################################################################
# PrimeTime Reference Methodology Script
# Script: dmsa_analysis.tcl
# Version: S-2021.06-SP4 (January 19, 2022)
# Copyright (C) 2009-2020 Synopsys All rights reserved.
#################################################################################


#################################################################################
# 
# This file will produce the reports for the DMSA mode based on the options
# used within the GUI.
#
# The output files will reside within the work/scenario subdirectories.
#
#################################################################################


###################################################################
#           PrimeSheild Robustness ECO Setup Section              #
#      Please uncomment below settings for ECO Robustness         #
#   Note you need to uncomment the ps_enable_analysis to enable   #
#   PrimeSheild analysis, the setting is in pt_setup.tcl          #
###################################################################
# set timing_save_pin_arrival_and_required true
 
# Below setup is required for normalized slack
# remote_execute {
#   enable_timing_dvar_normalized_slack 
# }  

# source ./fix_eco_robustness.tbc
# remote_execute {
#             source ./fix_eco_robustness.tbc
#             set ps_enable_analysis true
#             set timing_save_pin_arrival_and_required true
#             }
#
#             remote_execute {
#             ## Generate Pre-ECO Reports
#             set paths [get_timing_path -pocv_pruning  -group $grp -delay_type max -pba ex -path_type full_clock_expanded -slack_lesser_than 1 \ -nworst 20 -max_path 2000000]
#             set dvar [get_design_variation -sample_size 100000 $paths]
#             ## Generate slack distribution
#             gen_distribution_csv -path $paths -type slack -output $output/design_slack_pre.csv $dvar
#             ## Generate frequency distribution
#             gen_distribution_csv -path $paths -type frequency -output $output/frequency_pre.csv $dvar
#             }
#
#             fix_eco_robustness -type bottleneck -pattern {SVT HVT} -object dvar
#
#             remote_execute {
#             ## Generate Post-ECO Reports
#             set paths [get_timing_path -pocv_pruning  -group $grp -delay_type max -pba ex -path_type full_clock_expanded -slack_lesser_than 1 \ -nworst 20 -max_path 2000000]
#             set dvar [get_design_variation -sample_size 100000 $paths]
#             ## Generate slack distribution
#             gen_distribution_csv -path $paths -type slack -output $output/design_slack_post.csv $dvar
#             ## Generate frequency distribution
#             gen_distribution_csv -path $paths -type frequency -output $output/frequency_post.csv $dvar
#
#             }


remote_execute {
    set pba_exhaustive_endpoint_path_limit infinity  
}

##################################################################
#    Constraint Analysis Section
##################################################################
remote_execute {
check_constraints -verbose > $REPORTS_DIR/${DESIGN_NAME}_check_constraints.report
}

##################################################################
#    Update_timing and check_timing Section                      #
##################################################################
remote_execute {
set timing_save_pin_arrival_and_slack true
update_timing -full
# Ensure design is properly constrained
check_timing -verbose > $REPORTS_DIR/${DESIGN_NAME}_check_timing.report
}


##################################################################
#   Writing an Reduced Resource ECO design                       #
##################################################################
# PrimeTime has the capability to write out an ECO design which 
# is a smaller version of the orginal design ECO can be performed
# with fewer compute resources.
#
# Writes an ECO design  that  preserves  the  specified  violation
# types  compared to those in the original design. You can specify
#  one or more of the following violation types:
#              o setup - Preserves setup timing results.
#              o hold - Preserves hold timing results.
#              o max_transistion - Preserves max_transition results.
#              o max_capacitance - Preserves max_capacitance results.
#              o max_fanout - Preserves max_fanout results.
#              o noise - Preserves noise results.
#              o timing - Preserves setup and hold timing results.
#              o drc  -  Preserves  max_transition,  max_capacitance,  
#                and max fanout results.
# There is also capability to write out specific endpoints with
# the -endpoints options.
#
# In DMSA analyis the RRECO design is written out relative to all
# scenarios enabled for analysis.
# 
# To create a RRECO design the user should perform the following 
# command and include violations types which the user is interested
# in fixing, for example for setup and hold.
# 
# write_eco_design  -type {setup hold} my_RRECO_design
#
# Once the RRECO design is created, the user then would invoke 
# PrimeTIme ECO in a seperate session and access the appropriate
# resourses and then read in the RRECO to perform the ECO
# 
# set_host_options ....
# start_hosts
# read_eco_design my_RRECO_design
# fix_eco...
#
# For more details please see man pages for write_eco_design
# and read_eco design.


##################################################################
#    Report_timing Section                                       #
##################################################################
#==============================================================================
#Cover through reporting from 2018.06* version
#get_timing_paths and report_timing commands are enhanced with a new option, -cover_through through_list, which collects the single worst violating path through    each of the objects specified in a list. 
#For example,
#pt_shell> remote_execute {get_timing_paths -cover_through {n1 n2 n3} }
#This command creates a collection containing the worst path through n1, the worst path
#through n2, and the worst path through n3, resulting in a collection of up to three paths.
#=======================================================================
report_global_timing > $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_global_timing.report
report_timing -slack_lesser_than 0.0 -pba_mode exhaustive -delay min_max -nosplit -input -net -sign 4 > $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_timing_pba.report

report_analysis_coverage > $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_analysis_coverage.report 

remote_execute {
report_clock -skew -attribute > $REPORTS_DIR/${DESIGN_NAME}_report_clock.report 
}
report_constraints -all_violators -verbose > $REPORTS_DIR/${DESIGN_NAME}_dmsa_report_constraints.report
remote_execute {
report_constraints -all_violators -verbose > $REPORTS_DIR/${DESIGN_NAME}_report_constraints.report
report_design > $REPORTS_DIR/${DESIGN_NAME}_report_design.report
report_net > $REPORTS_DIR/${DESIGN_NAME}_report_net.report
}
remote_execute {
report_ocvm -type pocvm > $REPORTS_DIR/${DESIGN_NAME}_report_pocvm.report
}
remote_execute {
    report_ivm
}



##################################################################
#    Fix ECO Comments                                            #
##################################################################
# You can use -current_library option of fix_eco_drc and fix_eco_timing to use
# library cells only from the current library that the cell belongs to when sizing
#
# You can control the allowable area increase of the cell during sizing by setting the
# eco_alternative_area_ratio_threshold variable
#
# You can restrict sizing within a group of cells by setting the
# eco_alternative_cell_attribute_restrictions variable
#
# Refer to man page for more details

##################################################################
#    Physically Aware ECO Options Section                        #
##################################################################
remote_execute {
  set_eco_options -physical_lib_path $LEF_FILES -physical_design_path $DEF_FILES -log_file lef_def.log
}
##################################################################
#    Physically Aware check_eco Section                          #
##################################################################
remote_execute {
  check_eco 
}

##################################################################
#    Fix ECO Power Cell Downsize Section                         #
##################################################################
# Note if power attributes flow is desired fix_eco_power -power_attribute
# then attribute file needs to be provided for lib cells.
# See 2014.12 update training for examples
#
# PBA mode can be enabled by changing the -pba_mode option
# See fix_eco_power man page for more details on PBA based fixing
# Additional PBA controls are also available with -pba_path_selection_options
# Reporting options should be changed to reflect PBA based ECO
#
fix_eco_power -pba_mode none -verbose

##################################################################
#    Fix ECO Power Buffer Removal                                #
##################################################################
# Power recovery also has buffer removal capability.  
# Buffer removal usage is as follows:
# fix_eco_power -method remove_buffer
# When can specify -method remove_buffer, it cannot be used in conjunction 
# with size_cell, so buffer removal needs to be done in a separate 
# fix_eco_power command.  Please see the man page for additional details.

 


##################################################################
#    Fix ECO DRC Section                                         #
##################################################################
# Additional setup and hold margins can be preserved while fixing DRC with -setup_margin and -hold_margin
# Refer to man page for more details
# fix max transition 
fix_eco_drc -type max_transition -method { size_cell insert_buffer } -verbose -buffer_list $eco_drc_buf_list -physical_mode open_site 
# fix max capacitance 
fix_eco_drc -type max_capacitance -method { size_cell insert_buffer } -verbose -buffer_list $eco_drc_buf_list -physical_mode open_site 
# fix max fanout 
fix_eco_drc -type max_fanout -method { size_cell insert_buffer } -verbose -buffer_list $eco_drc_buf_list -physical_mode open_site 
# fix noise 
fix_eco_drc -type noise -method { size_cell insert_buffer } -verbose -buffer_list $eco_drc_buf_list -physical_mode open_site 

##################################################################
#    Fix ECO Timing Section                                      #
##################################################################
# Path Based Analysis is supported for setup and hold fixing
#
# You can use -setup_margin and -hold_margin to add margins during 
# setup and hold fixing
#
# DRC can be ignored while fixing timing violations with -ignore_drc
#
# Refer to man page for more details
#
# Path specific and PBA based ECO can enabled via -path_selection_options
# See fix_eco_timing man page for more details path specific on PBA based timing fixing
# Reporting options should be changed to reflect path specific and PBA based ECO
#
# fix setup with sequential cell sizing 
fix_eco_timing -type setup -cell_type sequential -verbose -slack_lesser_than 0 -physical_mode open_site -estimate_unfixable_reasons 
# fix hold with sequential cell sizing 
fix_eco_timing -type hold -cell_type sequential -method "size_cell" -verbose -slack_lesser_than 0 -hold_margin 0 -setup_margin 0 -physical_mode open_site -estimate_unfixable_reasons 

#This is for power attribute flow for Scalar and DMSA
#fix_eco_timing -type hold -power_attribute <attr name>
#This is for leakage based flow for DMSA
#fix_eco_timing -type hold -power_mode leakage -leakage_scenario <scen_name>


##################################################################
#    Fix ECO Output Section                                      #
##################################################################
# write netlist changes
remote_execute {
write_changes -format icctcl -output $RESULTS_DIR/eco_changes.tcl
}






##################################################################
#    Generation of Hierarchical Model Section                    #
#                                                                #
#  Extracted Timing Model (ETM) will contain composite current   #
#  source (CCS) timing models, if design libraries contains both #
#  CCS timing and noise data along with design for which model   #
#  is extracted has waveform propogation enable using variable   #
#  'set delay_calc_waveform_analysis_mode full_design'           #
##################################################################

remote_execute {  
extract_model -library_cell -test_design -output ${RESULTS_DIR}/${DESIGN_NAME} -format {lib db}    
write_interface_timing ${REPORTS_DIR}/${DESIGN_NAME}_etm_netlist_interface_timing.report 
}  


##################################################################
#    Save_Session Section                                        #
##################################################################


remote_execute {
save_session ${DESIGN_NAME}_ss
}




puts "RM-Info: Completed script [info script]\n"
