    clc; clear;close all;
load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130805_175847.mat');

%% process EMG

f_emg_bic = data_bic(:,6);
f_emg_tri = data_tri(:,6);
force_bic = data_bic(:,5);
force_tri = data_tri(:,5);

Fe=150; %Samling frequency
Fc_lpf=20.0; % Cut-off frequency
Fc_hpf=1;
N=2; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic=filtfilt(D, C, f_emg_bic); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

EMG_high_tri=filtfilt(D, C, f_emg_tri); %in the case of Off-line treatment
f_rec_emg_tri = abs(EMG_high_tri);  % rectify
EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment

%%
n=6;

subplot(n, 1, 1);
t= data_bic(:,1);
plot(t, data_bic(:,2), 'LineWidth',2);
ylim([0.7 1.3])
legend('biceps length');
% grid on

subplot(n, 1, 2);
plot( t, f_emg_bic);
legend('full wave rect biceps emg');
% grid on
%ylim([-0.5 3.5]);

subplot(n, 1, 3);
plot(t, force_bic, 'r', 'LineWidth',2);
legend('force bicpes');
% grid on


subplot(n, 1, 4);
t= data_tri(:,1);
plot(t, data_tri(:,2),'LineWidth',2);
legend('triceps length');
ylim([0.7 1.3])
% grid on

subplot(n, 1, 5);
plot(t, f_emg_tri);
legend('full wave rect triceps emg');
% grid on
%ylim([-0.5 3.5]);
% ylim([0 40])


subplot(n, 1, 6);
plot(t, force_tri, 'r', 'LineWidth',2);
legend('force triceps');
% grid on


% ylim([-2000 4000])
% subplot(3, 1, 3);
% endtime = 2600; 
% plot(t(1:endtime),  data_bic(1:endtime,5)-data_tri(1:endtime,5));
% legend('diff in force');
% grid on
title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1: 0, CNsynGain=50.0, extraCN2: 15000*sin(t)   ', num2str(date),  datestr(now, '  HH:MM:SS')]);
%title( ['pymunk setting, IaGain=1.5, IIGain=1.5, extraCN1:120000, extraCN2: 80000*sin(t) ', num2str(date),  datestr(now, '  HH:MM:SS')]);
%title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1:50000, extraCN2: 40000*sin(t)', num2str(date),  datestr(now, '  HH:MM:SS')]);



%% filter exploration
% ** Ap — amount of ripple allowed in the pass band in decibels (the default units). Also called Apass.
% ** Ast — attenuation in the stop band in decibels (the default units). Also called Astop.
% ** F3db — cutoff frequency for the point 3 dB point below the passband value. Specified in normalized frequency units.
% ** Fc — cutoff frequency for the point 6 dB point below the passband value. Specified in normalized frequency units.
% ** Fp — frequency at the start of the pass band. Specified in normalized frequency units. Also called Fpass.
% ** Fst — frequency at the end of the stop band. Specified in normalized frequency units. Also called Fstop.
% ** N — filter order.
% 
% 
% plot(t(1:100), f_emg_bic(1:100));
% figure
% 
% d=fdesign.highpass('N,Fc',5, 1,400);
% %designmethods(d)
% Hd = design(d);
% % fvtool(Hd);
% % d=design(h,'equiripple'); %Lowpass FIR filter
% %y=filtfilt(Hd,f_emg_bic ); %zero-phase filtering
% y1=filter(Hd,f_emg_bic); %conventional filtering
% 
% 
% plot(t(1:100), y1(1:100));
% title('Filtered Waveforms');
% figure;
% rect_y1 = abs(y1);
% plot(t(1:100), rect_y1(1:100));
% figure;
%  
% %d=fdesign.lowpass('Fp,Fst,Ap,Ast',0.15,0.25,1,60);
% d=fdesign.lowpass('N,Fc',3, 3, 400);
% designmethods(d)
% Hd = design(d);
% y2=filter(Hd, rect_y1); %conventional filtering
% plot(t(1:100), y2(1:100));
% fvtool(Hd);
% 

% y=filtfilt(d.Numerator,1, f_emg_bic); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_bic); %conventional filtering


