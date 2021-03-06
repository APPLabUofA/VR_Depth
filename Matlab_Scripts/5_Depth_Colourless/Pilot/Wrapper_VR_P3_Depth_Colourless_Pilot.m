%% PREPROCESSING AND ANALYSIS WRAPPER
%clear and close everything
clear
close all
clc

%% Settings for loading the raw data
exp.analysis = 2; % (1/2) (Preprocess/Analysis)
exp.trigger_set = 1; % (1/2/3)(Onset/Response/Offset) respectively
exp.condition_set = 1; %  (1/2) (Near/Far) respectively
exp.participant_set = 1; %  (Loading in data for analysis) (Preprocessing new data, only add the new ones) respectively

%%% insert following script to easily get reaction times for incorrect and correct targets 
    
    %     exp.events = {[3],[4];...
    %                   [3],[4]};    %must be matrix (sets x events)
    %     exp.event_names = {'Correct_RT','Incorrect_RT'}; %name the columns
exp.setname = {'Depth_1';'Depth_2';'Depth_3';'Depth_4';'Depth_5'}; %name the rows
exp.pathname = 'M:\Data\VR_P3_Five_Depth_Colourless\Pilot\Pilot_3\';
if exp.participant_set == 1
    exp.participants = {'001','002','003','004','005','006'};
elseif exp.participant_set == 2
     exp.participants = {'003'};
end

if exp.condition_set == 1 
    exp.name = 'pilot_near';
    if exp.trigger_set == 1
        %%%%%Triggers to tone onset%%%%%
        exp.events = {(101);...
            (102);...
            (103);...
            (104);...
            (105)};    %must be matrix (sets x events)
        exp.event_names = {'Orb_Onset'}; %name the columns
        exp.selection_cards = {'101',...
            '102',...
            '103',...
            '104',...
            '105'};

    elseif exp.trigger_set == 2
        %%%%%Triggers to tone onset%%%%%
        exp.events = {[106];...
            [107];...
            [108];...
            [109];...
            [110]};    %must be matrix (sets x events)
        exp.event_names = {'Response_Targets'}; %name the columns
        exp.selection_cards = {'106',...
            '107',...
            '108',...
            '109',...
            '110'};

    elseif exp.trigger_set == 3
        %%%%%Triggers to tone onset%%%%%
        exp.events = {[111];...
            [112];...
            [113];...
            [114];...
            [115]};    %must be matrix (sets x events)
        exp.event_names = {'Orb_Offset'}; %name the columns
        exp.selection_cards = {'111',...
            '112',...
            '113',...
            '114',...
            '115'};
    end
elseif exp.condition_set == 2 
    exp.name = 'pilot_far';
    if exp.trigger_set == 1
        %%%%%Triggers to tone onset%%%%%
        exp.events = {[101];...
            [102];...
            [103];...
            [104];...
            [105]};    %must be matrix (sets x events)
        exp.event_names = {'Orb_Onset'}; %name the columns
        exp.selection_cards = {'101',...
            '102',...
            '103',...
            '104',...
            '105'};

    elseif exp.trigger_set == 2
        %%%%%Triggers to tone onset%%%%%
        exp.events = {[106];...
            [107];...
            [108];...
            [109];...
            [110]};    %must be matrix (sets x events)
        exp.event_names = {'Response_Targets'}; %name the columns
        exp.selection_cards = {'106',...
            '107',...
            '108',...
            '109',...
            '110'};

    elseif exp.trigger_set == 3
        %%%%%Triggers to tone onset%%%%%
        exp.events = {[111];...
            [112];...
            [113];...
            [114];...
            [115]};    %must be matrix (sets x events)
        exp.event_names = {'Orb_Offset'}; %name the columns
        exp.selection_cards = {'111',...
            '112',...
            '113',...
            '114',...
            '115'};
    end

end   


% % Each item in the exp.events matrix will become a seperate dataset, including only those epochs referenced by the events in that item.
% %e.g. 3 rows x 4 columns == 12 datasets/participant

% % The settings will be saved as a new folder. It lets you save multiple datasets with different preprocessing parameters.
exp.settings = 'pilot_ERP';

%% Preprocessing Settings
%segments settings
exp.segments = 'on'; %Do you want to make new epoched datasets? Set to "off" if you are only changing the tf settings.
%Where are your electrodes? (.ced file)
exp.electrode_locs = 'M:\Analysis\VR_P3_Five_Depth_Colourless\VAMP_EOG_VR.ced';

%% Filter the data?
exp.filter = 'on';
exp.lowpass = 50;
exp.highpass = 0;

%% Re-referencing the data
exp.refelec = 16; %which electrode do you want to re-reference to?
exp.brainelecs = 1:15; %list of every electrode collecting brain data (exclude mastoid reference, EOGs, HR, EMG, etc.)

%% Epoching the data
%Choose what to epoch to. The default [] uses every event listed above.
%Alternatively, you can epoch to something else in the format {'TRIG'}. Use triggers which are at a consistent time point in every trial.
exp.epochs = [];
exp.epochslims = [-1 1]; %Tone Onset in seconds; epoched trigger is 0 e.g. [-1 2]
% % exp.epochslims = [-1 2.5]; %Picture Onset in seconds; epoched trigger is 0 e.g. [-1 2]
exp.epochbaseline = [-200 0]; %remove the for each epoched set, in ms. e.g. [-200 0]

%% Artifact rejection.
% Choose the threshold to reject trials. More lenient threshold followed by an (optional) stricter threshold
exp.preocularthresh = [-1000 1000]; %First happens before the ocular correction.
exp.postocularthresh = [-500 500]; %Second happens after. Leave blank [] to skip

%% Blink Correction
%the Blink Correction wants dissimilar events (different erps) seperated by commas and similar events (similar erps) seperated with spaces. See 'help gratton_emcp'
% % exp.selection_cards = {'1','2'};
%%%%

%% Time-Frequency settings
%Do you want to run time-frequency analyses? (on/off)
exp.tf = 'off';
%Do you want to save the single-trial data? (on/off) (Memory intensive!!!)
exp.singletrials = 'off';
%Do you want to use all the electrodes or just a few? Leave blank [] for all (will use same as exp.brainelecs)
exp.tfelecs = [];
%Saving the single trial data is memory intensive. Just use the electrodes you need.
exp.singletrialselecs = [3];

%% Wavelet settings
%how long is your window going to be? (Longer window == BETTER frequency resolution & WORSE time resolution)
exp.winsize = 512; %in ms; use numbers that are 2^x, e.g. 2^10 == 1024ms
%baseline will be subtracted from the power variable. It is relative to your window size.
exp.erspbaseline = [-200 0]; %e.g., [-200 0] will use [-200-exp.winsize/2 0-exp.winsize/2]; Can use just NaN for no baseline
%Instead of choosing a windowsize, you can choose a number of cycles per frequency. See "help popnewtimef"
exp.cycles = [0]; %leave it at 0 to use a consistent time window
exp.freqrange = [1 40]; % what frequencies to consider? default is [1 50]
%%%%

%% Save your pipeline settings
save([exp.settings '_Settings'],'exp') %save these settings as a .mat file. This will help you remember what settings were used in each dataset

% % Run Preprocessing
if exp.analysis == 1
    Preprocessing_VR_P3_Depth_Colourless(exp) 
end

%% Run Analysis
%Don't want to change all the above settings? Load the settings from the saved .mat file.

%choose the data types to load into memory (on/off)
anal.segments = 'on'; %load the EEG segments?
anal.tf = 'off'; %load the time-frequency data?

anal.singletrials = 'off'; %load the single trial data?
anal.entrainer_freqs = [20; 15; 12; 8.5; 4]; %Single trial data is loaded at the event time, and at the chosen frequency.

anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
anal.singletrialselecs = [2 3 4 6];

if exp.analysis == 2
    Analysis_VR_P3_Depth_Colourless(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end

%% Make plots
VR_P3_Depth_Colourless_ERP