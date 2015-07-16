
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

for k = 1:2
  %% process EMG

  if k==1
      fname1 = sprintf('rack_test_20131009_174040');  
      fname1_emg = sprintf('rack_emg_20131009_174042');  
      load([fname1, '.mat']); 
      load([fname1_emg, '.mat']); 
  elseif (k==2)
      fname2 = sprintf('rack_test_20131009_172538'); 
      fname2_emg = sprintf('rack_emg_20131009_172540'); 
      load([fname2, '.mat']);
      load([fname2_emg, '.mat']);
  end
% fname1 = sprintf('rack_test_20131009_174040');% HI_GAIN(normal): 1, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_174041');
% fname3 = sprintf('rack_emg_20131009_174042');

% fname1 = sprintf('rack_test_20131009_172538');  % HI_GAION: 8, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_172539');
% fname3 = sprintf('rack_emg_20131009_172540');



%% three boards
[r, c]=size(mixed_input)
t = 1:1:r;
  
n = 2;
start =1000;
%start = 1250;
% last =12800;
% last = 1700
offset =-310; %150; %480;
% last = min(length(t), 40000); 

last = 2700;

t_bic= t;
length_bic = mixed_input;
f_emg_bic = f_emg;

    
if (k == 1)
    t_bic_cut= t(start:last);

    length_bic_cut = mixed_input(start:last);

    f_emg_bic_cut = f_emg(start:last);

  

else
    start = start + offset;
    last = last + offset;
    t_bic= t(start:last);
    length_bic_offset = mixed_input(start:last);
    f_emg_bic_offset = f_emg(start:last);

end


% last = min(length(t_bic), 1000); %2050


[pks,high_locs] = findpeaks(length_bic)
length_bic_inverted = -length_bic;
[~,low_locs] = findpeaks(length_bic_inverted)



%% EMG processing
% Fe=33; %Samling frequency
Fe = 145;
Fc_lpf=2.5; % Cut-off frequency
Fc_hpf=1.0;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic_cut=filtfilt(D, C, f_emg_bic_cut); %in the case of Off-line treatment
f_rec_emg_bic_cut = abs(EMG_high_bic_cut);  % rectify
EMG_bic_cut=filtfilt(B, A, f_rec_emg_bic_cut); %in the case of Off-line treatment

% 
% figure;
% [z,p,k] = butter(N,Fc_lpf*2/Fe,'low');
% % [z,p,k]= butter(N,Fc_hpf*2/Fe,'high')
% [sos,g] = zp2sos(z,p,k);      % Convert to SOS form
% Hd = dfilt.df2tsos(sos,g);   % Create a dfilt object
% h = fvtool(Hd);              % Plot magnitude response
% set(h,'Analysis','freq')      % Display frequency response 


%%% off set data
if (k ==2) 
    EMG_high_bic_offset=filtfilt(D, C, f_emg_bic_offset); %in the case of Off-line treatment
    f_rec_emg_bic_offset = abs(EMG_high_bic_offset);  % rectify
    EMG_bic_offset=filtfilt(B, A, f_rec_emg_bic_offset); %in the case of Off-line treatment

 
end



hfig = figure(1);
n=3;
subplot(n, 1, 1);


if (k == 2)
    plot(t_bic_cut, length_bic_offset,'-', 'LineWidth',2, 'color', 'red');
else
     plot(t_bic_cut, length_bic_cut, 'LineWidth',2, 'color', 'black');    
%     [pks, locs] = findpeaks(length_bic_cut);
  hold on
  

end
ylim([0.7 1.4])
% legend('biceps length');
% grid on
axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_bic_cut, f_emg_bic_offset, '-', 'LineWidth',2, 'color', 'red');
else     
      plot(t_bic_cut, f_emg_bic_cut, 'LineWidth',2, 'color', 'black');
end
% legend('full wave rect biceps emg');
% grid on
% ylim([-0.5 3.5]);
axis off
% hold on
grid on

 % legend('force bicpes');
% grid on
axis off
hold on
grid on


end


%%  

  