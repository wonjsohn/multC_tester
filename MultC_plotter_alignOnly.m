
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
      fname2 = sprintf('rack_test_20131009_174040'); 
      fname2_emg = sprintf('rack_emg_20131009_174042'); 
      load([fname2, '.mat']);
      load([fname2_emg, '.mat']);
  end
% fname1 = sprintf('rack_test_20131009_174040');% HI_GAIN(normal): 1, half_cnt 76000
% fname2 = sprintf('rack_CN_simple_general_20131009_174041');
% fname3 = sprintf('rack_emg_20131009_174042');


  % figure 4a: 20130824_174839,    20130824_174958  (DC-UP),  
  % figure 4b:  20130824_182344        20130824_182555 (HI_GAIN)
  
  % scaler 20130829_114414  (bigger gain? , cut)  |    % scaler 20130829_105922   (smaller gain?, offset)
  %  20130920_150701 : trial5 (DC-UP) - no input, phase: 44  (BASE)   
  %  20130920_173643 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:1  phase : 42, offset: 30
  %  20130920_151800 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:2  phase : 58, offset:-150
  %  20130920_174306 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:3  phase : 45, offset: -160
  %  20130920_172651 : trial5 (DC-UP) i_extra_CN1: 2000,  scaler:4  phase : 46, offset:-10

  %  20130920_175321 : trial4 (HI-GAIN) scaler:1  phase: 51   offset: -160
  %  20130920_175642 : trial4 (HI-GAIN) scaler:2  phase: 48   offset: -160
  %  20130920_175933 : trial4 (HI-GAIN) scaler:3  phase: 55   offset: -220 
  %  20130920_180341 : trial4 (HI-GAIN) scaler:4  phase: 60   offset: -220
  %  20130920_180714 : trial4 (HI-GAIN) scaler:5  phase: 67    offset: -70
  
  %  New BASE: 20130930_151314 (scaler:0)

  
  
  
n = 3;
start =400;
%start = 1250;
last =12800;
% last = 1700
offset =30; %150; %480;

t_bic= data_bic(:,1);
t_tri= data_tri(:,1);
length_bic = data_bic(:,2);
length_tri = data_tri(:,2);
vel_bic = data_bic(:,3);
vel_tri = data_tri(:,3);
f_emg_bic = data_bic(:,6);
f_emg_tri = data_tri(:,6);
force_bic = data_bic(:,5);
force_tri = data_tri(:,5);
    
if (k == 1)
    t_bic_cut= t_bic(start:last);
    t_tri_cut= t_tri(start:last);
    length_bic_cut = length_bic(start:last);
    length_tri_cut = length_tri(start:last);
    f_emg_bic_cut = f_emg_bic(start:last);
    f_emg_tri_cut = f_emg_tri(start:last);
    force_bic_cut = force_bic(start:last);
    force_tri_cut = force_tri(start:last);

else
    start = start + offset;
    last = last + offset;
%     t_bic= t_bic(start:last);
%     t_tri= t_tri(start:last);
    length_bic_offset = length_bic(start:last);
    length_tri_offset = length_tri(start:last);
    f_emg_bic_offset = f_emg_bic(start:last);
    f_emg_tri_offset = f_emg_tri(start:last);
    force_bic_offset = force_bic(start:last);
    force_tri_offset = force_tri(start:last);
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

EMG_high_tri_cut=filtfilt(D, C, f_emg_tri_cut); %in the case of Off-line treatment
f_rec_emg_tri_cut = abs(EMG_high_tri_cut);  % rectify
EMG_tri_cut=filtfilt(B, A, f_rec_emg_tri_cut); %in the case of Off-line treatment
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

    EMG_high_tri_offset=filtfilt(D, C, f_emg_tri_offset); %in the case of Off-line treatment
    f_rec_emg_tri_offset = abs(EMG_high_tri_offset);  % rectify
    EMG_tri_offset=filtfilt(B, A, f_rec_emg_tri_offset); %in the case of Off-line treatment
end



hfig = figure(1);
n=3;
subplot(n, 1, 1);


if (k == 2)
    plot(t_bic_cut, length_bic_offset,'-', 'LineWidth',2, 'color', 'black');
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
    plot(t_bic_cut, f_emg_bic_offset, '-', 'LineWidth',1, 'color', 'black');
else     
      plot(t_bic_cut, f_emg_bic_cut, 'LineWidth',1, 'color', 'black');
end
% legend('full wave rect biceps emg');
% grid on
% ylim([-0.5 3.5]);
axis off
% hold on
grid on

subplot(n, 1, 3);
if (k == 2)
    plot(t_bic_cut, force_bic_offset, '-', 'LineWidth',2, 'color', 'black');
else
     plot(t_bic_cut, force_bic_cut, 'LineWidth',2, 'color', 'black');
end
 % legend('force bicpes');
% grid on
axis off
hold on
grid on

%%
hfig2 = figure(2);
n=3;
subplot(n, 1, 1);

if (k == 2)
    plot(t_tri_cut,  length_tri_offset, '--', 'LineWidth',2, 'color', 'black');
else
    plot(t_tri_cut, length_tri_cut, 'LineWidth',2, 'color', 'black');
end
    % legend('triceps length');
ylim([0.7 1.3])
% grid on
axis off
hold on
grid on
% 
subplot(n, 1, 2);
if (k == 2)
    plot(t_tri_cut, f_emg_tri_offset, '-', 'LineWidth',2, 'color', 'black');
else    
    plot(t_tri_cut, f_emg_tri_cut, 'color', 'black');
end
% legend('full wave rect triceps emg');
% grid on
%ylim([-0.5 3.5]);
% ylim([0 40])
axis off
hold on
grid on
subplot(n, 1, 3);
if (k == 2)
    plot(t_tri_cut, force_tri_offset, '-', 'LineWidth',3, 'color', 'black');
else 
    plot(t_tri_cut, force_tri_cut, 'LineWidth',2, 'color', 'black');
end
% legend('force triceps');
% grid on
axis off
grid on
hold on
title('trial5, CN simple general, 20130824__174839/ 20130824__174958'); 
end


%%  

  