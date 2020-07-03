    %%  Hempel and Savitzky-Golay FIR smoothing filter to the data in vector x.
    % This is normally used for removing noise from accelerometer signal,


    clear all
    close all

    %load file    
    load -mat complexSensorsData64.mat
    
    [r,w] = size(rawMatrix);
    
    for i=1:1:w
    data(1,:) = rawMatrix(:,i);
    sig = data(1,:);
    i
    order = 1;
    framelen = 1;
        
    fs = 0.2857;
    t = (0:numel(sig) - 1)/fs;
             
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
    
    
    %hempel and golay implementation with optimised filter parameters
    hempelfiltout = hampel(y1,10,7);    
    final = sgolayfilt(hempelfiltout,3,47);
    
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