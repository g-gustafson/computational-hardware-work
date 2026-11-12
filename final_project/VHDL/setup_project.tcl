##############################################################################################
#
# Configure and run a vivado project 
#
# Thanks to https://grittyengineer.com/vivado-project-mode-tcl-script/ for this script!
# Also thanks to https://www.eevblog.com/forum/fpga/using-vivado-in-tcl-mode/ for simulation 
# configuration information!
# 3/10/2026 - Kent - Updated options to give more control for project generation
###############################################################################################

###################################################################
# Project Configuration
###################################################################

# Project and folder options
set outputFolder "./generated"
set projectName "greg_the_processor"

# Top-level design and testbench
set topLevelModuleName "greg_top"
set topLevelTestbenchModuleName ""
set simulationTestbench ""

# Simulation control
set runSimulation "false"    

# Build options - suggest setting all to true for clean generation
set cleanOutputFolder "true"  
set runSynthesis "true"       
set generateBitStream "true"
set programDevice "true"

# FPGA part and constraints
set fpgaPart "xc7a35tcpg236-1"
set constraintsFile "./Basys3_Master.xdc"

###################################################################
# Clean output folder if requested
###################################################################
if { [file isdirectory $outputFolder] && $cleanOutputFolder eq "true" } {
    puts "------------------------------ Cleaning output folder $outputFolder ------------------------------"
    file delete -force {*}[glob -nocomplain "$outputFolder/*"]
    file delete -force {*}[glob -nocomplain *.backup.log *.backup.jou]
} elseif { ![file isdirectory $outputFolder] } {
    puts "------------------------------ Creating output folder $outputFolder ------------------------------"
    file mkdir $outputFolder
}

###################################################################
# Open existing project or create a new one
###################################################################

set projfile [file join $outputFolder "${projectName}.xpr"]

if { [file exists $projfile] } {
    puts "------------------------------ Opening existing project for faster build ------------------------------"
    open_project $projfile
} else {
    puts "------------------------------ Creating new project in $outputFolder ------------------------------"
    create_project -part $fpgaPart $projectName $outputFolder

    # Add design sources
    add_files -fileset sources_1 [glob ./*.vhd]

    # Add testbench
    if { $simulationTestbench ne "" } {
        add_files -fileset sim_1 $simulationTestbench
    }

    # Add constraints
    add_files -fileset constrs_1 $constraintsFile

    # Language settings
    set_property target_language VHDL [current_project]
    set_property file_type {VHDL 2008} [get_files -filter {FILE_TYPE == VHDL}]

    # Set top modules
    set_property top $topLevelModuleName [get_filesets sources_1]
    if { $topLevelTestbenchModuleName ne "" } {
        set_property top $topLevelTestbenchModuleName [get_filesets sim_1]
    }

    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
}

###################################################################
# Simulation
###################################################################
if { $runSimulation eq "true" && $topLevelTestbenchModuleName ne "" } {
    puts "\n------------------------------ Running simulation ------------------------------"
    launch_simulation -simset sim_1 -mode behavioral
} else {
    puts "\n------------------------------ Skipping simulation ------------------------------"
}

###################################################################
# Synthesis
###################################################################
if { $runSynthesis eq "true" } {
    set_property source_mgmt_mode None [current_project]
    reset_run synth_1

    puts "\n------------------------------ Running synthesis ------------------------------"
    launch_runs synth_1
    wait_on_run synth_1
} else {
    puts "\n------------------------------ Skipping synthesis  ------------------------------"
}

###################################################################
# Implementation / Bitstream
###################################################################

set bitfilePath [file normalize "${outputFolder}/${projectName}.runs/impl_1/${topLevelModuleName}.bit"]

if { $generateBitStream eq "true" } {

    if { ![file exists $bitfilePath] } {
        puts "\n------------------------------ Generating bitstream ------------------------------"
        reset_run impl_1
        set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
        launch_runs impl_1 -to_step write_bitstream
        wait_on_run impl_1
    } else {
        puts "\n------------------------------ Bitstream already exists. Skipping implementation ------------------------------"
    }
}

###################################################################
# Program FPGA
###################################################################
if { $programDevice eq "true" && [file exists $bitfilePath] } {

    puts "\n------------------------------ Programming FPGA with $bitfilePath ------------------------------"

    # Hardware device name for Basys3
    set hwDeviceName "xc7a35t_0"

    open_hw_manager
    connect_hw_server -allow_non_jtag
    open_hw_target

    current_hw_device [get_hw_devices $hwDeviceName]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $hwDeviceName] 0]

    set_property PROGRAM.FILE $bitfilePath [get_hw_devices $hwDeviceName]
    program_hw_devices [get_hw_devices $hwDeviceName]

    refresh_hw_device [lindex [get_hw_devices $hwDeviceName] 0]

    close_hw_target
    close_hw_manager
}

puts "\n------------------------------ setup_project.tcl done! --------------------------------------------"
