%script to analyze leg swell data from Afferent Research Strain leg swell
%strain gage

clear all;
clc;

dbstop if error;

% Process: 
% 1) load files & pull relevant info
% 2) design filter parameters
% 3) filter, calibrate and debias data
% 4) window data & calculate means
% 5) populate into a table and export to excel


%load the files into a directory and the data into a cell array
swellData = dir('*.txt'); 
N = length(swellData);
data = cell(1, N);

for k = 1:N
  data{k} = importdata(swellData(k).name); 
  rawData{k} = data{1,k}.data;
end
filenames = extractfield(swellData,'name');

%set filter parameters - 2nd order butterworth lowpass, cutoff at 2Hz
sampling_frequency = 1000;
cutoff_f = 2; 
[b,a] = butter(2,cutoff_f/(sampling_frequency/2),'low'); %i change this to 'high' 
% freqz(b,a); - %plot the freq parameters if you need it

for i = 1:N
    
    %filter the raw data
    filtData{i} = filtfilt(b,a,rawData{i}(1:end,2));
    
    %apply calibration factor - look to calibration worksheet for data %all data is in mm
    calData{i} = (3.2455*filtData{i}) + 3.8601;
    
    %debias
    zeroedData{i} = calData{i}(:,1) - mean(calData{i}(1:300000,1));
   
    %Calculate output means
        min1{i} = mean(zeroedData{i}(60000:120000,1));
        min28{i} = mean(zeroedData{i}(1680000:1740000,1));
        min31{i} = mean(zeroedData{i}(1860000:1920000,1));
        min58{i} = mean(zeroedData{i}(3480000:3540000,1));
        min61{i} = mean(zeroedData{i}(3660000:3720000,1));
        min88{i} = mean(zeroedData{i}(5280000:5340000,1));
        min91{i} = mean(zeroedData{i}(5460000:5520000,1));
        min118{i} = mean(zeroedData{i}(7080000:7140000,1));
        min121{i} = mean(zeroedData{i}(7260000:7320000,1));
        min148{i} = mean(zeroedData{i}(8880000:8940000,1));
        min151{i} = mean(zeroedData{i}(9060000:9120000,1));
        min178{i} = mean(zeroedData{i}(10680000:10740000,1));
        min181{i} = mean(zeroedData{i}(10860000:10920000,1));
        min208{i} = mean(zeroedData{i}(12480000:12540000,1));
        min211{i} = mean(zeroedData{i}(12660000:12720000,1));
        min238{i} = mean(zeroedData{i}(14280000:14340000,1));     
end


%take mean data and put it into a cell array, then a table

processeddata1 = [filenames; min1; min28; min31; min58; min61; min88; min91; min118; min121; min148; min151; min178; min181; min208; min211; min238]';
processeddata = cell2table(processeddata1,'VariableNames',{'Filenames','min1','min28','min31','min58','min61','min88','min91','min118','min121','min148','min151','min178','min181','min208','min211','min238'});

%all data is in mm
%export
writetable(processeddata, 'legSwell.xlsx');
