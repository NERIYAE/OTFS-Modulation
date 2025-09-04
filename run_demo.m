function run_demo()
% Minimal end-to-end OTFS demo: bits -> OTFS -> channel -> demod -> MP detector
clc; close all;

% ---- Parameters ----
N = 32; M = 32;          % OTFS frame: N Doppler bins, M delay bins
M_mod = 4;               % QPSK
SNR_dB = 20;             % single SNR point for a quick run
rng(1);

M_bits = log2(M_mod);
N_syms = N*M; 
N_bits = N_syms*M_bits;

% ---- Transmitter ----
bits = randi([0 1], N_bits, 1);
sym_idx = bi2de(reshape(bits, N_syms, M_bits), 'left-msb');
x_vec = qammod(sym_idx, M_mod, 'gray', 'InputType','integer','UnitAveragePower', false);
x = reshape(x_vec, N, M);

s = OTFS_modulation(N, M, x);

% ---- Channel ----
[taps, delay_taps, Doppler_taps, chan_coef] = OTFS_channel_gen(N, M);
noise_var = 0.01;  % quick demo noise power
r = OTFS_channel_output(N, M, taps, delay_taps, Doppler_taps, chan_coef, noise_var, s);

% ---- Receiver ----
y = OTFS_demodulation(N, M, r);
x_est = OTFS_mp_detector(N, M, M_mod, taps, delay_taps, Doppler_taps, chan_coef, noise_var, y);

% ---- BER ----
rx_idx = qamdemod(x_est, M_mod, 'gray', 'OutputType','integer', 'UnitAveragePower', false);
bits_hat = reshape(de2bi(rx_idx, M_bits, 'left-msb'), N_bits, 1);
BER = mean(bits ~= bits_hat);

fprintf('BER @ SNR = %gdB: %g\n', SNR_dB, BER);
end
