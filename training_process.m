%% Create datastore:
% Define the features function at the bottom for what features
% define the ration of train and test spliting
ratio = [100 20];

% define batch size for training
batch_size = 128;

% load the network architecture
load('net_lgraph.mat', 'lgraph')

% enter the folder of all files for training
path = "data\";
ds = fileDatastore(path,"IncludeSubfolders",true, ...
    "FileExtensions",".mat","ReadFcn",@features_func);

% split to train- validation and test
[trainDS, testDS] = fileDSTrainTestSplitByRatio(ds,ratio);
ValDS = subset(shuffle(testDS),1:batch_size);

%% Train the model
clc
disp(datetime('now'))
options = trainingOptions('adam', ...
    'MaxEpochs',10,...
    'InitialLearnRate',1e-5, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod', 1, ...
    'LearnRateDropFactor',0.1,...
    'L2Regularization', 5.0000e-1, ... 
    'ValidationData',ValDS, ...
    'Verbose',true, ...
    'Plots','training-progress', ...
    'MiniBatchSize',batch_size, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', '\CheckPoint', ...
    'ValidationFrequency', ...
    200);


net = trainNetwork(trainDS,lgraph,options);
disp(datetime('now'))

%%  Make predictions from the test set:
I = read(shuffle(testDS));
CO2 = predict(net,cell2mat(I(1,1)));
disp(["true value: ", cell2mat(I(1,2)), "predicted value: ", CO2])

%% Evaluate model:
% make predictions on the test data
i = 1;
ypred = zeros(1,numel(testDS.Files));
ytrue = zeros(1,numel(testDS.Files));
for file = string(testDS.Files)'
    X = features_func(file);
    ypred(i) = predict(net,cell2mat(X(1,1)));
    ytrue(i) = cell2mat(X(1,2));
    i = i+1;
    if mod(i,100) == 0
        disp(i)
    end
end

%% Compare:
R = corrcoef(ypred,ytrue);
figure
plot(ytrue,ypred,".")
hold on
plot(ytrue,ytrue)
grid
xlim([min(ytrue),max(ytrue)])
ylim([min(ytrue),max(ytrue)])
title(sprintf("CO2:\n" + ...
    "Data SD: %.2f    model RMSE: %.2f    model MAE: %.2f\n" +...
    "Pearson coef: %.4f",[sqrt(var(ytrue)),sqrt(var(ypred-ytrue)), ...
    mean(abs(ypred-ytrue)), R(1,2)]))
xlabel("Ground truth")
ylabel("Predicted")
hold off

%% Functions
function [X] = features_func(f)
    I = load(f);
    img = I.img;
    Vx = I.Vx;
    Vy = I.Vy;
    seg_classes = ["Sky"
    "Building"
    "Pole"
    "Road"
    "Pavement"
    "Tree"
    "SignSymbol"
    "Fence"
    "Car"
    "Pedestrian"
    "Bicyclist"];
    one_hot = onehotencode(I.seg,3,"ClassNames",seg_classes);
    X = [{cat(3,img,Vx,Vy,one_hot)} {I.CO2}];
end

function [trainFileDS, testFileDS] = fileDSTrainTestSplitByRatio(ds,split_ratio)
    N = numel(ds.Files);
    tr = 1;
    tst = 1;
    for i=1:N
        if mod(i,sum(split_ratio)) < split_ratio(1)
            tridx(tr) = i;
            tr = tr + 1;
        else
            tstidx(tst) = i;
            tst = tst + 1;
        end
    end
    trainFileDS = subset(ds,tridx);
    testFileDS = subset(ds,tstidx);
end
