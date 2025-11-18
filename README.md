#  African SME Job Creation Predictor
## Eradicating Youth Unemployment Through Digital Transformation

[![ML Model](https://img.shields.io/badge/Model-Random%20Forest-success)](https://scikit-learn.org/)
[![Accuracy](https://img.shields.io/badge/R²-97.9%25-brightgreen)](/)
[![API](https://img.shields.io/badge/API-FastAPI-009688)](https://fastapi.tiangolo.com/)
[![Mobile](https://img.shields.io/badge/Mobile-Flutter-02569B)](https://flutter.dev/)
[![Mission](https://img.shields.io/badge/Mission-SDG%208-orange)](https://sdgs.un.org/goals/goal8)

---

##  Mission Statement

**The Challenge**: Youth unemployment in Africa exceeds 20%, yet SMEs create 80% of all jobs.

**Our Solution**: Predict how many jobs an African SME will create based on their digital transformation strategies, revenue, and business characteristics.

**The Impact**: Enable entrepreneurs, investors, and policymakers to identify high-potential SMEs for job creation, make data-driven funding decisions, and design effective digital transformation programs that maximize youth employment.

---

##  Why This Matters

- **Problem**: 60% of Africa's unemployed are youth (ages 15-24)
- **Opportunity**: African SMEs employ 80% of the workforce
- **Solution**: Machine learning predicts job creation potential with **97.9% accuracy**
- **Action**: Target resources to SMEs that will create the most jobs

This project directly addresses **UN SDG 8: Decent Work and Economic Growth** by providing actionable insights into which digital strategies help African businesses hire more young people.

---

##  Dataset

**Source**: African SME Digital Transformation Survey  
**Geographic Coverage**: 5 countries (Ghana, Kenya, Nigeria, Rwanda, South Africa)  
**Industry Coverage**: 6 sectors (Education, Farming, Finance, Logistics, Manufacturing, Retail)  
**Sample Size**: 1,000 real African SMEs  
**Target Variable**: Number of employees (direct job creation metric)  
**Features**: 30 comprehensive business, digital, and contextual indicators

### Key Features Include:
- **Financial Metrics**: Annual revenue, growth rate, revenue per employee
- **Digital Adoption**: Number of tools, tech adoption level, digital tools used
- **Challenges**: Cost, skills gap, internet access, regulation, awareness
- **Context**: Country, sector, funding stage, ownership, remote work policy

---

##  Model Performance

### Winner: Random Forest Regressor 

| Model | Train R² | Test R² | Test RMSE | Test MSE |
|-------|----------|---------|-----------|----------|
| Linear Regression | 0.242 | 0.213 | 130.05 | 16,913 |
| SGD Regressor | 0.242 | 0.212 | 130.13 | 16,933 |
| Decision Tree | 0.985 | 0.943 | 35.07 | 1,230 |
| **Random Forest** | **0.996** | **0.979** | **21.31** | **454** |

**Why Random Forest Wins**:
-  **97.9% accuracy** in predicting employee count
-  Only **±21 employees** average prediction error
-  Minimal overfitting (0.017 gap between train/test)
-  Captures complex non-linear relationships between digital tools, funding, and hiring
-  Handles categorical features (countries, sectors) naturally

**Real-World Meaning**: When predicting if an SME will have 100 or 200 employees, our model is typically off by only ±21 employees—accurate enough for investment and policy decisions.

---

##  Technical Architecture

### Three-Component System:

```

  1. JUPYTER NOTEBOOK (ML Pipeline)                  
     • Data loading & exploration                    
     • Feature engineering (30 features)             
     • Train 4 models (LR, SGD, DT, RF)             
     • Generate 7+ visualizations                    
     • Export best model (Random Forest)             

                         ↓

  2. FASTAPI BACKEND (Prediction Service)            
     • POST /predict endpoint                        
     • Pydantic validation (30 features)             
     • CORS middleware                               
     • Range constraints & data types                
     • Swagger UI documentation                      

                         ↓

  3. FLUTTER MOBILE APP (User Interface)             
     • Clean Material 3 UI                           
     • 30-feature input form                         
     • Real-time predictions                         
     • Beautiful result display                      
     • Cross-platform (iOS/Android/Web)              

```

---

##  Live Deployment

**API Endpoint**: `https://your-api.onrender.com/predict`  
**Swagger Documentation**: `https://your-api.onrender.com/docs`  
**Video Demo**: [YouTube Link - 5 min demo](https://youtu.be/your-video-id)

> Update these after deployment

---

##  Quick Start

### 1⃣ Train the Model

```bash
cd summative/linear_regression
pip install -r requirements.txt
jupyter notebook multivariate.ipynb
# Run all cells to train models and generate visualizations
```

**Output**: 
- `best_model.pkl` (Random Forest, 97.9% accuracy)
- `scaler.pkl` (StandardScaler for feature normalization)
- `feature_names.pkl` (30 feature names)
- 7+ visualization PNG files

### 2⃣ Run the API Locally

```bash
cd summative/API
pip install -r requirements.txt
python prediction.py
# API runs at http://localhost:8000
# Docs at http://localhost:8000/docs
```

### 3⃣ Deploy API to Render

1. Push code to GitHub
2. Create Web Service on [Render](https://render.com)
3. Build: `pip install -r summative/API/requirements.txt`
4. Start: `cd summative/API && uvicorn prediction:app --host 0.0.0.0 --port $PORT`
5. Copy public URL

### 4⃣ Run Mobile App

```bash
cd summative/FlutterApp/upredict
# Update API URL in lib/main.dart line 106
flutter pub get
flutter run
```

**Or build APK**:
```bash
flutter build apk
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

---

##  App Features

### User-Friendly Interface:
-  **4 Numeric Inputs**: Revenue, growth, digital tools, revenue/employee
-  **5 Challenge Checkboxes**: Cost, skills, internet, regulation, awareness
-  **6 Smart Dropdowns**: Country, sector, tech level, funding, ownership, remote work
-  **AI-Powered Results**: Predicted employee count with contextual interpretation
-  **Visual Feedback**: Color-coded chips showing country, sector, tech level

### Interpretation Scale:
-  **300+ jobs**: Excellent - High job creation potential
-  **200+ jobs**: Very Good - Strong employment impact
-  **100+ jobs**: Good - Moderate job creation
-  **50-100 jobs**: Fair - Consider digital strategies
-  **<50 jobs**: Limited - Needs transformation investment

---

##  API Documentation

### POST `/predict`

**Request** (all 30 features required):
```json
{
  "annual_revenue": 500000.0,
  "growth_last_yr": 25.0,
  "num_digital_tools": 2,
  "challenge_cost": 1,
  "challenge_skills": 0,
  "challenge_internet": 0,
  "challenge_regulation": 0,
  "challenge_awareness": 1,
  "revenue_per_employee": 2500.0,
  "country_Ghana": 0,
  "country_Kenya": 1,
  "country_Nigeria": 0,
  "country_Rwanda": 0,
  "country_South_Africa": 0,
  "sector_Education": 0,
  "sector_Farming": 0,
  "sector_Finance": 1,
  "sector_Logistics": 0,
  "sector_Manufacturing": 0,
  "sector_Retail": 0,
  "tech_adoption_level_High": 0,
  "tech_adoption_level_Low": 0,
  "tech_adoption_level_Medium": 1,
  "funding_status_Bootstrapped": 0,
  "funding_status_Seed": 1,
  "funding_status_Series_A": 0,
  "female_owned_No": 0,
  "female_owned_Yes": 1,
  "remote_work_policy_Full": 0,
  "remote_work_policy_Partial": 1
}
```

**Response**:
```json
{
  "predicted_employees": 245,
  "message": "Prediction successful",
  "interpretation": " Very Good: Strong job creation potential. Expected to create 200+ jobs.",
  "country": "Kenya",
  "sector": "Finance",
  "tech_level": "Medium"
}
```

**Validation**:
-  Data type enforcement (int/float)
-  Range constraints (e.g., revenue: $1K-$100M)
-  One-hot encoding validation (exactly one per category)
-  Comprehensive error messages

---

##  Visualizations Generated

The Jupyter notebook creates 7+ publication-ready visualizations:

1. **Correlation Heatmap** - Relationships between 30 features
2. **Employee Distribution** - Histogram & box plot of job creation
3. **Model Comparison Bar Chart** - R² and MSE across 4 models
4. **Actual vs Predicted Scatter** - All models with Random Forest highlighted
5. **Feature Importance** - Top predictors of job creation
6. **Loss Curves** - SGD training/validation loss over epochs
7. **Country/Sector Analysis** - Job creation patterns by region

---

##  Technologies

| Component | Stack |
|-----------|-------|
| **ML Framework** | scikit-learn 1.3.2 |
| **Data Analysis** | pandas, numpy, matplotlib, seaborn |
| **Backend API** | FastAPI 0.104.1, Pydantic 2.5.0 |
| **Web Server** | Uvicorn 0.24.0 |
| **Mobile Framework** | Flutter 3.9+, Dart |
| **HTTP Client** | http package 1.1.0 |
| **Deployment** | Render.com |
| **Version Control** | Git, GitHub |

---

##  Project Structure

```
Summative-ML/
 README.md (this file)
 summative/
    linear_regression/
       multivariate.ipynb                      # Main ML pipeline
       african_sme_digital_transformation.csv  # Dataset (1000 SMEs)
       requirements.txt                        # Python deps
       correlation_heatmap.png                 # Viz 1
       target_distribution.png                 # Viz 2
       model_comparison.png                    # Viz 3
       actual_vs_predicted_*.png               # Viz 4-7
    API/
       prediction.py                           # FastAPI app (Pydantic V2)
       requirements.txt                        # API deps
       best_model.pkl                          # Random Forest (generated)
       scaler.pkl                              # StandardScaler (generated)
       feature_names.pkl                       # 30 features (generated)
    FlutterApp/upredict/
        lib/main.dart                           # Flutter app (806 lines)
        pubspec.yaml                            # Flutter deps
        android/ios/web/                        # Platform configs
```

