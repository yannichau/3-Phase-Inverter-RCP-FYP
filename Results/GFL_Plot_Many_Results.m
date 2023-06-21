clc; clf; clear all; close all; 

set(gcf,'renderer','Painters');

%%%%%%%% GRID FOLLOWING %%%%%%%%

%% EDIT THIS SECTION ONLY

%{
    10kHz operation (10k samples per second.)

    Total test is 35s
    0s : Initialise

    Perturbation
    5s : Step up power ref from 10 to 15W
    10s: Step down power ref from 15 to 10W

    Amplitude Perturbation
    15s: Step up amplitude ref from 0.3 to 0.4
    20s: Step down amplitude ref from 0.4 to 0.3

    Frequency Perturbation
    25s: Step up freq ref from 50 to 52
    30s: Step down freq ref from 52 to 50

    35s: End test

    Edit section accordingly
    1) time of perturbations
    2) add test file names and test functions (displayed in legend)
    3) select entries to be displayed
%}

sample_rate = 10e3;
t_power_up_start = 4.9 * sample_rate;
t_power_up_end = 5.2 * sample_rate;
t_amp_up_start = 14.9 * sample_rate;
t_amp_up_end = 15.2 * sample_rate;
t_freq_up_start = 24.9 * sample_rate;
t_freq_up_end = 25.2 * sample_rate;

%%  comparison tests
test_12 = ["SimplusData/GFL_12Jun_NominalControllerValues", "K_p = 0.61, K_i = 240"];
test_12_compare = ["SimplusData/GFL_12Jun_NominalControllerValues", "Hardware"];
test_13 = ["SimplusData/GFL_13Jun_Slow", "K_p = 0.31, K_i = 240"];
test_14 = ["SimplusData/GFL_13Jun_UltraSlow", "K_p = 0.31, K_i = 480"];
test_15 = ["SimplusData/GFL_13Jun_Moderate", "K_p = 0.61, K_i = 480"];
test_16 = ["SimplusData/GFL_13Jun_Fast", "K_p = 1.22, K_i = 957"];
test_17 = ["SimplusData/GFL_13Jun_Ultrafast", "K_p = 2.44, K_i = 957"];

test_cap = ["SimData/GFL_LargeCap", "Large Capacitor"]; %simulation 061, 240 with 8.8uF capacitor
sim_test = ["SimData/GFL_Sim_061_240_fixed", "Simulation"];

% selected = [test_12; test_15; test_16];
selected = [test_cap; sim_test];

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
    if selected(i,:) == sim_test | selected(i,:) == test_cap
        time_all  = out.GFLData_Sim.time; 
        vcd_all   = out.GFLData_Sim.signals(1).values;
        vcq_all   = out.GFLData_Sim.signals(2).values;
        ild_all   = out.GFLData_Sim.signals(3).values;
        ilq_all   = out.GFLData_Sim.signals(4).values;
        freq_all  = out.GFLData_Sim.signals(5).values;
        p_all     = out.GFLData_Sim.signals(7).values;
        q_all     = out.GFLData_Sim.signals(8).values;

        j = 1;
        sim_time = 7000000 % 7 seconds. originally 35 seconds.
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
        ild      = ild_scope(:,1);
        ild_ref  = ild_scope(:,2);
        ilq      = ilq_scope(:,1);
        ilq_ref  = ilq_scope(:,2);
        freq     = freq_scope(:,1);
        freq_ref = freq_scope(:,2);
        p        = p_scope(:,1);
        p_ref    = p_scope(:,2);
        q        = q_scope(:,1);
        q_ref    = q_scope(:,2);
    else
        time = GFL_Test.time; 
        vcd_scope   = GFL_Test.signals(1);
        vcq_scope   = GFL_Test.signals(2);
        ild_scope   = GFL_Test.signals(3);
        ilq_scope   = GFL_Test.signals(4);
        freq_scope  = GFL_Test.signals(5);
        % theta_scope = GFL_Test.signals(6);
        p_scope     = GFL_Test.signals(7);
        q_scope     = GFL_Test.signals(8);
        % duty_scope  = GFL_Test.signals(9);
        vcabc_scope = GFL_Test.signals(11);
        ilabc_scope = GFL_Test.signals(12);

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
        freq_ref = freq_scope.values(:,2);
        % theta    = theta_scope.values(:,1);
        p        = p_scope.values(:,1);
        p_ref    = p_scope.values(:,2);
        q        = q_scope.values(:,1);
        q_ref    = q_scope.values(:,2);
        % duty_a   = duty_scope.values(:,1);
        % duty_b   = duty_scope.values(:,2);
        % duty_c   = duty_scope.values(:,3);
        % vc_a   = vcabc_scope.values(:,1);
        % vc_b   = vcabc_scope.values(:,2);
        % vc_c   = vcabc_scope.values(:,3);
    end

    %% Power Perturbation

    t_power_perturb      (:,i) = time(t_power_up_start:t_power_up_end);
    p_power_perturb      (:,i) = p(t_power_up_start: t_power_up_end); 
    p_ref_power_perturb  (:,i) = p_ref(t_power_up_start: t_power_up_end);
    q_power_perturb      (:,i) = q(t_power_up_start: t_power_up_end); 
    q_ref_power_perturb  (:,i) = q_ref(t_power_up_start: t_power_up_end);
    ild_power_perturb    (:,i) = ild(t_power_up_start: t_power_up_end);
    ild_ref_power_perturb(:,i) = ild_ref(t_power_up_start: t_power_up_end);
    ilq_power_perturb    (:,i) = ilq(t_power_up_start: t_power_up_end);
    ilq_ref_power_perturb(:,i) = ilq_ref(t_power_up_start: t_power_up_end);

    

%     %% Amp Perturbation
% 
%     t_amp_perturb      (:,i) = time(t_amp_up_start:t_amp_up_end);
%     p_amp_perturb      (:,i) = p(t_amp_up_start:t_amp_up_end);
%     p_ref_amp_perturb  (:,i) = p_ref(t_amp_up_start:t_amp_up_end);
%     ild_amp_perturb    (:,i) = ild(t_amp_up_start:t_amp_up_end);
%     ild_ref_amp_perturb(:,i) = ild_ref(t_amp_up_start:t_amp_up_end);
%     ilq_amp_perturb    (:,i) = ilq(t_amp_up_start:t_amp_up_end);
%     ilq_ref_amp_perturb(:,i) = ilq_ref(t_amp_up_start:t_amp_up_end);
% 
%     %% Freq Perturbation
% 
%     t_freq_perturb       (:,i) = time(t_freq_up_start:t_freq_up_end);
%     p_freq_perturb       (:,i) = p(t_freq_up_start:t_freq_up_end);
%     p_ref_freq_perturb   (:,i) = p_ref(t_freq_up_start:t_freq_up_end);
%     ild_freq_perturb     (:,i) = ild(t_freq_up_start:t_freq_up_end);
%     ild_ref_freq_perturb (:,i) = ild_ref(t_freq_up_start:t_freq_up_end);
%     ilq_freq_perturb     (:,i) = ilq(t_freq_up_start:t_freq_up_end);
%     ilq_ref_freq_perturb (:,i) = ilq_ref(t_freq_up_start:t_freq_up_end);
%     freq_freq_perturb    (:,i) = freq(t_freq_up_start:t_freq_up_end);
%     freq_ref_freq_perturb(:,i) = freq_ref(t_freq_up_start:t_freq_up_end); 



end

%% Graph Plotting

figure(1);
plot(t_power_perturb(:,1), p_ref_power_perturb(:,1), 'k'); hold on;
plotwithstyle(t_power_perturb(:,1), p_power_perturb); hold on;
ylabel('P (W)');
xlabel('t (s)');
legend(["Reference", legend_list], 'Location','Southeast');
xlim([t_power_up_start t_power_up_end]/sample_rate);

figure(3);
plot(t_power_perturb(:,1), q_ref_power_perturb(:,1), 'k'); hold on;
plotwithstyle(t_power_perturb(:,1), q_power_perturb); hold on;
ylabel('Q (VA)');
xlabel('t (s)');
legend(["Reference", legend_list], 'Location','Southeast');
xlim([t_power_up_start t_power_up_end]/sample_rate);


figure(2);
% plot(t_power_perturb(:,1), ild_ref_power_perturb(:,end)); hold on;
% plot(t_power_perturb(:,1), ilq_ref_power_perturb(:,end)); hold on;
% Current reference is not helpful as they oscillate with voltage
plotcurrentwithstyle(t_power_perturb(:,1), ild_power_perturb, ilq_power_perturb);
ylabel('i_L (A)');
xlabel('t (s)');
legend([concat_legend("i_d:", legend_list), concat_legend("i_q:", legend_list)], 'Location','East');
xlim([t_power_up_start t_power_up_end]/sample_rate);


%%


%{
 figure(4);
plotwithstyle(t_amp_perturb(:,1), p_amp_perturb); hold on;
% plot(t_amp_perturb(:,1), p_ref_amp_perturb); hold on; % no need for P*
ylabel('P (W)');
xlabel('t (s)');
legend(legend_list);
xlim([t_amp_up_start t_amp_up_end]/sample_rate);
% exportgraphics(gcf,'amp_perturb_p.eps','BackgroundColor','none','ContentType','vector')


figure(5);
plotcurrentwithstyle(t_amp_perturb(:,1), ild_amp_perturb, ilq_amp_perturb);
ylabel('i_L (A)');
xlabel('t (s)');
legend([concat_legend("i_d", legend_list), concat_legend("i_q", legend_list)]);
xlim([t_amp_up_start t_amp_up_end]/sample_rate);
exportgraphics(gcf,'amp_perturb_il.eps','BackgroundColor','none','ContentType','vector')

%%

figure(7);
plotwithstyle(t_freq_perturb(:,1), p_freq_perturb); hold on;
% plot(t_freq_perturb(:,1), p_ref_freq_perturb); hold on; no need for P*
ylabel('P (W)');
xlabel('t (s)');
legend(legend_list, 'Location','Southeast');
xlim([t_freq_up_start t_freq_up_end]/sample_rate);

figure(8);
plotcurrentwithstyle(t_freq_perturb(:,1), ild_freq_perturb, ilq_freq_perturb);
ylabel('i_L (A)');
xlabel('t (s)');
legend([concat_legend("i_d", legend_list), concat_legend("i_q", legend_list),], 'Location','Southeast');
xlim([t_freq_up_start t_freq_up_end]/sample_rate);
exportgraphics(gcf,'freq_perturb_il.eps','BackgroundColor','none','ContentType','vector')

figure(10);
plot(t_freq_perturb(:,1), freq_ref_freq_perturb(:,1), 'k'); hold on;
plotwithstyle(t_freq_perturb(:,1), freq_freq_perturb); hold on;
ylabel('f (Hz)');
xlabel('t (s)');
legend(["Reference", legend_list], 'Location','Southeast');
xlim([t_freq_up_start t_freq_up_end]/sample_rate);
exportgraphics(gcf,'freq_perturb_f.eps','BackgroundColor','none','ContentType','vector') 
%}


%% 

% load("GFL_31May_ModeratePLL");
% vcabc = GFL_Test.signals(11).values;
% vcabc_amp_perturb = vcabc(t_amp_up_start:t_amp_up_end,:);
% figure(11);
% plotwithstyle(t_amp_perturb(:,1), vcabc_amp_perturb); hold on;
% ylabel('V_C (V)');
% xlabel('t (s)');
% legend(legend_list);
% xlim([t_amp_up_start t_amp_up_end]/sample_rate);