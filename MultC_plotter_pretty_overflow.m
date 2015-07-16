    % clc; clear;
    close all;
%   load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174406.mat');  %
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174627.mat');%
%  load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174801.mat');%
% load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_174912.mat');
%load('/home/eric/nerf_verilog_eric/projects/balance_limb_pymunk/20130808_175015.mat');
% cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk_minos
cd /home/eric/nerf_verilog_eric/projects/balance_limb_pymunk_overflow


d = dir('*.mat');
[x,y]=sort(datenum(char({d.date})));
most_recent_file=char(d(y(end)).name);   %rack_emg_2013xxx
% second_recent_file=char(d(y(end-1)).name);  %rack_test_2013xxx

% most_recent_file= '20131102_231735_OF30_healthy.mat';
load(most_recent_file);
% load(second_recent_file);
% 
% fname = sprintf('20131028_184722'); 
% 20131009_152401: base line (control) : 63 seconds
% 20131009_153808: HI-GAIN: 4*1=4
% 20131009_153455: TONIC: 2000*1 = 2000: 63 seconds

% load([fname, '.mat']);




%% process EMG
t_ind_flex= data_index_flexor(:,1);
t_ind_ext= data_index_extensor(:,1);
length_ind_flex = data_index_flexor(:,2);
length_ind_ext = data_index_extensor(:,2);
linearV_ind_flex = data_index_flexor(:,3);
linearV_ind_ext = data_index_extensor(:,3);
spikecnt_ind_flex = data_index_flexor(:,4);
spikecnt_ind_ext = data_index_extensor(:,4);
force_ind_flex = data_index_flexor(:,5);
force_ind_ext = data_index_extensor(:,5);
f_emg_ind_flex = data_index_flexor(:,6);
f_emg_ind_ext = data_index_extensor(:,6);
% timeindex_bic = data_index_flexor(:,7);
% timeindex_tri = data_index_extensor(:,7);
% timewave_bic = data_index_flexor(:,8);
% timewave_tri = data_index_extensor(:,8);
% timewaveFromFpga_bic = data_index_flexor(:,9);
% timewaveFromFpga_tri = data_index_extensor(:,9);

% MN1_spikes_bic = data_index_flexor(:,7);
% MN2_spikes_bic = data_index_flexor(:,8);
% MN3_spikes_bic = data_index_flexor(:,9);
% MN4_spikes_bic = data_index_flexor(:,10);
% MN5_spikes_bic = data_index_flexor(:,11);
% MN6_spikes_bic = data_index_flexor(:,12);

t_mid_flex= data_middle_flexor(:,1);
t_mid_ext= data_middle_extensor(:,1);
length_mid_flex = data_middle_flexor(:,2);
length_mid_ext = data_middle_extensor(:,2);
linearV_mid_flex = data_middle_flexor(:,3);
linearV_mid_ext = data_middle_extensor(:,3);
spikecnt_mid_flex = data_middle_flexor(:,4);
spikecnt_mid_ext = data_middle_extensor(:,4);
force_mid_flex = data_middle_flexor(:,5);
force_mid_ext = data_middle_extensor(:,5);
f_emg_mid_flex = data_middle_flexor(:,6);
f_emg_mid_ext = data_middle_extensor(:,6);


n = 4;
start =100;
%start = 1250;
ind_flex_last = min(length(t_ind_flex), 22000); 
ind_ext_last = min(length(t_ind_ext), 22000); 
mid_flex_last = min(length(t_mid_flex), 22000); 
mid_ext_last = min(length(t_mid_ext), 22000); 

% last =635;
% last = min(length(t_ind_flex), 1000); %2050
subplot(n, 1, 1);


[pks,high_locs] = findpeaks(length_ind_flex)
length_ind_flex_inverted = -length_ind_flex;
[~,low_locs] = findpeaks(length_ind_flex_inverted)

%% 


%% EMG processing
Fe=1024; %Samling frequency
Fc_lpf=450.0; % Cut-off frequency
Fc_hpf=0.5;
N=3; % Filter Order
[B, A] = butter(N,Fc_lpf*2/Fe,'low'); %filter's parameters
[D, C] = butter(N,Fc_hpf*2/Fe,'high'); %filter's parameters

% high pass -> rectify -> low pass
EMG_high_bic=filtfilt(D, C, f_emg_ind_flex); %in the case of Off-line treatment
f_rec_emg_bic = abs(EMG_high_bic);  % rectify
EMG_bic=filtfilt(B, A, f_rec_emg_bic); %in the case of Off-line treatment

EMG_high_tri=filtfilt(D, C, f_emg_ind_ext); %in the case of Off-line treatment
f_rec_emg_tri = abs(EMG_high_tri);  % rectify
EMG_tri=filtfilt(B, A, f_rec_emg_tri); %in the case of Off-line treatment
 
%%
figure_width  = 8*2;
figure_height = 6*2;
FontSize = 11*1.5;
FontName = 'MyriadPro-Regular';

Fe=33; %Samling frequency
Fc_lpf=1.0; % Cut-off frequency
Fc_hpf=0.5;
N=6; % Filter Ord
[B, A] = butter(N,1.0*2/Fe,'low'); %filter's parameters
length_ind_flex_lpf=filtfilt(B, A, length_ind_flex); %in the case of Off-line treatment

hold on
hfig  = figure(1); 

    set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 


% axis off;  
hLine1 = line(t_ind_flex(start:ind_flex_last), length_ind_flex_lpf(start:ind_flex_last));
% hdots_high = line(t_ind_flex(high_locs),length_ind_flex(high_locs));
% hdots_low = line(t_ind_flex(low_locs),length_ind_flex(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
set(gca,'YLim',[0.7 1.4])
hYLabel = ylabel('index flexor angle');

% hTitle  = title ('extra cortical drive scale: 7 ');
% hTitle  = title ('flexor muscle length. High Trascortical reflex gain: 3 ');

subplot (n,1, 2);
hLine2 = line(t_ind_flex(start:ind_flex_last), f_emg_ind_flex(start:ind_flex_last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
set(gca,'YLim',[-5 5])
hXLabel = xlabel('time (s)');
hYLabel = ylabel('ind flex');
% axis off;



subplot (n,1, 3);
hLine4 = line(t_ind_ext(start:ind_ext_last), f_emg_ind_ext(start:ind_ext_last));
set(hLine4                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
set(gca,'YLim',[-5 5])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('ind ext ');




subplot (n,1, 4);
hLine4 = line(t_ind_ext(start:ind_ext_last), force_ind_ext(start:ind_ext_last));
set(hLine4                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('force ');


%===================================

start =100;
%start = 1250;
last = min(length(t_mid_flex), 22000); 

Fe=33; %Samling frequency
Fc_lpf=1.0; % Cut-off frequency
Fc_hpf=0.5;
N=3; % Filter Ord
[B, A] = butter(N,1.0*2/Fe,'low'); %filter's parameters
length_mid_flex_lpf=filtfilt(B, A, length_mid_flex); %in the case of Off-line treatment


hfig2  = figure(2); 

    set(gcf, 'units', 'centimeters', 'pos', [0 0 figure_width figure_height])
    % set(gcf, 'Units', 'pixels', 'Position', [100 100 500 375]);
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'Color', [1 1 1]); % Sets figure background
    set(gca, 'Color', [1 1 1]); % Sets axes background
    set(gcf, 'Renderer', 'painters'); 


% axis off;  
subplot (n,1, 1);
hLine1 = line(t_mid_flex(start:last), length_mid_flex_lpf(start:last));
% hdots_high = line(t_mid_flex(high_locs),length_mid_flex(high_locs));
% hdots_low = line(t_mid_flex(low_locs),length_mid_flex(low_locs));
 
set(hLine1                        , ...
  'LineStyle'       , '-'        , ...
  'LineWidth'       , 3           , ... 
  'Color'           , 'black'  );
set(gca,'YLim',[0.7 1.4])
hYLabel = ylabel('middle flexor angle');

% hTitle  = title ('extra cortical drive scale: 7 ');
% hTitle  = title ('flexor muscle length. High Trascortical reflex gain: 3 ');

subplot (n,1, 2);
hLine2 = line(t_mid_flex(start:mid_flex_last), f_emg_mid_flex(start:mid_flex_last));
set(hLine2                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
set(gca,'YLim',[-5 5])

hXLabel = xlabel('time (s)');
hYLabel = ylabel('mid flex');

% axis off;
subplot (n,1, 3);
hLine4 = line(t_mid_ext(start:mid_ext_last), f_emg_mid_ext(start:mid_ext_last));
set(hLine4                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 1           , ...   
  'Color'           , 'black'  );
set(gca,'YLim',[-5 5])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('mid ext ');

subplot (n,1, 4);
hLine3 = line(t_mid_flex(start:mid_flex_last), force_mid_flex(start:mid_flex_last));
set(hLine3                        , ...
  'LineStyle'       , '-'         , ...
  'LineWidth'       , 3           , ...   
  'Color'           , 'black'  );
% set(gca,'YLim',[0 200])
% axis off;

hXLabel = xlabel('time (s)');
hYLabel = ylabel('middle flexor force');


% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_ind_flex)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_ind_flex(start:last), extraCN(start:last));
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])

% % %% velocity
% subplot (n,1, 4);
% hLine8 = line(t_ind_flex(start:last), vel_bic(start:last));
% set(hLine8                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');




% subplot (n,1, 4);
% 
% extraCN = transpose(ones(1, length(t_ind_ext)));
% extraCN(1600:last) = 7;
% hLine4 = line(t_ind_ext(start:last), extraCN(start:last));
% hYLabel  = ylabel('extra drive');
% 
% set(hLine4                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [.1 .4 .4]  );
% set(gca,'YLim',[0 10])
% 
% 



% 
% %% vel 
% subplot (n,1, 4);
% hLine9 = line(t_ind_ext(start:last), vel_tri(start:last));
% set(hLine9                        , ...
%   'LineStyle'       , '-'         , ...
%   'LineWidth'       , 2           , ...   
%   'Color'           , [0.5 0 0.5]  );
% % set(gca,'YLim',[0 200])
% % axis off;
% 
% hXLabel = xlabel('time (s)');
% hYLabel = ylabel('vel');


% % 
% hLegend = legend( ...
%   [hdots, hLine1, hLine2, hLine3], ...
%   'Data' , ...
%   'Model'    , ...  
%   'Fit'      , ...
%   'Validation Data'       , ...  
%   'location', 'Best' );
 
  %'Data (\mu \pm \sigma)' , ...
  %'Model (\it{C x^3})'    , ...  
  %'Fit (\it{C x^3})'      , ...
  

%% save figure
% print(hfig, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]));
% print(hfig2, '-dpng', (['figure' num2str(date),  datestr(now, '  HH:MM:SS')]));
% 
% fname = sprintf('myfile%d.mat', i);


% %% Raster plot
% MN1_spikeindex=[]; 
% MN2_spikeindex=[];
% MN3_spikeindex=[];
% MN4_spikeindex=[];
% MN5_spikeindex=[];
% MN6_spikeindex=[];
% 
% binaryMN1 = dec2bin(MN1_spikes_bic);
% binaryMN2 = dec2bin(MN2_spikes_bic);
% binaryMN3 = dec2bin(MN3_spikes_bic);
% binaryMN4 = dec2bin(MN4_spikes_bic);
% binaryMN5 = dec2bin(MN5_spikes_bic);
% binaryMN6 = dec2bin(MN6_spikes_bic);
% [r,c] = size(binaryMN1);  % 761, 32
% 
% 
% numofrow = 32;
% for i=1:r*numofrow,  % get two rows for each MN
%     if binaryMN1(i) =='1'
%         MN1_spikeindex = [MN1_spikeindex i]; 
%     end
%     if binaryMN2(i) =='1'
%         MN2_spikeindex = [MN2_spikeindex i]; 
%     end
%     if binaryMN3(i) =='1'
%         MN3_spikeindex = [MN3_spikeindex i]; 
%     end
%     if binaryMN4(i) =='1'
%         MN4_spikeindex = [MN4_spikeindex i]; 
%     end
%     if binaryMN5(i) =='1'
%         MN5_spikeindex = [MN5_spikeindex i]; 
%     end
% %     if binaryMN6(i) =='1'
% %         MN6_spikeindex = [MN6_spikeindex i]; 
% %     end
%     
% end
% 
% 
% allMN_raster = [MN1_spikeindex (r*numofrow*1)+MN2_spikeindex (r*numofrow*2)+MN3_spikeindex (r*numofrow*3)+MN4_spikeindex (r*numofrow*4)+MN5_spikeindex ];% (r*numofrow*5)+MN6_spikeindex];
% 
% 
% rasterplot(allMN_raster, numofrow*5, r);axis off    








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % n=6;
% % 
% % subplot(n, 1, 1);
% % t= data_index_flexor(:,1);
% % plot(t, data_index_flexor(:,2), 'LineWidth',2);
% % ylim([0.7 1.3])
% % legend('biceps length');
% % % grid on
% % 
% % subplot(n, 1, 2);
% % plot( t, f_emg_ind_flex);
% % legend('full wave rect biceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % 
% % subplot(n, 1, 3);
% % plot(t, force_ind_flex, 'r', 'LineWidth',2);
% % legend('force bicpes');
% % % grid on
% % 
% % 
% % subplot(n, 1, 4);
% % t= data_index_extensor(:,1);
% % plot(t, data_index_extensor(:,2),'LineWidth',2);
% % legend('triceps length');
% % ylim([0.7 1.3])
% % % grid on
% % 
% % subplot(n, 1, 5);
% % plot(t, f_emg_ind_ext);
% % legend('full wave rect triceps emg');
% % % grid on
% % %ylim([-0.5 3.5]);
% % % ylim([0 40])
% % 
% % 
% % subplot(n, 1, 6);
% % plot(t, force_ind_ext, 'r', 'LineWidth',2);
% % legend('force triceps');
% % % grid on


% % % ylim([-2000 4000])
% % % subplot(3, 1, 3);
% % % endtime = 2600; 
% % % plot(t(1:endtime),  data_index_flexor(1:endtime,5)-data_index_extensor(1:endtime,5));
% % % legend('diff in force');
% % % grid on
% % title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1: 0, CNsynGain=50.0, extraCN2: 15000*sin(t)   ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=1.5, extraCN1:120000, extraCN2: 80000*sin(t) ', num2str(date),  datestr(now, '  HH:MM:SS')]);
% % %title( ['pymunk setting, IaGain=1.5, IIGain=0.5, extraCN1:50000, extraCN2: 40000*sin(t)', num2str(date),  datestr(now, '  HH:MM:SS')]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
% plot(t(1:100), f_emg_ind_flex(1:100));
% figure
% 
% d=fdesign.highpass('N,Fc',5, 1,400);
% %designmethods(d)
% Hd = design(d);
% % fvtool(Hd);
% % d=design(h,'equiripple'); %Lowpass FIR filter
% %y=filtfilt(Hd,f_emg_ind_flex ); %zero-phase filtering
% y1=filter(Hd,f_emg_ind_flex); %conventional filtering
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

% y=filtfilt(d.Numerator,1, f_emg_ind_flex); %zero-phase filtering
% y1=filter(d.Numerator,1, f_emg_ind_flex); %conventional filtering


