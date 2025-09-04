# OTFS Modulation Demo (MATLAB)

דמו מינימלי שממחיש **איך OTFS עובד** מקצה לקצה: יצירת ביטים → מיפוי QAM במישור Delay–Doppler → ISFFT/Heisenberg לשידור → ערוץ עם דילאי+דופלר → דה־מודולציה (Wigner+SFFT) → גילוי בעזרת Message Passing → חישוב BER.

## מה יש פה
- `matlab/run_demo.m` — הפעלת הדמו מקצה לקצה.
- פונקציות ליבה: `OTFS_modulation.m`, `OTFS_demodulation.m`, `OTFS_channel_gen.m`, `OTFS_channel_output.m`, `OTFS_mp_detector.m`.

## דרישות
- MATLAB R2020a ומעלה עם Communications Toolbox (לתמיכת `qammod/qamdemod`).

## התחלה מהירה
1. פתחו את התיקייה `matlab/` ב-MATLAB.
2. הריצו:
   ```matlab
   run_demo
   ```
3. תראו:
   - מפות Delay–Doppler לפני ואחרי הערוץ.
   - קונסטלציה מזוהה לעומת אידאלית.
   - BER מודפס במסוף.

## מבנה
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
