%% A simple moving average is implemented for noise removing purpose.
% As it contains less computations then previously tried method so may be
% its worth to test this one too

%inputs : noisy signal, Param { padding }, length of padding
%output: denoised signal


clear all
close all

%load file
filename = {'ch1_20180225-153446.wav','ch2_20180225-153446.wav','ch2_20180225-153446.wav','ch4_20180225-153446.wav',...
            'ch4_20180225-153446.wav','ch5_20180225-153446.wav','ch6_20180225-153446.wav','ch7_20180225-153446.wav',...
            'ch8_20180225-153446.wav'};
 
  
 %filename{1} means load channel # 1
 %filename{2} means load channel # 2 
 % and so on
 mkdir('B5');
 
[sig,Fs] = audioread(filename{1}); 
In = sig';

%length of the padded signal for calculating moving average of the signal
%increasing length of padding may improve snr but it may also remove useful
%information from the signal.
Len = 1;

%When calculating successive values, a new value comes into the sum and an 
%old value drops out, meaning a full summation each time is unnecessary 
%for this simple case, also length of the signal is changed

%padding can be either done on 'Center' , 'Left' or 'Right' side of the
 %signal   
  Param = {'Right','Center','Left'};
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Block  5 | moving average filter %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Siz = size (In);
Siz_In = Siz (1, 2);

for Len=1:1:20
    for p=1:1:3
%when left padding is used
if (isequal (Param{p}, 'Left'))
    Pad = zeros (1, Len - 1);
    New_In = [Pad In];
    for i = 1:Siz_In
        temp = 0;
        %calculation of moving average
        for j = 1:Len
            temp = temp + New_In(i + j - 1);
        end
        Out(i) = temp / Len;
    end

%when center padding is used
elseif (isequal (Param{p}, 'Center'))
    len1 = mod (Len, 2);
    if isequal (len1, 0)
        continue;
        %error ('Cannot use the Len as an even number for this option. Use Left or Right');
    else
        Pad_Len = (Len - 1)/2;
        Pad = zeros (1, Pad_Len);
        New_In = [Pad In Pad];
        for i = 1:Siz_In
            temp = 0;
            %calculation of moving average
            for j = 1:Len
                temp = temp + New_In(i + j - 1);
            end
            Out(i) = temp / Len;
        end
    end

%when right padding is used
elseif (isequal (Param{p}, 'Right'))
    Pad = zeros (1, Len - 1);
    New_In = [In Pad];
    for i = 1:Siz_In
        temp = 0;
        %calculation of moving average
        for j = 1:Len
            temp = temp + New_In(i + j - 1);
        end
        Out(i) = temp / Len;
    end
        
end

    %compute snr of the signal
    sigsnr1(p,Len) = snr(Out);
    Out = Out';
    %save the denoised signal in wav format
    audiowrite(strcat('B5\B5_',Param{p},'_',num2str(Len),'.wav'),Out,48000);    
    Len
    p
    end
end

save('B5\B5_SNR.mat','sigsnr1'); 
