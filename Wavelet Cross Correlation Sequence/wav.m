load 'fusd.mat'
level = 7;
fUSD = fusd(:,1);
jUSD = fusd(:,2);
pUSD = fusd(:,3);
aUSD = fusd(:,4);

fwt = modwt(fUSD,'db2',level);
jwt = modwt(jUSD,'db2',level);
pwt = modwt(pUSD,'db2',level);
awt = modwt(aUSD,'db2',level);

[xcseq,xcseqci,lags] = modwtxcorr(fwt,jwt,'fk8');
zerolag = floor(numel(xcseq{1})/2)+1;
plot(lags{1}(zerolag:zerolag+20),xcseq{1}(zerolag:zerolag+20));
hold on;
plot(lags{1}(zerolag:zerolag+20),xcseqci{1}(zerolag:zerolag+20,:),'r--');
xlabel('Lag (Quarters)');
grid on;
title('Wavelet Cross-Correlation Sequence -- [2Q,4Q)');





