# 3-Phase Inverter RCP FYP

Welcome to the repository for my 2023 Final Year Project! The instructions below are adapted to Markdown from the user guide in the appendix of my report.

- Project Title: Deployment of Rapid Control Prototyping Technique for 3-phase Inverters
- Student: Yan To Chau
- Project Supervisor: Professor Tim Green
- Second Marker: Dr Balarko Chaudhuri
  
Special Thanks to: Dr Yue Zhu

## Files in this repository

1. `Simplus`: Consists of the Simplus hardware Simulink model files for all 3 configurations (GFM, GFL, Dual)
2. `Simulation`: Consists of the simulation Simulink model files for all 3 configurations
3. `Results`: Consists of scripts for visualising results from up to 5 tests simultaneously
4. `DesignFiles`: Altium Design files for the 4 PCBs made during this project
   1.  `Design1PCB`: Intermediate board for single inverter operating in open-loop
   2.  `Design2PCB`: Dual inverter system board for both inverters. Assembly drawings, schematic and BOM has been pre-generated and included in this folder.
   3.  `LCLFilter_Final` and `LCLFilter_Initial_LowPwr`: Simple boards for trying out different LCL filters. These 2 PCBs were manufactured using the Imperial EEE Maurice Hancock laboratory's Banham Milling Machine.
5.  `FYP Presentation Streamlined.pptx`: Slide deck for presentation.

## Videos

1. Practice for presentation: <https://youtu.be/GbfErqlS8Us>
2. Demo: <https://youtu.be/VnrgIGNwcq8>

## Acronyms

1. RCP: Rapid Control Prototyping
2. GFM: Grid Forming
3. GFL: Grid Following
4. Dual: Both inverters in closed loop control
5. PLL: Phase-Lock Loop
6. RTTs: Real Time Targets

## Access Simulink Model Files and Design Scripts

The following 2 links can be used to access my project files:

1.  [OneDrive](https://imperiallondon-my.sharepoint.com/:f:/g/personal/ytc19_ic_ac_uk/ElYF3Bl1xm9Nkzjqa6GZ_kABvirkBs4ug2XvBkXrjVuk5g?e=yOIcj3): Datasets (only accessible to Imperial College users, will expire after my account closes in November 2023)
2.  [GitHub](https://github.com/yannichau/3-Phase-Inverter-RCP-FYP):
    Altium design files, Simplus and Simulation Model Files (.slx) for
    all three configurations GFM, GFL, dual), scripts for generating plots

To start, clone the `3-Phase-Inverter-RCP-FYP` repository from
GitHub.

Optionally, to plot various step responses of datasets previously
obtained, download the folders `SimData` and `SimplusData` from OneDrive
and place them in the `Results` folder. The instructions are for
visualising these results are in the [results subsection](##Results). The files `concat_legend.m`,
`plotcurrentwithstyle.m`, `plotwithstyle.m` and `trim_results.m` are
functions used within the plotting scripts, and shall not be deleted.

## Simulations

The GFL,GFM and dual-inverter simulations can be accessible within the `Simulations`
folder. In each file, an inverter and filter is setup as shown as follows.

![](/Simulink%20Diagrams/Simulation_LCL.png)

The nominal values are shown in the report, but the topology can be
easily modified. For example, damping resistors can be added.

The following controllers can be modified double clicking the down arrow
$\downarrow$ on the corner of mask blocks:

- Current controller gains (GFL, , dual),
- Coltage controller gains (GFM, dual); and,
- PLL: $f_{\text{cutoff}}$ and gains (GFL, dual).

They can be modified as shown below.

![Modify GFL Gains](Simulink%20Diagrams/GFL_Modify.png)

![Modify GFM Gains](Simulink%20Diagrams/GFM_Modify.png)

Finally, before running the simulations, modify the step inputs. Modify the stop time accordingly and log the
scope output to the workspace for future comparisons.

![Modify Step Inputs](Simulink%20Diagrams/Modify_Steps.png)

## Running Simplus Models

At the time of project completion, the Simplus controller and software
toolbox for Simulink can be obtained from Yue Zhu
<yue.zhu18@imperial.ac.uk> or Yunjie Gu <yunjie.gu@imperial.ac.uk>.

The Simplus models for all 3 configurations for this project are
available in the `Simplus` folder. For GFL and GFM, the controllers can be modified in
dialogue boxes similar to those in the simulation. For the dual setup with both inverters
in closed loop, a higher level interface is offered as shown below.

![Dual Top Level Interface](Simulink%20Diagrams/Dual_Modify.png)

To run a manual setup with easy modification of RTTs during run-time:

1. Set stop time to inf,
2. Set scope trigger time in
    `Simplus > Control Panel > Signal & Triggering` is set to the 1
    second or `10000` samples; and,
3. Disable data logging to workspace.

To run an automated setup:

1. Set up the step inputs in advance:
2. Set stop time to a desired length,
3. Set scope trigger time in
    `Simplus > Control Panel > Signal & Triggering` is set to the stop
    time; and,
4. Ensure scope results are logged to the workspace for future
    comparisons.

To run the model, head to the Simplus tab to click 'Build for
Monitoring', 'Connect' and finally 'Run'. During run-time, inverter 1
can be switched OFF and ON, and between GFM and open-loop; inverter 2 can be switched
between OFF and GFL ON.

## Plotting multiple test results

Assuming the step responses between various tests of the same
configuration are aligned, the results can be compared using the scripts
in the `Results` folder.

`Dual_Plot_Many_Results.m` is meant for comparing the power, frequency
or real voltage perturbations one at a time. To do so, change the
`perturb` variable in the first section. More tests can be added, where
each string array variable (e.g. `sim_new`), consists of the file name
and legend.

The `GFM_Plot_Many_Results.m` and `GFL_Plot_Many_Results.m` scripts are
more full-featured, and are designed to compare up to 5 sets of tests
simultaneously as follows:

1.  In the first section of the script,
    `EDIT: File names and legend names`, add a string array variable
    (e.g. `sim_new`), that consists of the file name and legend. The
    legend typically shows the gains used for the test.

2.  Change the `selected` variable to include the tests to be compared.
    It is a `nx1` column array.

3.  Change the perturbation times in the second section. This restricts
    the x-axis of the plots to the time span specified.

4.  If a simulation dataset is used, include its variable name in the
    first if statement of the file. For example, it should be

                if (selected(i,:) == sim_single) | (selected(i,:) == sim_new)

Uncomment unnecessary plots and run the script to generate the plots.
