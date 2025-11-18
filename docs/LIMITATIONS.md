# LIMITATIONS

This script works well for standard logs but has some limitations:

---

### ❗ Log Format Restriction
Works only with logs that follow:
```
YYYY-MM-DD HH:MM:SS <LEVEL> <MESSAGE>
```

### ❗ JSON and XML logs unsupported
The script cannot analyze structured logs.

### ❗ Color highlighting only in terminal
Reports saved in files do NOT contain color.

### ❗ IP extraction is basic
IP detection uses a simple regex — no IPv6 support.

### ❗ Hourly grouping depends on consistent formatting
If timestamps are missing or written differently, grouping reduces accuracy.

### ❗ Large log files (>1GB) may be slow
Because shell scripts are not optimized for massive data processing.
