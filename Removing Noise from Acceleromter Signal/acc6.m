%%  Savitzky-Golay FIR smoothing filter to the data in vector x. 
% This is normally used for removing noise from accelerometer signal,


clear all
close all

%load file
filename = {'ch1_20180225-153446.wav','ch2_20180225-153446.wav','ch2_20180225-153446.wav','ch4_20180225-153446.wav',...
            'ch4_20180225-153446.wav','ch5_20180225-153446.wav','ch6_20180225-153446.wav','ch7_20180225-153446.wav',...
            'ch8_20180225-153446.wav'};
 
  
 %filename{1} means load channel # 1
 %filename{2} means load channel # 2 
 % and so on
 mkdir('B6');
 
[sig,Fs] = audioread(filename{1}); 
In = sig';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Block  6 | Savitzky-Golay FIR smoothing filter %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%order of the FIR filter (polynomial) being for filtering process and framelength used for 
%where framelength must be greater than order of the polynomial
order = 1;
framelen = 1;


%different test values of order and framelength to check for the best noise
%removal parameters.

for order=1:1:4
  for  framelen=5:2:41
  
     lx = length(sig);    
     sgf = sgolayfilt(sig,order,framelen);

%     plot(sig,':')
%     hold on
%     plot(sgf,'.-')
%     legend('signal','sgolay')

    sigsnr1(order,framelen) = snr(sgf);

    
%save the denoised signal in wav format
audiowrite(strcat('B6\B6_O',num2str(order),'_FL',num2str(framelen),'.wav'),sgf,48000);    

  end
    end

save('B6\B6_SNR.mat','sigsnr1'); 
