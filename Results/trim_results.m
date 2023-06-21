clc; clf; close all; clear all; 

load('SimData\GFM_Single_Sim.mat')

%%

GFM_Data = out.GFMData;

%%
vcd_scope   = GFM_Data.signals(1).values;
vcq_scope   = GFM_Data.signals(2).values;
ild_scope   = GFM_Data.signals(3).values;
ilq_scope   = GFM_Data.signals(4).values;
freq_scope  = GFM_Data.signals(5).values;
vcabc_scope = GFM_Data.signals(11).values;
ilabc_scope = GFM_Data.signals(12).values;

%%

time = GFM_Data.time;
j = 1;
for i=1:100:24000000
    time_trimmed(j,:) = time(i,:);
    vcd_trimmed(j,:) = vcd_scope(i,:);
    vcq_trimmed(j,:) = vcq_scope(i,:);
    ild_trimmed(j,:) = ild_scope(i,:);
    ilq_trimmed(j,:) = ilq_scope(i,:);
    freq_trimmed(j,:) = freq_scope(i,:);
    j = j+1;
end
