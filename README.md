# 🛡️ Advanced Bank Fraud Detection SQL Scripts

This repository provides a comprehensive set of **advanced SQL queries** designed for **fraud detection and behavioral analytics** in banking environments. These queries can help analysts flag suspicious patterns, detect outliers, and build foundational insights for fraud prevention systems.

---

## 📊 Use Cases

These scripts are applicable for:

- 📈 Building fraud detection dashboards (e.g., Power BI, Tableau)
- 🧠 Feeding fraud signals into machine learning models
- 🚨 Creating scheduled reports or alerts
- 🔍 Ad-hoc investigations by fraud analysts

---

## 📁 SQL Scripts Included

Each block targets a specific fraud pattern:

| # | Description | Purpose |
|--:|-------------|---------|
| 1 | **Transaction Spike Detection** | Identify outliers using average + 3×STD deviation |
| 2 | **Unusual Location Detection** | Spot new transaction locations per customer |
| 3 | **Failed Login Monitoring** | Detect brute-force or compromised account attempts |
| 4 | **High-Frequency Transactions** | Catch burst transactions in short timeframes |
| 5 | **Threshold Evasion Detection** | Transactions just below review limits (e.g., 5000 USD) |
| 6 | **Unusual Merchant Category Use** | Flag merchant category anomalies per user |
| 7 | **Velocity Check (Geo Distance)** | Detect simultaneous usage in distant areas |
| 8 | **Aggregate Risk Scoring** | Heuristic-based scoring on behavior factors |

---

## 🚀 Getting Started

1. Download or clone this repository.
2. Import `bank_fraud_detection_scripts.sql` into your database query tool.
3. Modify table/column names if needed to match your schema.
4. Run queries individually or integrate into your fraud analytics pipeline.

---

## ✅ Requirements

- SQL-compatible environment (PostgreSQL, SQL Server, MySQL, etc.)
- Tables: `transactions`, `login_attempts` (example schema assumed)
- Optional: Analytics layer for visualization (e.g., Power BI)

---

## ⚠️ Disclaimer

> These scripts are provided for demonstration and educational purposes only.  
> Always validate against real datasets and adapt for compliance, scale, and accuracy in production systems.

---

## 👨‍💻 Author
Contributions and feedback are welcome.

---

## 📄 License

This project is licensed under the MIT License.
