%%  Chebyshev low pass Filter x.

clear all
close all

%load file
filename = {'ch1_20180225-153446.wav','ch2_20180225-153446.wav','ch3_20180225-153446.wav','ch4_20180225-153446.wav',...
            'ch5_20180225-153446.wav','ch8_20180225-153446.wav'};


%filename{1} means load channel # 1
%filename{2} means load channel # 2
% and so on
mkdir('B7');
fileno = 1;
    
[sig,Fs] = audioread(filename{fileno});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Block  7 | Chebyshev Type - II low pass Filter %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Fs = 48000;                                                  % Sampling Frequency (Hz)
Fn = Fs/2;                                                  % Nyquist Frequency (Hz)
Wp = ([1 97])/Fn;                                         % Stopband Frequency (Normalised)
Ws = ([0.1 99])/Fn;                                         % Passband Frequency (Normalised)
Rp =   1;                                                   % Passband Ripple (dB)
Rs =  50;                                                   % Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                             % Filter Order
[z,p,k] = cheby2(n,Rs,Ws);                                  % Filter Design, Sepcify Bandstop
[sos,g] = zp2sos(z,p,k);                                    % Convert To Second-Order-Section For Stability

mean_signal = mean(sig);

filtered_signal = filtfilt(sos, g, sig);                    % Filter Signal | without phase distortion
filtered_signal = filtered_signal + mean_signal;            % Original baseline

% figure(1)
% plot(sig,':')
% hold on
% plot(filtered_signal,'.-')
% legend('original signal','filtered signal')
% hold off

sigsnr1 = snr(filtered_signal);

%save the denoised signal in wav format
audiowrite(strcat('B7\B7_',num2str(fileno),'.wav'),filtered_signal,48000);    

save('B7\B7_SNR.mat','sigsnr1'); 
