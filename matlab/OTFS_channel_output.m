function r = OTFS_channel_output(N,M,taps,delay_taps,Doppler_taps,chan_coef,sigma_2,s)
%% wireless channel and noise 
L = max(delay_taps);
s = [s(N*M-L+1:N*M);s];%add one cp
s_chan = 0;
for itao = 1:taps
    s_chan = s_chan+...
        chan_coef(itao)*circshift([s.*exp(1j*2*pi/M*(-L:-L+length(s)-1)*Doppler_taps(itao)/N).'...
        ;zeros(delay_taps(end),1)],delay_taps(itao));
end
noise = sqrt(sigma_2/2)*(randn(size(s_chan)) + 1i*randn(size(s_chan)));
r = s_chan + noise;
r = r(L+1:L+(N*M));%discard cp
%%% PLOT – השוואת כניסה/יציאה של הערוץ
figure;
subplot(2,1,1); plot(abs(s)); title('Input |s|');
subplot(2,1,2); plot(abs(r)); title('Output |r| = channel(s)+noise');
drawnow;

end
