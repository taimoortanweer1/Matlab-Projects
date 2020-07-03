% file takes noisy signal as input and output denoised signal in the form
% of a wav file. Files are stored in the B3 folder alongwith its SNR
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Block # 3 | %%%%% Advanced Automatic Interval-Dependent Denoising %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Type of thresholding.
sorh   = 's';                  

% Number of intervals in a signal for thresholding.
nb_Int = 3;                    

mkdir('B3');

%loops for passing  through each wavelet name and level
for w = 1:1:length(wname)
for l = 1:1:length(level)

 %returns the denoised signal, sigden, obtained from an interval-dependent denoising of the signal
[sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = cmddenoise(sig,wname{w},level{l},sorh,nb_Int);

%calculate snr
sigsnr1(w,l) = snr(sigden);

%save the denoised signal in wav format
audiowrite(strcat('B3\B3_',wname{w},'_',num2str(level{l}),'.wav'),sigden,48000);    
w,l

end
end

%save the SNR variable
save('B3\B3_SNR.mat',sigsnr1); 


% plot(sig,sigden)
% plot(sig,'k')
% hold on
% plot(sigden,'r')

