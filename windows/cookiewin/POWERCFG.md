# POWERCFG

## Prevent mouse from waking up computer

Administrative command prompt.

```powershell
powercfg /devicequery wake_armed
powercfg /lastwake
powercfg /sleepstudy
powercfg /devicedisablewake "HID-compliant mouse"
```
