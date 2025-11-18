# Log File Analyzer & Report Generator

A UNIX shell script that analyzes log files, highlights keywords, counts occurrences, extracts timestamps, computes hourly distributions, and generates summary reports.  
Designed for automation using cron jobs and suitable for Linux-based systems.

---

## 🔧 Features
- Accepts **multiple log files** and **multiple keywords**  
- Highlights keywords in color for easy reading  
- Generates **summary report files** inside `reports/`  
- Calculates **hourly log distribution**  
- Counts occurrences of **IP addresses**  
- Works with real or sample log files  
- Can be scheduled with **cron** for daily automated reporting  
- Includes complete documentation in the `docs/` folder  

---

## 🚀 Usage

### ▶️ Make the script executable:
```bash
chmod +x src/unix.sh
```

### ▶️ Run the script:

```bash
./src/unix.sh sample_logs/log.log sample_logs/log1.log -- ERROR INFO WARN
```

### ▶️ General format:

```
./unix.sh <logfile1> <logfile2> ... -- <keyword1> <keyword2> ...
```

---

## 📂 Project Structure

```
Log-File-Analyzer-and-Report-Generator/
│── src/
│   └── unix.sh
│── sample_logs/
│── reports/
│── docs/
│   ├── USAGE_GUIDE.md
│   ├── LIMITATIONS.md
│   ├── IMPROVEMENTS.md
│── cron/
│   └── cron_job_example.txt
│── README.md
│── LICENSE
│── .gitignore
```

---

## ⏰ Cron Automation Example

Add this to your crontab:

```bash
0 1 * * * /path/to/unix.sh /path/to/logs/*.log -- ERROR INFO WARN >> cron_output.log 2>&1
```

This runs every day at **1 AM** and updates reports automatically.

---

## 📘 Documentation

* `docs/USAGE_GUIDE.md` — how to run the script
* `docs/LIMITATIONS.md` — current limitations
* `docs/IMPROVEMENTS.md` — future enhancements

---

## 🧪 Sample Logs

Sample log files are included in the `sample_logs/` folder for easy testing.

---

## 📜 License

This project is licensed under the **MIT License**.
See the `LICENSE` file for details.

---

## 👩‍💻 Author

**R Avantikaa**

