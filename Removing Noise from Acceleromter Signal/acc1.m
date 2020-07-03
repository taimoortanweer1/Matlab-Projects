
% file takes noisy signal as input and output denoised signal in the form
% of a wav file. Files are stored in the B1 folder alongwith its SNR
% values in a mat file

clear all
close all

%load file
filename = {'ch1_20180225-153446.wav','ch2_20180225-153446.wav','ch2_20180225-153446.wav','ch4_20180225-153446.wav',...
            'ch4_20180225-153446.wav','ch5_20180225-153446.wav','ch6_20180225-153446.wav','ch7_20180225-153446.wav',...
            'ch8_20180225-153446.wav'};
 
 %filename{1} means load channel # 1
 %filename{2} means load channel # 2 
 % and so on
 
[sig,Fs] = audioread(filename{1}); 

%Name of all the wavelets that are being used for denoising purpose
wname = {'haar','sym1','sym2','sym3','sym4','sym5','sym6','sym7','sym8','db1','db2','db3','db4','db5','db6','db7','db8'};

%Level upto which each time a signal is decomposed using wavelets
level = {1,2,3,4,5,6,7};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Block # 1 | Denoising Using a Single Interval %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dedencmp evaluates signal's threshold, threshold type and whether to keep
% approximate component or not during decomposition of a signal.. 'den' 
% parameter is used for denoising, 'wv' means decompose using wavelet
[thr,sorh,keepapp] = ddencmp('den','wv',sig);

%make directory in the current folder
mkdir('B1');

%loops for passing  through each wavelet name and level
for w = 1:1:length(wname)
for l = 1:1:length(level)
    
    %this function returns denoised signal using global threshold using specified wavelet name, its
    %level, threshold value and thresholding type
    sigden_1 = wdencmp('gbl',sig,wname{w},level{l},thr,sorh,keepapp);
    
    %find residual noise for comparing
    res = sig-sigden_1;
    
    %compute snr of the signal
    sigsnr1(w,l) = snr(sigden_1);
    
    %save the denoised signal in wav format
    audiowrite(strcat('B1\B1_',wname{w},'_',num2str(level{l}),'.wav'),sigden_1,48000);    
    w,l
end
end
    
    %save the SNR variable
    save('B1\B1_SNR.mat',sigsnr1); 

% subplot(3,1,1);
% plot(sig,'r');
% axis tight
% title('Original Signal');
% 
% subplot(3,1,2);
% plot(sigden_1,'b');
% axis tight
% title('Denoised Signal');
% 
% subplot(3,1,3);
% plot(res,'k');
% axis tight
% title('Residual');


