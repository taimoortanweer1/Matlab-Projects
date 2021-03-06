    %%  Savitzky-Golay FIR smoothing filter to the data in vector x.
    % This is normally used for removing noise from accelerometer signal,


    clear all
    close all

    %load file
    load -mat data.mat
    load -mat complexSensorsData64.mat
    
    [r,w] = size(rawMatrix);
    
    for i=1:1:w
    data(1,:) = rawMatrix(:,i);
    sig = data(1,:);
    i
    %%% Block| Savitzky-Golay FIR smoothing filter %%%%

    %order of the FIR filter (polynomial) being for filtering process and framelength used for
    %where framelength must be greater than order of the polynomial
    order = 1;
    framelen = 1;

    %different test values of order and framelength to check for the best noise
    %removal parameters.

    % for order=2:1:4
    %   for  framelen=5:2:41
    %
    %      lx = length(sig);
    %      sgf = sgolayfilt(sig,order,framelen);
    %
    %
    %      plot(sig,':')
    %      hold on
    %      plot(sgf,'.-')
    %      legend('signal','sgolay')
    %      hold off
    %     sigsnr1(order,framelen) = snr(sgf);
    %
    %   end
    % end

    %for order=2:1:4
    %  for  framelen=5:2:41

    fs = 0.2857;
    t = (0:numel(sig) - 1)/fs;
    % hampel 4,7,11,14 with 100,7
    % hampel 2,6,15,35,63 with 10,7
    % sgolay + hampel 10,7 and 4,41
    
    %medfiltLoopVoltage = sgolayfilt(sig,3,47);
    %medfiltLoopVoltage = hampel(medfiltLoopVoltage,10,7);
    
    
    %medfiltLoopVoltage = medfilt1(sig,10);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %moving cleaning window
    windowSize = 20;
    y1 = sig(1:2390);
    
    for c=1:windowSize:2390-windowSize
    y1_1= y1(c:c+windowSize);%first window
    x=1;
    %cleaning loop
    while  x<= length(y1)
        if(y1(x)> 1.01*(median(y1_1))||y1(x) < 0.95*(median(y1_1)))
            y1(x)= median(y1_1);
        end
        if(x>= length(y1)-5)
            y1_1= y1(length(y1)-5:length(y1));
        else
            y1_1 = y1(x:x+5);
        end
        x=x+1;
    end
    end
    
    final = sgolayfilt(y1,3,47);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    plot(sig,'b')
    hold on
    plot(final,'r')
    %plot(medfiltLoopVoltage,'r')
    legend('Signal','Output')
    hold off
    
    xlabel('Time (s)')
    ylabel('Amplitude')
    title(strcat('Output Signal After Signal Filtering | Sensor-',num2str(i)))
    %ylim(yax)
    grid
    
  % code to show image number i
    saveas(gcf,['sensor' num2str(i) '.png']);
    %sigsnr1(order,framelen) = snr(sgf);

    %  end
    %end
    end