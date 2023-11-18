####################################################################################
# StarRC Reference Methodology README 
# Version: U-2022.12-SP2  
# Copyright (C) 1998-2022 Synopsys, Inc. All rights reserved.
####################################################################################

The reference methodology provides users with a set of reference 
scripts that serve as a good starting point for running each tool. These 
scripts are not designed to run in their current form. They should be used 
as a reference and adapted for use in your design environment.

The StarRC Reference Methodology supports gate-level extraction with the
following options:
*  Milkyway format designs
*  Library Exchange Format/Design Exchange Format (LEF/DEF)
*  IC Compiler II design databases
*  IC Compiler II In-Design features
*  Color/Mask based etching with Double Patterning Technology
*  Simultaneous MultiCorner extraction (SMC) including temperature variation extraction
*  Multicore (distributed) processing
*  Rapid3D Field Solver extraction
*  Extraction run with Denisty Corner outside block
*  Analysis with Virtual Metal fill
*  Metal fill statistics and reuse flow
*  Galaxy Parasitic Database (GPD)
*  Incremental Engineering Change Order (ECO) extraction
*  Hierarchical instance coupling extraction
*  Enabling Analysis With Parasitic Explorer
*  Database debug capabilities, including enhanced shorts reporting, visualization of database, and safety concern reports
*  RDL Pushdown of top level data into block-level extraction
*  Extraction settings for advanced nodes

The StarRC Reference Methodology also supports the following gate-level extraction 
special features:
* Clock Net Inductance Extraction

The StarRC Reference Methodology Includes the Following Files
===============================================================
STARRC-RMsettings.txt
     - Reference methodology option settings used to generate
       the scripts.

README.STARRC-RM.txt
     - Information and instructions for setting up and 
       running the StarRC Reference Methodology scripts.

Release_Notes.STARRC-RM.txt
     - Release notes for the StarRC Reference Methodology
       scripts listing the incremental changes in each new 
       version of the scripts.

rm_setup/run_starrc
     - StarRC run script for setting up the directory structure and 
       executing the tool command file. Use run_starrc for the standard
       reference methodlogy flow.

rm_starrc_scripts/star_cmd_gate
     - StarRC command file used for gate-level parasitic extraction


Instructions 
Using the StarRC Reference Methodology 
===========================================================================
1. Copy the reference methodology files to a new location.

2. Edit the run_starrc file to specify the path to StarXtract.
 
3. Edit the star_cmd_gate file to customize the following:
     - Setup, design, library file information, and so forth. 
       Insert this information where <angle_brackets> are located. 
     - Custom commands that you want to perform. 
   
   Read this command file carefully, note the comments, and choose the commands 
   that you want to include in your flow. You might also want to change the 
   file names to support your design environment. Remember that this is a 
   reference example that requires modification to work with your design.

4. For the standard flow, execute the StarRC run script from the 
   directory above the rm_setup directory: 
   
   % rm_setup/run_starrc


Input Files for the StarRC Reference Methodology
==================================================

Note: 
  Not all of these files are required. You can see the complete list of input files
  and define the file names in the star_cmd_gate file. 

*  MILKYWAY_DATABASE            (Milkyway layout database file)
*  LEF_FILE                     (technology LEF followed by standard cell LEF files)
*  TOP_DEF_FILE                 (file that defines the top-level block for extraction)
*  MACRO_DEF_FILE               (file that defines macros referenced in the TOP_DEF_FILE)
*  NDM_DATABASE                 (IC Compiler II design database file)
*  TCAD_GRD_FILE                (TCAD GRD file)
*  MAPPING_FILE                 (file with physical layer mapping information)
*  GDS_FILE                     (file with GDSII layout information)
*  GDS_LAYER_MAP_FILE           (file with GDSII layer mapping information)
*  OASIS_FILE                   (file with OASIS layout information)
*  OASIS_LAYER_MAP_FILE         (file with OASIS layer mapping information)
*  VIRTUAL_METAL_FILL_PARAMETER_FILE (Virtual Metal Fill if no real metal fill)
*  METAL_FILL_GDS_FILE          (GDSII file containing metal fill)
*  METAL_FILL_OASIS_FILE        (OASIS file containing metal fill)
*  CORNERS_FILE                 (file with SMC corner definitions)

Output Files from the StarRC Reference Methodology
====================================================
Define in the star_cmd_gate file: 
*  NETLIST_FILE        (file to which the output parasitic netlist is written)
*  STAR_DIRECTORY      (working directory for StarRC)

The SUMMARY_FILE defined in the star_cmd_gate file contains the command transcript.

The reports directory defined in star_cmd_gate contains the .STAR directory. 
The results directory defined in star_cmd_gate contains the netlist for 
timing or noise analysis. 

The input files required by the StarRC Reference Methodology scripts are 
designed to use the outputs from the IC Compiler II Reference Methodology 
or IC Compiler Reference Methodology.  The IC Compiler Reference Methodology 
is the preceding step in the reference flow and is available as a separate 
download from Synopsys.
