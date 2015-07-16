
close all;
%      clc; clear;close all;
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk


% cursor_info = sprintf('cursor_info_20130920_150701');  % scaler 20130829_114414
% load([cursor_info, '.mat']); 



fname2 = sprintf('rack_test_20131011_140238'); 
fname2_emg = sprintf('rack_emg_20131011_140239'); 
load([fname2, '.mat']);
load([fname2_emg, '.mat']);

%%
% fname1 = sprintf('rack_test_20131011_135734');% HI_GAIN: 1, half_cnt 76000  (S1M1)
% fname2 = sprintf('rack_CN_simple_S1M1_20131011_135735');
% fname3 = sprintf('rack_emg_20131011_135736');

% fname1 = sprintf('rack_test_20131011_140238');% HI_GAIN: 8, half_cnt 76000  (S1M1)
% fname2 = sprintf('rack_CN_simple_S1M1_20131011_140238');
% fname3 = sprintf('rack_emg_20131011_140239');

%%
% fname1 = sprintf('rack_test_20131009_174040');% HI_GAIN(normal): 1, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_174041');
% fname3 = sprintf('rack_emg_20131009_174042');

% fname1 = sprintf('rack_test_20131009_173034'); % HI_GAIN(normal): 1, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_173112');
% fname3 = sprintf('rack_emg_20131009_173115');


% fname1 = sprintf('rack_test_20131009_172538');  % HI_GAION: 8, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_172539');
% fname3 = sprintf('rack_emg_20131009_172540');

% fname1 = sprintf('rack_test_20131009_174455');% HI_GAIN: 8, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_174456');
% fname3 = sprintf('rack_emg_20131009_174457');


%% three boards
[r, c]=size(mixed_input)
t = 1:1:r;
 
n = 3;

offset =-310; %150; %480;
% last = min(length(t), 40000); 

buffer = 200;
perturbation_length=718;
rising_point = 1632;
start=rising_point -buffer;    
last = start + perturbation_length + 2*buffer;

%% comment/ uncomment for setting offset

t_cut= t(start:last);
mixed_input_cut = mixed_input(start:last);
f_emg_cut = f_emg(start:last);
total_spike_count_sync_cut = total_spike_count_sync(start:last);
% t_cut = t;
% mixed_input_cut = mixed_input;
% f_emg_cut = f_emg;
% total_spike_count_sync_cut = total_spike_count_sync;

%% EMG processing
% Fe=33; %Samling frequency
Fe = 145;
Fc_lpf=2.5; % Cut-off frequency
Fc_hpf=1.0;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
% EMG_high_bic_cut=filtfilt(D, C, f_emg_bic_cut); %in the case of Off-line treatment
% f_rec_emg_bic_cut = abs(EMG_high_bic_cut);  % rectify
% EMG_bic_cut=filtfilt(B, A, f_rec_emg_bic_cut); %in the case of Off-line treatment
% figure;
% [z,p,k] = butter(N,Fc_lpf*2/Fe,'low');
% % [z,p,k]= butter(N,Fc_hpf*2/Fe,'high')
% [sos,g] = zp2sos(z,p,k);      % Convert to SOS form
% Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
% h = fvtool(Hd);              % Plot magnitude response
% set(h,'Analysis','freq')      % Display frequency response 
% 
 
% EMG_high_bic_offset=filtfilt(D, C, f_emg_bic_offset); %in the case of Off-line treatment
% f_rec_emg_bic_offset = abs(EMG_high_bic_offset);  % rectify
% EMG_bic_offset=filtfilt(B, A, f_rec_emg_bic_offset); %in the case of Off-line treatment


hfig = figure(1);
n=3;
subplot(n, 1, 1);

plot(t_cut, mixed_input_cut, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_bic_cut);

axis off

subplot(n, 1, 2); 
plot(t_cut, f_emg_cut, 'LineWidth',2, 'color', 'black');
axis off

subplot(n, 1, 3); 
plot(t_cut, total_spike_count_sync_cut, 'LineWidth',2, 'color', 'black');
axis off


save('gain8_rack.mat', 't_cut', 'mixed_input_cut', 'f_emg_cut', 'total_spike_count_sync_cut');

%%  

  