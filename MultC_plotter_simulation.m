
load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_test_20130815_063450.mat');
load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_CN_general_20130815_063452.mat');
load('/home/eric/nerf_verilog_eric/source/py/multC_tester/rack_emg_20130815_063455.mat');

[r, c]=size(mixed_input)
t = 1:1:r;
%% process EMG


Fe=400; %Samling frequency
Fc_low=50; % Cut-off frequency
Fc_high=1;
N=2; % Filter Order
[B, A] = butter(N,Fc_low*2/Fe, 'low'); %filter's parameters
[D, C] = butter(N,Fc_high*2/Fe, 'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high=filtfilt(C, D, f_emg); %in the case of Off-line treatment
f_rec_emg = abs(EMG_high);  % rectify
EMG_low=filtfilt(B, A, f_rec_emg); %in the case of Off-line treatment


% subplot(2, 1, 1);
%t= data_bic(:,1);
%% three boards
plot(t, mixed_input*300, t, Ia_spindle0, t, spike_count_Ia_normal, t,spike_count_II_normal-100,  t, f_emg*100-400, t, EMG_low*200-2000, t, spike_count_CN_neuron0-200, t, total_spike_count_sync-300, t, total_force);
legend('length', 'Ia__spindle', 'spkcnt__Ia', 'spkcnt__II', 'emg__MN', 'RECT__EMG', 'spkcnt__CN', 'spkcnt__total__MNs', 'total__force');
title( ['threeboards__normal, stretch_from 0.8 to 1.4, syn_SN_Ia_gain: 2.0, syn_SN_II_gain: 1.5, syn_CN_gain:50 ', num2str(date),  datestr(now, '  HH:MM:SS')]);
%% two boards
% plot(t, mixed_input*300, t, Ia_spindle0, t, spike_count_Ia_normal, t,spike_count_II_normal-100,  t, f_emg*100-400, t, f_rec_emg*100-900, t, total_spike_count_sync-300, t, total_force);
% legend('length', 'Ia__spindle', 'spkcnt__Ia', 'spkcnt__II', 'emg__MN', 'RECT__EMG', 'spkcnt__total__MNs', 'total__force');
% title( ['twoboards__normal, stretch_from 0.8 to 1.4 ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% 

% subplot(2, 1, 2);
%t= data_tri(:,1);
%plot(t, data_tri(:,2)*3000, t, data_tri(:,4), t, data_tri(:,5)*50, t, data_tri(:,6)*100-1000);
