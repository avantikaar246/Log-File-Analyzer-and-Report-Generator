# USAGE GUIDE

This guide explains how to run the Log File Analyzer & Report Generator script.

---

## 1️⃣ Make the script executable

```bash
chmod +x src/unix.sh
```

---

## 2️⃣ Run the script with log files and keywords

Example:

```bash
./src/unix.sh sample_logs/log.log sample_logs/log1.log -- ERROR INFO WARN
```

---

## 3️⃣ General command format

```
./src/unix.sh <log1> <log2> ... -- <keyword1> <keyword2> ...
```

---

## 4️⃣ Output

Reports are automatically generated inside the `reports/` folder as:

```
report_YYYY-MM-DD_HH-MM-SS.txt
```

Each report includes:

- Keyword occurrence counts  
- Hourly log distribution  
- IP address analysis  
- Per-file processing summary  

---

## 5️⃣ Requirements

- Linux or macOS terminal  
- Bash shell  
- Read permissions for log files  
