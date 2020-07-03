% file takes noisy signal as input and output denoised signal in the form
% of a wav file. Files are stored in the B2 folder alongwith its SNR
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Block 2 | Level-Independent Threshold - Stationary Wavelet Transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%adjust length of signal just to make it divisible by 2^N
sig1 = [sig;1];

mkdir('B2');
%loops for passing  through each wavelet name and level
 for w = 1:1:length(wname)
 for l = 1:1:length(level)

% wavelet coefficients are derived using specified level and wavelet name
% for a noisy signal
swc = swt(sig1,level{l},wname{w});

%copy of coefficients are saved in a variable
swcnew = swc;

%Determine the Donoho-Johnstone universal threshold (first parameter) based on the detail coefficients for each scale. Using the 'mln' option, wthrmngr returns a 1-by-L 
%vector with each element of the vector equal to the universal threshold for the corresponding scale. 
% heuristics variant (2nd paramater)
% 'sln' for rescaling using a single estimation of level noise based on first-level coefficients
ThreshSL = mean(wthrmngr('sw1ddenoLVL','heursure',swc,'sln'));

%thresholding the signal based on calculated threshold from the above step
for jj = 1:level{l}
swcnew(jj,:) = wthresh(swc(jj,:),'h',ThreshSL);
end
 
%reconstruction of the signal
noisbloc_denoised = iswt(swcnew,wname{w});

%calculate snr
sigsnr1(w,l) = snr(noisbloc_denoised);

%save the denoised signal in wav format
audiowrite(strcat('B2\B2_',wname{w},'_',num2str(level{l}),'.wav'),noisbloc_denoised,48000);    
w,l

end
 end
 
%save the SNR variable
save('B2\B2_SNR.mat',sigsnr1); 
 
% subplot(2,1,1);
% plot(sig1); hold on;
% plot(noisbloc_denoised,'r','linewidth',2);
% res = noisbloc_denoised - sig1';


