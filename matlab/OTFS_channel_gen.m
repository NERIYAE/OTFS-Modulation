function [taps, delay_taps, Doppler_taps, chan_coef] = OTFS_channel_gen(N, M)
% Scenario: moving user at 120 km/h, carrier 2 GHz, range 30 km
% Generates a simple 3 tap OTFS channel with delay and Doppler indices.
% This demo version adapts parameters for clarity.

c   = 3e8;               % speed of light [m/s]
v   = 120/3.6;           % 120 km/h -> m/s
f_c = 2e9;               % carrier 2 GHz
fd  = v/c * f_c;         % Doppler [Hz]

Delta_f = 250;           % subcarrier spacing [Hz] (demo)
T_sym   = 1/Delta_f;     % symbol duration [s]

k_dopp = round(fd / Delta_f);   % Doppler index
tau      = 30e3 / c;            % 30 km propagation delay [s]
l_delay  = round(tau / T_sym);  % delay index

taps        = 3;
delay_taps  = [l_delay  l_delay  l_delay];
Doppler_taps= [ k_dopp , -k_dopp , 0 ];
chan_coef   = (randn(3,1)+1i*randn(3,1))/sqrt(6);  % Rayleigh with unit power
end
