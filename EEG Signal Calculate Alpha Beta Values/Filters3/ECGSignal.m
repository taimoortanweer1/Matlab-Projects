close all
clear all
[x, y] = plotECGSignal('100m');


% Plot the first signal (Top)
figure, subplot(2,1,1);
plot(x, y(:, 1)); % x = the x axis of the signal, y(:, 1) = the y axis for the first signal
xlim([0, x(end)]);

% Plot the second signal (Bottom)
y(:,2) = awgn(y(:, 1),20,0); %snr of 20db

subplot(2,1,2);
plot(x, y(:,2)); % x = the x axis of the signal, y(:, 2) = the y axis for the second signal
xlim([0, x(end)]);

% Both plots at the same time for comparison
figure, hold on;
plot(x, y(:, 1));
plot(x, y(:, 2));
xlim([0, x(end)]);
ylim([-1 2]);

%DAC(y(:,2),10,3,10)
close all
t = [0:1:21600-1];
fs = 4500; 
bits = 3
Input1 = y(:, 2);
quant=max(Input1)/(2^bits-1);
y=round(Input1/quant);
signe=uint8((sign(y)'+1)/2);
out1=dec2bin(abs(y),bits);
out=[signe dec2bin(abs(y),7)];

plot(t,y)
hold on
plot(t,out)


function [y1] = DAC(inputSignal, fRange, bits,totaltime)
f = fRange; %range of the signal
n = bits; %no of bits
q = f/(2^n-1); %quantization
t = 1:1:totaltime;
y = abs(inputSignal(t));

x0 = fix(y/q);
y0 = dec2bin(x0,n);
y1 = x0 * q;
plot(t,y0,'r');
hold on
plot(t,y1,'b');
hold off





end
function [a, b] = plotECGSignal(Name)
    infoName = strcat(Name, '.info');
    matName = strcat(Name, '.mat');
    Octave = exist('OCTAVE_VERSION');
    load(matName);
    fid = fopen(infoName);
    fgetl(fid);
    fgetl(fid);
    fgetl(fid);
    [freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');
    interval = freqint(2);
    fgetl(fid);

    if(Octave)
        for i = 1:size(val, 1)
           R = strsplit(fgetl(fid), char(9));
           signal{i} = R{2};
           gain(i) = str2num(R{3});
           base(i) = str2num(R{4});
           units{i} = R{5};
        end
    else
        for i = 1:size(val, 1)
          [row(i), signal(i), gain(i), base(i), units(i)]=strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
        end
    end

    fclose(fid);
    val(val==-32768) = NaN;

    for i = 1:size(val, 1)
        val(i, :) = (val(i, :) - base(i)) / gain(i);
    end

    x = (1:size(val, 2)) * interval;
    
    a = x';
    b = val';
end

% HINT: The AWGN should be applied to the y axis of a signal!