# 🧹 PAN Number Data Cleaning & Validation Project  

---

## 📖 About My Project  
This project is focused on **cleaning and validating Permanent Account Numbers (PANs)** from a dataset.  
PAN is a critical financial identity in India, and ensuring the accuracy of PAN data is important to reduce errors, avoid compliance issues, and prevent fraudulent entries.  

Using **Python (pandas & regex)**, this project automates the data cleaning process and applies strict validation checks to identify **Valid PANs** and **Invalid PANs**.  

---

## 📌 Project Overview  
The dataset initially contained several issues such as **missing PANs, duplicate records, inconsistent formatting, and invalid patterns**.  

The goal was to:  
- Clean the raw data.  
- Standardize PAN formats.  
- Apply validation logic based on official PAN rules.  
- Categorize each record as **Valid** or **Invalid**.  
- Generate a **summary report** for better understanding.  

---

## 📦 Project Requirements  
Before running this project, make sure you have the following installed:  

### 🔹 Programming Language  
- Python 3.8 or above  

### 🔹 Required Python Packages  
- **pandas** → For data manipulation & cleaning  
- **openpyxl** → For reading/writing Excel files  
- **re (Regex)** → For validating PAN format  

### 🔹 Install Dependencies  
- **pip install pandas** 
- **pip install openpyxl**
- **pip install re**

---

## 🎯 Objectives  
- Remove missing, blank, or duplicate PAN entries.  
- Standardize PAN numbers (trim spaces, convert to uppercase).  
- Validate PANs using strict rules:  
  - Exactly 10 characters long.  
  - Format: **AAAAA1234A** (5 letters, 4 digits, 1 letter).  
  - No adjacent duplicate characters.  
  - No sequential alphabets (ABCDE) or numbers (1234).  
- Categorize PANs as **Valid** or **Invalid**.  
- Generate a **summary report** with total records, valid PANs, invalid PANs, and missing PANs.  

---

## 📊 Insights from the Project  
- Many PAN entries were **missing or duplicated**, which had to be removed for accuracy.  
- Standardizing text (uppercase, no extra spaces) was essential before applying validation rules.  
- A considerable number of records failed validation due to **incorrect formats or patterns**, showing why automated validation is critical.  

---

## 🔄 Why Data Cleaning & Transformation is Important?  
Raw datasets are often messy — with typos, missing values, duplicates, and incorrect formats.  
For PAN numbers, this can mean:  
- **Compliance issues** if invalid PANs are processed.  
- **Fraudulent entries** slipping into financial systems.  
- **Wrong business insights** if inaccurate data is analyzed.  

By cleaning and validating, we ensure that only **trustworthy, standardized, and accurate records** are used.  

---

## 🌟 STAR Methodology  

### **Situation**  
The dataset of PAN numbers contained errors — missing values, duplicates, extra spaces, and invalid formats.  

### **Task**  
To clean and validate the dataset so that only **authentic and valid PANs** remain.  

### **Action**  
- Cleaned data by removing blanks, duplicates, and formatting inconsistencies.  
- Standardized all PANs to a uniform uppercase format.  
- Applied **validation logic** using Python (regex, custom functions).  
- Classified records as **Valid** or **Invalid** and created a summary report.  

### **Result**  
- Produced a **clean dataset** ready for business or compliance use.  
- Clear summary highlighting the distribution of valid vs invalid PANs.  
- Enhanced **data quality, accuracy, and trustworthiness**.  

---

## 📈 Impact of Data Cleaning  
- ✅ **Improved Accuracy**: Only valid PANs are retained.  
- ✅ **Reduced Risks**: Invalid or fraudulent records are removed.  
- ✅ **Reliable Analytics**: Reports and insights are based on accurate data.  
- ✅ **Automation**: Saves significant time compared to manual verification.  

---

## 🌟 About Me

Hi there! I'm Chirag Jain passionate about data-driven decision-making and business optimization. 
Skilled in SQL, Python, Power BI, Tableau, and Excel for data collection, cleaning, analysis, and visualization.
Always eager to learn, collaborate, and explore the power of data.
Eager to contribute as a Business Analyst and drive impact through data in a collaborative, growth-oriented environment.

Let's stay in touch! Feel free to connect with me on the following platform:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/chirag-jain-998117295/)
