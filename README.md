

````markdown
# OTFS Modulation Demo (MATLAB)

Minimal end-to-end demo of **how OTFS works**: bits → QAM on the delay–Doppler grid → ISFFT/Heisenberg for TX → channel with delay+Doppler → demodulation (Wigner+SFFT) → Message-Passing detection → BER.

## What’s included
- `matlab/run_demo.m` — single entry point.
- Core functions: `OTFS_modulation.m`, `OTFS_demodulation.m`, `OTFS_channel_gen.m`, `OTFS_channel_output.m`, `OTFS_mp_detector.m`.

## Requirements
- MATLAB R2020a+ with Communications Toolbox (`qammod`, `qamdemod`).

## Quick start
1. Open the `matlab/` folder in MATLAB.
2. Run:
   ```matlab
   run_demo
````

3. You will see:

   * Delay–Doppler magnitude maps before and after the channel.
   * Detected constellation vs. ideal constellation.
   * BER printed in the console.

## Repository layout

```
otfs-otfs-demo/
├─ matlab/
│  ├─ run_demo.m
│  ├─ OTFS_modulation.m
│  ├─ OTFS_demodulation.m
│  ├─ OTFS_channel_gen.m
│  ├─ OTFS_channel_output.m
│  └─ OTFS_mp_detector.m
```

## Notes

* Demo defaults: QPSK, `N = 32`, `M = 32`, and a simple 3-tap channel with delay and Doppler indices.
* Plots are enabled for quick visual inspection.

```

Based on your Hebrew draft README. :contentReference[oaicite:0]{index=0}
```
