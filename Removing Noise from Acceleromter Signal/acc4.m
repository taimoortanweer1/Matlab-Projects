% file takes noisy signal as input and output denoised signal in the form
% of a wav file. Files are stored in the B4 folder alongwith its SNR
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
[sig,Fs] = audioread(filename{5}); 

%Name of all the wavelets that are being used for denoising purpose
wname = {'haar','sym1','sym2','sym3','sym4','sym5','sym6','sym7','sym8','db1','db2','db3','db4','db5','db6','db7','db8'};

%Level upto which each time a signal is decomposed using wavelets
level = {1,2,3,4,5,6,7};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Block  4 | wavelet packet denoising %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir('B4');
for w = 1:1:length(wname)
for l = 1:1:length(level)
 
% dedencmp evaluates signal's threshold, threshold type and whether to keep
% approximate component or not during decomposition of a signal.. 'den' 
% parameter is used for denoising, 'wp' means decompose using wavelet
% packet

[thr,sorh,keepapp,crit] = ddencmp('den','wp',sig);

%this function returns denoised signal using global threshold using specified wavelet name, its
 %level, threshold value and thresholding type
[sigden_1,wpt,perf0,perfl2] = wpdencmp(sig,sorh,level{l},wname{w},crit,thr,keepapp);

%compute snr of the signal
    sigsnr1(w,l) = snr(sigden_1);
    
    %save the denoised signal in wav format
    audiowrite(strcat('B4\B4_',wname{w},'_',num2str(level{l}),'.wav'),sigden_1,48000);    
    w,l
end
end

%save the SNR variable
save('B4\B4_SNR.mat',sigsnr1); 

