close all
clear all
clc


%fs = 128
% 1000 : 8
% 512 : 7
% 256 : 6
% 128 : 5
directory=('File Path');
[file, text] = xlsread(directory,1, 'A1:IW257');


data1 = file;

%load data1.mat

i = 1;
[r,c] = size(data1);
RATIO = zeros(r,1);
for i=1:r
    
    %for first row
    if (i==1)
        S = data1(1,:);        
        
    %for other rows
    else
        S = [data1(i-1,9:c) data1(i,1:8)];
    end
    
    waveletFunction = 'db4'; %OR 'sym8' OR 'coif5' OR 'db4';
    [C,L] = wavedec(S,5,waveletFunction);
    %%Calculation The Coificients Vectors
    cD1 = detcoef(C,L,1);                   %
    cD2 = detcoef(C,L,2);                   %
    cD3 = detcoef(C,L,3);                   %
    cD4 = detcoef(C,L,4);                   %
    cD5 = detcoef(C,L,5);                   %
    cA5 = appcoef(C,L,waveletFunction,5);   %
    
    %%%%Calculation the Details Vectors
    D1 = wrcoef('d',C,L,waveletFunction,1); %
    D2 = wrcoef('d',C,L,waveletFunction,2); % GAMMA
    D3 = wrcoef('d',C,L,waveletFunction,3); % BETA
    D4 = wrcoef('d',C,L,waveletFunction,4); % ALPHA
    D5 = wrcoef('d',C,L,waveletFunction,5); % THETA
    A5 = wrcoef('a',C,L,waveletFunction,5); % DELTA
    
    POWER_DELTA = (sum(A5.^2))/length(A5);
    POWER_THETA = (sum(D5.^2))/length(D5);
    POWER_ALPHA = (sum(D4.^2))/length(D4);
    POWER_BETA = (sum(D3.^2))/length(D3);
    
%     Total=POWER_DELTA+ POWER_THETA+POWER_ALPHA+POWER_BETA;
    
    
%     RELATIVE_DELTA=POWER_DELTA/Total;
%     RELATIVE_THETA=POWER_THETA/Total;
%     RELATIVE_ALPHA=POWER_ALPHA/Total;
%     RELATIVE_BETA=POWER_BETA/Total;
%     
    RATIO(i) = POWER_BETA/POWER_ALPHA;
    
end


