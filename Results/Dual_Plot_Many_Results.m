clc; clf; clear all; close all; 

set(gcf,'renderer','Painters');

%%%%%%%% GFM (single voltage loop) with GFL (current loop) %%%%%%%%
%{
    vcd vcq values are at GFM
    ild ilq p q values are at GFL
    freq_ref is GFM, freq is GFL
%}


%% EDIT: File names and legend 

final_parameters = "GFM (K_{pv}, K_{iv}, K_{pi}, K_{ii}) = (0.028,  69.48, 0.61, 15) " + newline + "GFL (K_{pi}, K_{ii}) = (1.22, 61)";
test_11 = ["SimplusData/Dual_FurtherReduceKi", "Hardware"];

%sim_nominal = ["SimData/Dual_Nominal_Sim", "GFM (K_{pv}, K_{iv}, K_{pi}, K_{ii}) = (0.028,  8.685, 0.61, 60) " + newline + "GFL (K_{pi}, K_{ii}) = (1.22, 244) Simulation"];
sim_power = ["SimData/dual/dual_best_pperturb", "Simulation"];
sim_freq = ["SimData/dual/dual_best_fperturb", "Simulation"];
sim_vd = ["SimData/dual/dual_best_vdperturb", "Simulation"];

%% EDIT: Select perturbation to be plotted
perturb = 1; % 0 for power, 1 for frequency, 2 for vd

%% EDIT: Restrict scope timescale

%{
    
    Edit section accordingly
    1) time of perturbations
    2) add test file names and test functions (displayed in legend)
    3) select entries to be displayed

    %%%%%%% HARDWARE %%%%%%%
    10kHz operation (10k samples per second.)
    Total test is 35s

    0s : Initialise GFM
    5s: Initialise GFL

    P Perturbation
    10s : Step down power ref from 10 to -10W
    15s: Step down power ref from -10 to 10W

    Frequency Perturbation
    20s: Step up freq ref from 50 to 52
    25s: Step down freq ref from 52 to 50

    Vd perturb - Observe I, V, P
    30s : Step up vd ref from 15 to 18
    35s: Step down vd ref from 18 to 15

    35s: End test 

    %%%%%%% SOFTWARE %%%%%%%
    1MHz operation (1M samples per second)
    Total test is 5s
    
    0s: Initialise GFM
    1s: Initialise GFL
    3s: Perturbation (Power/Freq/Vd)
    5s: End test
    
%}

sample_rate = 10e3;
t_p_start = 9.9 * sample_rate;
t_p_end   = 10.4 * sample_rate;
t_freq_start = 19.9 * sample_rate;
t_freq_end   = 20.4 * sample_rate;
t_vd_start = 29.9 * sample_rate;
t_vd_end   = 30.4 * sample_rate;

hardware_t_perturb_start = 0;
hardware_t_perturb_end = 2*sample_rate;

sim_t_perturb_start = 2.9 * sample_rate;
sim_t_perturb_end   = 3.4 * sample_rate;


%% Select files

if perturb == 0
    sim_test = sim_power;
elseif perturb == 1
    sim_test = sim_freq;
elseif perturb == 2
    sim_test = sim_vd;
end

selected = [sim_test; test_11];
selected_size = size(selected,1);
test_name = [];
legend_list = [];

for i = 1:selected_size
    test_name = [test_name selected(i,1)];
    legend_list = [legend_list selected(i,2)];
end

%% Load selected files
for i=1:selected_size

    test_file = strcat(test_name(i), '.mat');
    load(test_file);

     if selected(i,:) == sim_test % SIMULATION

        file = out.Dual_Data_Sim;
        time_all  = file.time; 

        vcd_all   = file.signals(1).values;
        vcq_all   = file.signals(2).values;
        ild_all   = file.signals(3).values;
        ilq_all   = file.signals(4).values;
        freq_all  = file.signals(5).values;
        p_all     = file.signals(7).values;
        q_all     = file.signals(8).values;

        j = 1;
        sim_time = 5000000; % 5 seconds
        sim_time_scaled = sim_time/100;
        time = zeros(sim_time_scaled,1);
        vcd_scope  = zeros(sim_time_scaled,2);
        vcq_scope  = zeros(sim_time_scaled,2);
        ild_scope  = zeros(sim_time_scaled,2);
        ilq_scope  = zeros(sim_time_scaled,2);
        freq_scope = zeros(sim_time_scaled,2);
        p_scope    = zeros(sim_time_scaled,2);
        q_scope    = zeros(sim_time_scaled,2);
        for k=1:100:sim_time % need to scale back to 10kHz sample rate
            time(j,:) = time_all(k,:);
            vcd_scope(j,:) = vcd_all(k,:);
            vcq_scope(j,:) = vcq_all(k,:);
            ild_scope(j,:) = ild_all(k,:);
            ilq_scope(j,:) = ilq_all(k,:);
            freq_scope(j,:) = freq_all(k,:);
            p_scope(j,:) = p_all(k,:);
            q_scope(j,:) = q_all(k,:);
            j = j+1;
        end

        % Load Signals
        vcd      = vcd_scope(:,1);
        vcd_ref  = vcd_scope(:,2);
        vcq      = vcq_scope(:,1);
        vcq_ref  = vcq_scope(:,2);
        ild      = ild_scope(:,2);
        ilq      = ilq_scope(:,2);
        freq_ref = freq_scope(:,1);
        freq     = freq_scope(:,2);
        p        = p_scope(:,1);
        p_ref    = p_scope(:,2);
        q        = q_scope(:,1);
        q_ref    = q_scope(:,2);

        % Perturbation
        t_perturb      (:,i) = time(sim_t_perturb_start:sim_t_perturb_end);
        vcd_perturb    (:,i) = vcd(sim_t_perturb_start:sim_t_perturb_end); 
        vcd_ref_perturb(:,i) = vcd_ref(sim_t_perturb_start:sim_t_perturb_end); 
        vcq_perturb    (:,i) = vcq(sim_t_perturb_start:sim_t_perturb_end); 
        vcq_ref_perturb(:,i) = vcq_ref(sim_t_perturb_start:sim_t_perturb_end); 
        freq_ref_perturb(:,i) = freq_ref(sim_t_perturb_start:sim_t_perturb_end); 
        freq_perturb   (:,i) = freq(sim_t_perturb_start:sim_t_perturb_end); 
        p_perturb      (:,i) = p(sim_t_perturb_start:sim_t_perturb_end); 
        p_ref_perturb  (:,i) = p_ref(sim_t_perturb_start:sim_t_perturb_end);
        ild_perturb    (:,i) = ild(sim_t_perturb_start:sim_t_perturb_end);
        ilq_perturb    (:,i) = ilq(sim_t_perturb_start:sim_t_perturb_end);


    else % HARDWARE

        file = DualData;
        time = file.time;

        % Load scopes
        vcd_scope   = file.signals(1);
        vcq_scope   = file.signals(2);
        ild_scope   = file.signals(3);
        ilq_scope   = file.signals(4);
        freq_scope  = file.signals(5);
        p_scope     = file.signals(7);
        q_scope     = file.signals(8);

        % Load signals
        vcd      = vcd_scope.values(:,1);
        vcd_ref  = vcd_scope.values(:,2);
        vcq      = vcq_scope.values(:,1);
        vcq_ref  = vcq_scope.values(:,2);
        ild      = ild_scope.values(:,2);
        ild_ref  = ild_scope.values(:,3);
        ilq      = ilq_scope.values(:,2);
        ilq_ref  = ilq_scope.values(:,3);
        freq_ref = freq_scope.values(:,1);
        freq     = freq_scope.values(:,2);
        p        = p_scope.values(:,1);
        p_ref    = p_scope.values(:,2);
        q        = q_scope.values(:,1);
        q_ref    = q_scope.values(:,2);

        if perturb == 0 % Power
            hardware_t_perturb_start = t_p_start;
            hardware_t_perturb_end   = t_p_end;
        elseif perturb == 1 % Frequency
            hardware_t_perturb_start = t_freq_start;
            hardware_t_perturb_end   = t_freq_end;
        elseif perturb == 2 % Vd
            hardware_t_perturb_start = t_vd_start;
            hardware_t_perturb_end   = t_vd_end;
        end

        % Perturbation
        t_perturb      (:,i) = time(hardware_t_perturb_start:hardware_t_perturb_end);
        vcd_perturb    (:,i) = vcd(hardware_t_perturb_start:hardware_t_perturb_end); 
        vcd_ref_perturb(:,i) = vcd_ref(hardware_t_perturb_start:hardware_t_perturb_end); 
        vcq_perturb    (:,i) = vcq(hardware_t_perturb_start:hardware_t_perturb_end); 
        vcq_ref_perturb(:,i) = vcq_ref(hardware_t_perturb_start:hardware_t_perturb_end); 
        freq_ref_perturb(:,i) = freq_ref(hardware_t_perturb_start:hardware_t_perturb_end); 
        freq_perturb   (:,i) = freq(hardware_t_perturb_start:hardware_t_perturb_end); 
        p_perturb      (:,i) = p(hardware_t_perturb_start:hardware_t_perturb_end); 
        p_ref_perturb  (:,i) = p_ref(hardware_t_perturb_start:hardware_t_perturb_end);
        ild_perturb    (:,i) = ild(hardware_t_perturb_start:hardware_t_perturb_end);
        ilq_perturb    (:,i) = ilq(hardware_t_perturb_start:hardware_t_perturb_end);     
    end
end

%% Graph Plotting
if perturb == 0 % Power

    figure(1);
    plot(t_perturb(:,2), p_ref_perturb(:,2), 'k'); hold on;
    plotwithstyle(t_perturb(:,2), p_perturb); hold on;
    ylabel('P (W)');
    xlabel('t (s)');
    legend(["Reference", legend_list]);
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);

    figure(2);
    plot(t_perturb(:,2), vcd_ref_perturb(:,2), 'k'); hold on;
    plotcurrentwithstyle(t_perturb(:,2), vcd_perturb, vcq_perturb);
    ylabel('V_c (V)');
    xlabel('t (s)');
    legend(["Reference", concat_legend("V_d", legend_list), concat_legend("V_q", legend_list)], 'Location','East');
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);

elseif perturb == 1 % Freq

    figure(3);
    plot(t_perturb(:,2), freq_ref_perturb(:,2), 'k'); hold on;
    plotwithstyle(t_perturb(:,2), freq_perturb); hold on;
    ylabel('f (Hz)');
    xlabel('t (s)');
    legend(["VCO Frequency Reference", concat_legend("f_{PLL}", legend_list)], 'Location','Southeast');
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);

    figure(4);
    plot(t_perturb(:,2), p_ref_perturb(:,2), 'k'); hold on;
    plotwithstyle(t_perturb(:,2), p_perturb); hold on;
    ylabel('P (W)');
    xlabel('t (s)');
    legend(["Reference", legend_list]);
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);

elseif perturb == 2 % Vd

    figure(5);
    plot(t_perturb(:,2), p_ref_perturb(:,2), 'k'); hold on;
    plotwithstyle(t_perturb(:,2), p_perturb); hold on;
    ylabel('P (W)');
    xlabel('t (s)');
    legend(["Reference", legend_list]);
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);

    figure(6);
    plot(t_perturb(:,2), vcd_ref_perturb(:,2), 'k'); hold on;
    plotcurrentwithstyle(t_perturb(:,2), vcd_perturb, vcq_perturb);
    ylabel('V_c (V)');
    xlabel('t (s)');
    legend(["Reference", concat_legend("V_d", legend_list), concat_legend("V_q", legend_list)], 'Location','East');
    xlim([hardware_t_perturb_start hardware_t_perturb_end]/sample_rate);
end

