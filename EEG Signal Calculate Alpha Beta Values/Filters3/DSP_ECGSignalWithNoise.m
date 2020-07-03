val1=transpose(val);
t=0:10/length(val1):10;
t=t(1:length(val1))
figure, subplot(2,1,1);
plot(t,val1)
legend('Original Signal of ECG')
y = awgn(val1,10,'measured');
subplot(2,1,2);
plot(t,[val1 y])
legend('Signal with AWGN')
