# POWERCFG

## Prevent mouse from waking up computer

Administrative command prompt.

```powershell
powercfg /devicequery wake_armed
powercfg /devicedisablewake "HID-compliant mouse"
```
