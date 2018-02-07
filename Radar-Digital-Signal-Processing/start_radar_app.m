% Start the UWB radar app
clear all; clc; close all;

%% Clear old serial port objects
% This runs just in case there wasn't a clean exit on the previous run.
delete(instrfind);

%% Random setup stuff that doesn't fit elsewhere
% This adds subfolders to the path and enables the pause function.
setup_demo();

%%
% USER SELECTION: Initialize and configure RADAR/program settings  

% SELECT RADAR SETTINGS:
init_param();

% DATA SOURCE: 
% Case 0: radar
% Case 1: log file
param.data_source = 1;

% ENABLE LOG FEATURE:
% Case 0: Do not save
% Case 1: Save log file
param.save_log = 1;

switch param.data_source
    case 0
        % Open serial ports for two radars
        srl = open_com_port([4 7]);
        [fnm,dnm] = uiputfile('*.txt');
        param.log_filename = fullfile(dnm,fnm);
        if param.save_log
            log_file = log_open(param);
        end
        param = config_radar(srl,param);
        save('log_param.mat', 'param')
    case 1
        srl = [-1 -1];
        [fnm,dnm] = uigetfile('*.txt');
        param.log_filename = fullfile(dnm,fnm);
        log_file = log_open(param);
        load('log_param.mat')
        param.data_source = 1;
end
%% Test Threshold
%
demo_threshold(srl, param, log_file);

 
%% Start main application
% Isn't using the modification I made above. But works using the method we
% showed you in the lab. :D
demo_2d(srl,param,log_file);

%% Clean up on exit
if param.data_source == 0
    delete(srl);        % delete serial objects if we're using radar
end
log_close(log_file);