function s = OTFS_modulation(N,M,x)
%% OTFS Modulation: 1. ISFFT, 2. Heisenberg transform
% X1=ifft(x);
% X2=X1.';
% X3=fft(X1);
% X4=fft(X2);
X = fft(ifft(x).').'/sqrt(M/N); %%%ISFFT
%%% PLOT – |X[k,\ell]| במישור Delay–Doppler (אחרי ISFFT)
    %%% PLOT – |X[k,ℓ]| במישור Delay–Doppler (לשידור) 
 figure;
 imagesc(abs(X)); axis xy;
 colorbar;
 title('|X[n,m]| before Heisenberg (at TX)');
  xlabel('n '); ylabel('m');
  drawnow;
s_mat = ifft(X.')*sqrt(M); % Heisenberg transform
s = s_mat(:);

end
