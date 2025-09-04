function y = OTFS_demodulation(N,M,r)
%% OTFS demodulation: 1. Wiegner transform, 2. SFFT
r_mat = reshape(r,M,N);
Y = fft(r_mat)/sqrt(M); % Wigner transform
Y = Y.';
y = ifft(fft(Y).').'/sqrt(N/M); % SFFT
%%% PLOT – המשטח ב-Delay-Doppler אחרי הדה-מודולציה
figure; imagesc(abs(y)); axis xy;
title('|\it{y}_{DD}| after demodulation'); xlabel('l'); ylabel('k');
colorbar; drawnow;

end
