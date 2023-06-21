clc; clf; close all; clear all; 

set(gcf,'renderer','Painters');

%%%%%%%% GRID FORMING %%%%%%%%

%% EDIT: File names and legend names

% reperformed - dual loop
% test_22 = ["GFM_8Jun_Dual/GFL_8Jun_Nominal", "K_p = 0.0028, K_i = 0.8685"];
test_23 = ["SimplusData/GFMD_Nominal",                  "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = ( 0.028,  8.685, 1.22, 957)"];
test_24 = ["SimplusData/GFMD_SlowVoltage",              "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = (0.0028, 0.8685, 1.22, 957)"];
test_25 = ["SimplusData/GFMD_SlowCurrent",              "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = ( 0.028,  8.685, 0.61, 240)"];
test_26 = ["SimplusData/GFMD_SlowerCurrent",            "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = ( 0.028,  8.685, 0.61, 60)"];
test_27 = ["SimplusData/GFMD_SlowestCurrent",           "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = ( 0.028,  8.685, 0.31, 60)"];
test_28 = ["SimplusData/GFMD_SlowestCurrentStabilised", "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = ( 0.028,  8.685, 0.31, 240)"];
% test_29 = ["SimplusData/GFMD_FastVoltage",              "(K_{pv}, K_{iv}, K_{pi}, K_{ii}) = (  0.28,  8.685, 0.61, 240)"];



sim_dual = ["SimData/GFMD_Nominal_Sim", "K_p = 0.028, K_i = 8.685 Simulation"];
sim_dual_slow = ["SimData/GFM_Dual_Sim_12Jun_04_078e-6", "K_p = 0.04, K_i = 8.8685 \times 10{-5} Sim"];

selected = [test_23; test_24; test_25];

%% EDIT: Restrict scope timescale

%{
    10kHz operation (10k samples per second.)

    Total test is 21s
    0s : Initialise

    Vd perturb - Observe I, V, P
    3s : Step up vd ref from 12 to 15
    6s: Step down vd ref from 15 to 12

    Vq Perturbation - Observe I, V, P
    9s: Step up Vq ref from 0 to 5
    12s: Step down Vq ref from 5 to 0

    Frequency Perturbation - Observe I, V, P
    15s: Step up freq ref from 50 to 52
    18s: Step down freq ref from 52 to 50

    21s: End test 

    Edit section accordingly
    1) time of perturbations
    2) add test file names and test functions (displayed in legend)
    3) select entries to be displayed
%}

sample_rate = 10e3;
t_vd_start = 2.9 * sample_rate;
t_vd_end = 3.9 * sample_rate;
t_vq_start = 8.9 * sample_rate;
t_vq_end = 9.6 * sample_rate;
t_freq_start = 14.9 * sample_rate;
t_freq_end = 15.2 * sample_rate;

%% Select files

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

     %% Load scopes and signals
     if (selected(i,:) == sim_single) | (selected(i,:) == sim_dual)
        time_all  = out.GFMData.time; 
        vcd_all   = out.GFMData.signals(1).values;
        vcq_all   = out.GFMData.signals(2).values;
        ild_all   = out.GFMData.signals(3).values;
        ilq_all   = out.GFMData.signals(4).values;
        freq_all  = out.GFMData.signals(5).values;
        p_all     = out.GFMData.signals(7).values;
        q_all     = out.GFMData.signals(8).values;

        j = 1;
        sim_time = 4000000; % 6 seconds. originally 21 seconds.
        sim_time_scaled = sim_time/100;
        time = zeros(sim_time_scaled,1);
        vcd_scope  = zeros(sim_time_scaled,3);
        vcq_scope  = zeros(sim_time_scaled,3);
        ild_scope  = zeros(sim_time_scaled,2);
        ilq_scope  = zeros(sim_time_scaled,2);
        freq_scope = zeros(sim_time_scaled,1);
        p_scope    = zeros(sim_time_scaled,1);
        q_scope    = zeros(sim_time_scaled,1);
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
        vcd_ref  = vcd_scope(:,3);
        vcq      = vcq_scope(:,1);
        vcq_ref  = vcq_scope(:,3);
        ild      = ild_scope(:,1);
        ild_ref  = ild_scope(:,2);
        ilq      = ilq_scope(:,1);
        ilq_ref  = ilq_scope(:,2);
        freq     = freq_scope(:,1);
        p        = p_scope(:,1);
        q        = q_scope(:,1);
    else
        time = GFM_Data.time;

        % Load scopes
        vcd_scope   = GFM_Data.signals(1);
        vcq_scope   = GFM_Data.signals(2);
        ild_scope   = GFM_Data.signals(3);
        ilq_scope   = GFM_Data.signals(4);
        freq_scope  = GFM_Data.signals(5);
        % theta_scope = GFM_Data.signals(6);
        p_scope     = GFM_Data.signals(7);
        q_scope     = GFM_Data.signals(8);
        vcabc_scope = GFM_Data.signals(11);
        ilabc_scope = GFM_Data.signals(12);

        % Load signals
        vcd      = vcd_scope.values(:,1);
        vcd_ref  = vcd_scope.values(:,2);
        vcq      = vcq_scope.values(:,1);
        vcq_ref  = vcq_scope.values(:,2);
        ild      = ild_scope.values(:,1);
        ild_ref  = ild_scope.values(:,2);
        ilq      = ilq_scope.values(:,1);
        ilq_ref  = ilq_scope.values(:,2);
        freq     = freq_scope.values(:,1);
        % theta    = theta_scope.values(:,1);
        p        = p_scope.values(:,1);
        q        = q_scope.values(:,1);
    end

    %% Vd Perturbation

    t_vd_perturb      (:,i) = time(t_vd_start:t_vd_end);
    p_vd_perturb      (:,i) = p(t_vd_start: t_vd_end); 
    ild_vd_perturb    (:,i) = ild(t_vd_start: t_vd_end);
    ild_ref_vd_perturb(:,i) = ild_ref(t_vd_start: t_vd_end);
    ilq_vd_perturb    (:,i) = ilq(t_vd_start: t_vd_end);
    ilq_ref_vd_perturb(:,i) = ilq_ref(t_vd_start: t_vd_end);
    vcd_vd_perturb    (:,i) = vcd(t_vd_start: t_vd_end);
    vcd_ref_vd_perturb(:,i) = vcd_ref(t_vd_start: t_vd_end);
    vcq_vd_perturb    (:,i) = vcq(t_vd_start: t_vd_end);
    vcq_ref_vd_perturb(:,i) = vcq_ref(t_vd_start: t_vd_end);

%    %% Vq Perturbation
%
%     t_vq_perturb      (:,i) = time(t_vq_start:t_vq_end);
%     p_vq_perturb      (:,i) = p(t_vq_start:t_vq_end);
%     ild_vq_perturb    (:,i) = ild(t_vq_start:t_vq_end);
%     ild_ref_vq_perturb(:,i) = ild_ref(t_vq_start:t_vq_end);
%     ilq_vq_perturb    (:,i) = ilq(t_vq_start:t_vq_end);
%     ilq_ref_vq_perturb(:,i) = ilq_ref(t_vq_start:t_vq_end);
%     vcd_vq_perturb    (:,i) = vcd(t_vq_start:t_vq_end);
%     vcd_ref_vq_perturb(:,i) = vcd_ref(t_vq_start:t_vq_end);
%     vcq_vq_perturb    (:,i) = vcq(t_vq_start:t_vq_end);
%     vcq_ref_vq_perturb(:,i) = vcq_ref(t_vq_start:t_vq_end);
% 
%     %% Freq Perturbation
% 
%     t_freq_perturb       (:,i) = time(t_freq_start:t_freq_end);
%     p_freq_perturb       (:,i) = p(t_freq_start:t_freq_end);
%     freq_freq_perturb    (:,i) = freq(t_freq_start:t_freq_end);
%     ild_freq_perturb     (:,i) = ild(t_freq_start:t_freq_end);
%     ild_ref_freq_perturb (:,i) = ild_ref(t_freq_start:t_freq_end);
%     ilq_freq_perturb     (:,i) = ilq(t_freq_start:t_freq_end);
%     ilq_ref_freq_perturb (:,i) = ilq_ref(t_freq_start:t_freq_end);
%     vcd_freq_perturb     (:,i) = vcd(t_freq_start:t_freq_end);
%     vcd_ref_freq_perturb (:,i) = vcd_ref(t_freq_start:t_freq_end);
%     vcq_freq_perturb     (:,i) = vcq(t_freq_start:t_freq_end);
%     vcq_ref_freq_perturb (:,i) = vcq_ref(t_freq_start:t_freq_end);
    

end

%% Graph Plotting

%% Vd Perturb

figure(1);
plotwithstyle(t_vd_perturb(:,1), p_vd_perturb); hold on;
ylabel('P (W)');
xlabel('t (s)');
legend([legend_list], 'Location','Southeast');
xlim([t_vd_start t_vd_end]/sample_rate);


figure(2);
plotcurrentwithstyle(t_vd_perturb(:,1), ild_vd_perturb, ilq_vd_perturb);
ylabel('i_L (A)');
xlabel('t (s)');
legend([concat_legend("i_d", legend_list), concat_legend("i_q", legend_list)], 'Location','East');
xlim([t_vd_start t_vd_end]/sample_rate);
exportgraphics(gcf,'gfm_vdperturb_il.eps','BackgroundColor','none','ContentType','vector')

figure(3);
plotcurrentwithstyle(t_vd_perturb(:,1), vcd_vd_perturb, vcq_vd_perturb);
ylabel('V_c (V)');
xlabel('t (s)');
legend([concat_legend("V_d", legend_list), concat_legend("V_q", legend_list)], 'Location','East');
xlim([t_vd_start t_vd_end]/sample_rate);
exportgraphics(gcf,'gfm_vdperturb_v.eps','BackgroundColor','none','ContentType','vector')

% %% Vq Perturb
% 
% figure(4);
% plotwithstyle(t_vq_perturb(:,1), p_vq_perturb); hold on;
% ylabel('P (W)');
% xlabel('t (s)');
% legend(legend_list, 'Location','Northwest');
% xlim([t_vq_start t_vq_end]/sample_rate);
% 
% figure(5);
% plotcurrentwithstyle(t_vq_perturb(:,1), ild_vq_perturb, ilq_vq_perturb);
% ylabel('i_L (A)');
% xlabel('t (s)');
% legend([concat_legend("i_d", legend_list), concat_legend("i_q", legend_list)], 'Location','West');
% xlim([t_vq_start t_vq_end]/sample_rate);
% exportgraphics(gcf,'gfm_vqperturb_il.eps','BackgroundColor','none','ContentType','vector')
% 
% figure(6);
% plotcurrentwithstyle(t_vq_perturb(:,1), vcd_vq_perturb, vcq_vq_perturb);
% ylabel('V_c (V)');
% xlabel('t (s)');
% legend([concat_legend("V_d", legend_list), concat_legend("V_q", legend_list)], 'Location','East');
% xlim([t_vq_start t_vq_end]/sample_rate);
% exportgraphics(gcf,'gfm_vqperturb_v.eps','BackgroundColor','none','ContentType','vector')


% %% Freq

% figure(7);
% plotwithstyle(t_freq_perturb(:,1), p_freq_perturb); hold on;
% ylabel('P (W)');
% xlabel('t (s)');
% legend(legend_list, 'Location','Southeast');
% xlim([t_freq_start t_freq_end]/sample_rate);
% 
% figure(8);
% plotcurrentwithstyle(t_freq_perturb(:,1), ild_freq_perturb, ilq_freq_perturb);
% ylabel('i_L (A)');
% xlabel('t (s)');
% legend([concat_legend("i_d", legend_list), concat_legend("i_q", legend_list),], 'Location','Southeast');
% xlim([t_freq_start t_freq_end]/sample_rate);
% 
% figure(9);
% plotcurrentwithstyle(t_freq_perturb(:,1), vcd_freq_perturb, vcq_freq_perturb);
% ylabel('V_c (V)');
% xlabel('t (s)');
% legend([concat_legend("V_d", legend_list), concat_legend("V_q", legend_list)]);
% xlim([t_freq_start t_freq_end]/sample_rate);


%{
 figure(10);
plotwithstyle(t_freq_perturb(:,1), freq_freq_perturb); hold on;
ylabel('f (Hz)');
xlabel('t (s)');
legend([legend_list], 'Location','Southeast');
xlim([t_freq_start t_freq_end]/sample_rate); 
%}
