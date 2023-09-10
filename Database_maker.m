%%  Make databas

% Make database: R G B , optical flow x y , Semantic segmentation,
% along with AQ and GPS information.
% Semantic segmentation pre-trained model was according to the tutorial in the link:
% https://www.mathworks.com/help/vision/ug/semantic-segmentation-using-deep-learning.html
% Make sure to install - Deep Learning Toolbox Model for ResNet-18 Network - from the Add on Explorer

% set the current directory before starting, by the cd function

% set the sample rate
sample_rate = 1;

% load nets  - Semantic segmentation, optical flow
% semantic segmentation
pretrainedURL = 'https://ssd.mathworks.com/supportfiles/vision/data/deeplabv3plusResnet18CamVid.zip';
pretrainedFolder = fullfile(tempdir,'pretrainedNetwork');
pretrainedNetworkZip = fullfile(pretrainedFolder,'deeplabv3plusResnet18CamVid.zip'); 
if ~exist(pretrainedNetworkZip,'file')
    mkdir(pretrainedFolder);
    disp('Downloading pretrained network (58 MB)...');
    websave(pretrainedNetworkZip,pretrainedURL);
end
unzip(pretrainedNetworkZip, pretrainedFolder)
pretrainedNetwork = fullfile(pretrainedFolder,'deeplabv3plusResnet18CamVid.mat');  
data = load(pretrainedNetwork);
segnet = data.net;

% optical flow
opticflow = opticalFlowHS;


% load excel sheet
Excel_sheet_path = "exce_sheet_path";
DataTable = readtable(Excel_sheet_path);

% Define Saving path
formatOut = 'yyyy_mm_dd_HHMMSS';
save_path = manage_table.("Saving path")(idx) + "\";
if ~exist(save_path,'dir')
    mkdir(save_path)
end

% set video folder path
video_folder_path = "videos";
video_names = string(ls(video_folder_path)); % list all files in folder
video_names = video_names(~startsWith(video_names,".")); % remove hiddeen files from folder

% loop over all videos
for video_name = video_names'
    disp(sprintf("Working on video: %s", video_name))
    % re-define the optical flow incase videos are in different formats
    opticflow = opticalFlowHS;
    % read video
    video_path = video_folder_path + "\" + video_name;
    vid = VideoReader(video_path);
    starting_time = datetime(eraseBetween(video_name,17,strlength(video_name)), ...
        "InputFormat",'yyyy_MMdd_HHmmss');
    [isTimeOkay,current_row] = ismember(starting_time, DataTable.date);
    if ~isTimeOkay
        disp(video_name + " video time in name doe's not appear in data table")
        continue
    end
    % loop over all frames and save for each frame
    i=0;
    while hasFrame(vid)
        i = i + 1;
        frame = vid.readFrame;
        if mod(i, vid.FrameRate*sample_rate) == 0
            frame = frame(1:1500,:,:);
            I.img = frame;
            I.seg = semanticseg(imresize(frame, [720 960]), segnet);
            flow = estimateFlow(opticflow, im2gray(frame));
            if ~hasFrame(vid)
                break
            end
            frame = vid.readFrame;
            i = i + 1;
            flow = estimateFlow(opticflow, im2gray(frame(1:1500,:,:)));
            I.Vx = flow.Vx;
            I.Vy = flow.Vy;
            I.CO2 = DataTable.CO2(current_row);
            I.PM2_5 = DataTable.PM2_5(current_row);
            I.PM2_5_Corr = DataTable.PM2_5_Corr(current_row);
            I.BC = DataTable.BC(current_row);
            I.Latitude = DataTable.Latitude(current_row);
            I.Longitude = DataTable.Longitude(current_row);
            I.RH = DataTable.RH(current_row);
            I.Particle_conc = DataTable.Particle_conc(current_row);
            I.time = DataTable.date(current_row);
            save(save_path + datestr(I.time,formatOut) + ".mat", ...
                '-struct','I');
            current_row = current_row + 1;
        end 
    end
end
