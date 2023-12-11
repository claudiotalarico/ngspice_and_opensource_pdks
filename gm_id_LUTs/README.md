##  Matlab scripts to build the .mat files for the sky130 technology

The LUTs generated (.mat files) with Ngspice don't incorporate **yet** the noise analysis <br>
NOTE: at the moment the value of the caps extracted are incorrect <br>
The "meaning" of the BSIM4's caps extracted with Ngspice is different from the BSIM3's caps extracted with HSPICE)

### Essential scripts

These scripts are adapted from the scripts developed by B. Murmann<br>
(https://github.com/bmurmann/Book-on-gm-ID-design)

`techsweep_run_ngspice.m`<br>
*Top-level script that executes the lookup table generation.*

`techsweep_cfg_bsim4_sky130_ngspice.m`<br>
*Configuration file called by the top-level script.*<br>
*The configuration file defines all tool and file paths and contains a netlist template near the bottom.*<br> 
*This is where you define the content of the auto-generated simulation netlist.*<br>
*Also, the configuration file defines how the raw simulation parameters are mapped into Matlab variables.*<br>
*It typically takes some time to get all the paths and settings right.*

`techsweep_debug_ngspice.m`<br>
*Utility script designed for debugging the configuration file.*<br> 
*Basically, this is a simplified version of the techsweep_run_ngspice.m file and runs just one single*<br> 
*simulation sweep and display the parameters at mid-supply.*<br> 
*Once this works, the full table generation can be kicked off and should work without any problems.* 

### Testing scripts
`test_lookup_ngspice.m`<br>
*Usage examples for the function "look_up"*<br>

`test_lookupVGS_ngspice.m`<br>
*Usage examples for the function "look_upVGS"*<br>

*Also, for more details, from within matlab use:*<br> 
>`help look_up`<br>
>`help look_upVGS`

### Notes
The sky130's Ngspice model for the PMOS has issues (both in the SKY130A and the SKY130B). <br>
To see the issue in action look at the gm/ID vs. VSG  curve on Boris Murmann's github: <br>
(https://github.com/bmurmann/Ngspice-on-Colab/blob/main/notebooks/SKY130_VGS_sweep.ipynb) <br>
