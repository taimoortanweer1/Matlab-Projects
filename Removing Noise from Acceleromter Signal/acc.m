
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

wname = {'haar','sym1','sym2','sym3','sym4','sym5','sym6','sym7','sym8','db1','db2','db3','db4','db5','db6','db7','db8'};
level = {1,2,3,4,5,6,7};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Block # 1 | Denoising Using a Single Interval %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wname = {'haar','sym1','sym2','sym3','sym4','sym5','sym6','sym7','sym8','db1','db2','db3','db4','db5','db6','db7','db8'};
%level = {1,2,3,4,5,6,7};

% [thr,sorh,keepapp] = ddencmp('den','wv',sig);
% 
% for w = 1:1:length(wname)
% for l = 1:1:length(level)
%     
%   [sigden_1,~,~,perf0,perfl2] = wdencmp('gbl',sig,wname{w},level(l),thr,sorh,1);
%     res = sig-sigden_1;
%     rms
%     sigsnr1(w,l) = snr(sigden_1);
% end
% end
% 
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Block 2 | Level-Independent Threshold - Stationary Wavelet Transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sig1 = [sig;1];
% 
%  for w = 1:1:length(wname)
%  for l = 1:1:length(level)
%      
% swc = swt(sig1,level{l},wname{w});
% swcnew = swc;
% ThreshSL = mean(wthrmngr('sw1ddenoLVL','heursure',swc,'sln'));
% 
% for jj = 1:level{l}
% swcnew(jj,:) = wthresh(swc(jj,:),'h',ThreshSL);
% end
%  
% noisbloc_denoised = iswt(swcnew,wname{w});
% sigsnr1(w,l) = snr(noisbloc_denoised);
%  end
%  end
%  
%  subplot(2,1,1);
% plot(sig1); hold on;
% plot(noisbloc_denoised,'r','linewidth',2);
% res = noisbloc_denoised - sig1';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Block # 3 | %%%%% Advanced Automatic Interval-Dependent Denoising %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  wname = {'haar','sym1','sym2','sym3','sym4','sym5','sym6','sym7','sym8','db1','db2','db3','db4','db5','db6','db7','db8'};
%  level = {1,2,3,4,5,6,7};   
% sorh   = 's';                  % Type of thresholding.
% nb_Int = 3;                    % Number of intervals for thresholding.
% 
% for w = 1:1:length(wname)
% for l = 1:1:length(level)
% [sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = cmddenoise(sig,wname{w},level{l},sorh,nb_Int);
% sigsnr1(w,l) = snr(sigden);
% w,l
% end
% end

% plot(sig,sigden)
% plot(sig,'k')
% hold on
% plot(sigden,'r')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Block  4 | wavelet packet denoising %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for w = 1:1:length(wname)
for l = 1:1:length(level)
[thr,sorh,keepapp,crit] = ddencmp('den','wp',sig);
[xc,wpt,perf0,perfl2] = wpdencmp(sig,sorh,level{l},wname{w},crit,thr,keepapp);
sigsnr1(w,l) = snr(xc);
w,l
end
end


