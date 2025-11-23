# prediction.py - African SME Job Creation Prediction API
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, field_validator, ConfigDict
from typing import Any
import pickle
import numpy as np
import uvicorn
import os

# Initialize FastAPI app
app = FastAPI(
    title="African SME Job Creation Prediction API",
    description="API for predicting employee count in African SMEs to help eradicate youth unemployment through data-driven digital transformation strategies",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load models
try:
    with open('summative/API/best_model.pkl', 'rb') as f:
        model = pickle.load(f)
    with open('summative/API/scaler.pkl', 'rb') as f:
        scaler = pickle.load(f)
    with open('summative/API/feature_names.pkl', 'rb') as f:
        feature_names = pickle.load(f)
    print("Model, scaler, and features loaded successfully!")
except Exception as e:
    print(f" Warning: Error loading models: {e}")
    print("Please run the Jupyter notebook first to generate model files")
    model = None
    scaler = None
    feature_names = []

# Define input data model with Pydantic
class PredictionInput(BaseModel):
    # Numeric features
    annual_revenue: float = Field(
        ..., 
        ge=1000.0, 
        le=100000000.0, 
        description="Annual revenue in USD - Range: $1,000 to $100M"
    )
    growth_last_yr: float = Field(
        ..., 
        ge=-100.0, 
        le=500.0, 
        description="Growth percentage last year - Range: -100% to 500%"
    )
    num_digital_tools: int = Field(
        ..., 
        ge=1, 
        le=3, 
        description="Number of digital tools used - Range: 1 to 3"
    )
    
    challenge_cost: int = Field(
        ..., 
        ge=0, 
        le=1, 
        description="1 if facing cost challenges, 0 otherwise"
    )
    challenge_skills: int = Field(
        ..., 
        ge=0, 
        le=1, 
        description="1 if facing skills challenges, 0 otherwise"
    )
    challenge_internet: int = Field(
        ..., 
        ge=0, 
        le=1, 
        description="1 if facing internet challenges, 0 otherwise"
    )
    challenge_regulation: int = Field(
        ..., 
        ge=0, 
        le=1, 
        description="1 if facing regulation challenges, 0 otherwise"
    )
    challenge_awareness: int = Field(
        ..., 
        ge=0, 
        le=1, 
        description="1 if facing awareness challenges, 0 otherwise"
    )
    
    revenue_per_employee: float = Field(
        ..., 
        ge=100.0, 
        le=1000000.0, 
        description="Revenue per employee in USD - Range: $100 to $1M"
    )
    
    # Country indicators (one-hot encoded - exactly one must be 1)
    country_Ghana: int = Field(..., ge=0, le=1, description="1 if Ghana, 0 otherwise")
    country_Kenya: int = Field(..., ge=0, le=1, description="1 if Kenya, 0 otherwise")
    country_Nigeria: int = Field(..., ge=0, le=1, description="1 if Nigeria, 0 otherwise")
    country_Rwanda: int = Field(..., ge=0, le=1, description="1 if Rwanda, 0 otherwise")
    country_South_Africa: int = Field(..., ge=0, le=1, description="1 if South Africa, 0 otherwise")
    
    # Sector indicators (one-hot encoded - exactly one must be 1)
    sector_Education: int = Field(..., ge=0, le=1, description="1 if Education sector, 0 otherwise")
    sector_Farming: int = Field(..., ge=0, le=1, description="1 if Farming sector, 0 otherwise")
    sector_Finance: int = Field(..., ge=0, le=1, description="1 if Finance sector, 0 otherwise")
    sector_Logistics: int = Field(..., ge=0, le=1, description="1 if Logistics sector, 0 otherwise")
    sector_Manufacturing: int = Field(..., ge=0, le=1, description="1 if Manufacturing sector, 0 otherwise")
    sector_Retail: int = Field(..., ge=0, le=1, description="1 if Retail sector, 0 otherwise")
    
    # Tech adoption level (one-hot encoded - exactly one must be 1)
    tech_adoption_level_High: int = Field(..., ge=0, le=1, description="1 if High tech adoption, 0 otherwise")
    tech_adoption_level_Low: int = Field(..., ge=0, le=1, description="1 if Low tech adoption, 0 otherwise")
    tech_adoption_level_Medium: int = Field(..., ge=0, le=1, description="1 if Medium tech adoption, 0 otherwise")
    
    # Funding status (one-hot encoded - exactly one must be 1)
    funding_status_Bootstrapped: int = Field(..., ge=0, le=1, description="1 if Bootstrapped, 0 otherwise")
    funding_status_Seed: int = Field(..., ge=0, le=1, description="1 if Seed funding, 0 otherwise")
    funding_status_Series_A: int = Field(..., ge=0, le=1, description="1 if Series A funding, 0 otherwise")
    
    # Female ownership (one-hot encoded - exactly one must be 1)
    female_owned_No: int = Field(..., ge=0, le=1, description="1 if not female-owned, 0 otherwise")
    female_owned_Yes: int = Field(..., ge=0, le=1, description="1 if female-owned, 0 otherwise")
    
    # Remote work policy (one-hot encoded - exactly one must be 1)
    remote_work_policy_Full: int = Field(..., ge=0, le=1, description="1 if full remote, 0 otherwise")
    remote_work_policy_Partial: int = Field(..., ge=0, le=1, description="1 if partial remote, 0 otherwise")
    
    model_config = ConfigDict(
        json_schema_extra={
            "example": {
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
        }
    )
    
    @field_validator('challenge_cost', 'challenge_skills', 'challenge_internet', 
                     'challenge_regulation', 'challenge_awareness',
                     'country_Ghana', 'country_Kenya', 'country_Nigeria', 'country_Rwanda', 'country_South_Africa',
                     'sector_Education', 'sector_Farming', 'sector_Finance', 'sector_Logistics', 'sector_Manufacturing', 'sector_Retail',
                     'tech_adoption_level_High', 'tech_adoption_level_Low', 'tech_adoption_level_Medium',
                     'funding_status_Bootstrapped', 'funding_status_Seed', 'funding_status_Series_A',
                     'female_owned_No', 'female_owned_Yes',
                     'remote_work_policy_Full', 'remote_work_policy_Partial')
    @classmethod
    def check_binary(cls, v: int) -> int:
        if v not in [0, 1]:
            raise ValueError('Binary indicators must be 0 or 1')
        return v


class PredictionOutput(BaseModel):
    predicted_employees: int
    message: str
    interpretation: str
    country: str
    sector: str
    tech_level: str
    input_features: dict


@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "Welcome to the African SME Job Creation Prediction API",
        "instructions": "Visit the /docs endpoint to make predictions the Swagger"
    }


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    if model is None:
        raise HTTPException(
            status_code=500, 
            detail="Model not loaded. Please run the Jupyter notebook first."
        )
    return {
        "status": "healthy",
        "model_loaded": model is not None,
        "model_type": str(type(model).__name__),
        "scaler_loaded": scaler is not None,
        "features_loaded": len(feature_names) > 0,
        "feature_count": len(feature_names)
    }


@app.post("/predict", response_model=PredictionOutput)
async def predict(input_data: PredictionInput):
    """
    Make an employee count prediction for an African SME.
    
    Based on digital transformation data from 1,000 African SMEs.
    Returns predicted number of employees (job creation potential).
    """
    if model is None or scaler is None:
        raise HTTPException(
            status_code=500,
            detail="Model not loaded. Please ensure the Jupyter notebook has been run and model files exist."
        )
    
    try:
        # Validate that exactly one option is selected for each categorical feature
        country_sum = (input_data.country_Ghana + input_data.country_Kenya + 
                      input_data.country_Nigeria + input_data.country_Rwanda + 
                      input_data.country_South_Africa)
        
        sector_sum = (input_data.sector_Education + input_data.sector_Farming + 
                     input_data.sector_Finance + input_data.sector_Logistics + 
                     input_data.sector_Manufacturing + input_data.sector_Retail)
        
        tech_sum = (input_data.tech_adoption_level_High + input_data.tech_adoption_level_Low + 
                   input_data.tech_adoption_level_Medium)
        
        funding_sum = (input_data.funding_status_Bootstrapped + input_data.funding_status_Seed + 
                      input_data.funding_status_Series_A)
        
        ownership_sum = input_data.female_owned_No + input_data.female_owned_Yes
        
        remote_sum = input_data.remote_work_policy_Full + input_data.remote_work_policy_Partial
        
        if country_sum != 1:
            raise ValueError("Exactly one country must be selected (set to 1)")
        if sector_sum != 1:
            raise ValueError("Exactly one sector must be selected (set to 1)")
        if tech_sum != 1:
            raise ValueError("Exactly one tech adoption level must be selected (set to 1)")
        if funding_sum != 1:
            raise ValueError("Exactly one funding status must be selected (set to 1)")
        if ownership_sum != 1:
            raise ValueError("Exactly one ownership status must be selected (set to 1)")
        if remote_sum != 1:
            raise ValueError("Exactly one remote work policy must be selected (set to 1)")
        
        # Convert input to array in the correct order matching feature_names
        input_dict = input_data.dict()
        input_array = np.array([[
            input_dict['annual_revenue'],
            input_dict['growth_last_yr'],
            input_dict['num_digital_tools'],
            input_dict['challenge_cost'],
            input_dict['challenge_skills'],
            input_dict['challenge_internet'],
            input_dict['challenge_regulation'],
            input_dict['challenge_awareness'],
            input_dict['revenue_per_employee'],
            input_dict['country_Ghana'],
            input_dict['country_Kenya'],
            input_dict['country_Nigeria'],
            input_dict['country_Rwanda'],
            input_dict['country_South_Africa'],
            input_dict['sector_Education'],
            input_dict['sector_Farming'],
            input_dict['sector_Finance'],
            input_dict['sector_Logistics'],
            input_dict['sector_Manufacturing'],
            input_dict['sector_Retail'],
            input_dict['tech_adoption_level_High'],
            input_dict['tech_adoption_level_Low'],
            input_dict['tech_adoption_level_Medium'],
            input_dict['funding_status_Bootstrapped'],
            input_dict['funding_status_Seed'],
            input_dict['funding_status_Series_A'],
            input_dict['female_owned_No'],
            input_dict['female_owned_Yes'],
            input_dict['remote_work_policy_Full'],
            input_dict['remote_work_policy_Partial']
        ]])
        
        # Scale the input
        input_scaled = scaler.transform(input_array)
        
        # Make prediction
        prediction = model.predict(input_scaled)[0]
        
        # Ensure prediction is within realistic bounds (5-499 employees from dataset)
        prediction = max(5, min(499, int(round(prediction))))
        
        # Determine country name
        country_name = ""
        if input_dict['country_Ghana'] == 1:
            country_name = "Ghana"
        elif input_dict['country_Kenya'] == 1:
            country_name = "Kenya"
        elif input_dict['country_Nigeria'] == 1:
            country_name = "Nigeria"
        elif input_dict['country_Rwanda'] == 1:
            country_name = "Rwanda"
        elif input_dict['country_South_Africa'] == 1:
            country_name = "South Africa"
        
        # Determine sector name
        sector_name = ""
        if input_dict['sector_Education'] == 1:
            sector_name = "Education"
        elif input_dict['sector_Farming'] == 1:
            sector_name = "Farming"
        elif input_dict['sector_Finance'] == 1:
            sector_name = "Finance"
        elif input_dict['sector_Logistics'] == 1:
            sector_name = "Logistics"
        elif input_dict['sector_Manufacturing'] == 1:
            sector_name = "Manufacturing"
        elif input_dict['sector_Retail'] == 1:
            sector_name = "Retail"
        
        # Determine tech level
        tech_level = ""
        if input_dict['tech_adoption_level_High'] == 1:
            tech_level = "High"
        elif input_dict['tech_adoption_level_Low'] == 1:
            tech_level = "Low"
        elif input_dict['tech_adoption_level_Medium'] == 1:
            tech_level = "Medium"
        
        # Generate interpretation
        if prediction >= 300:
            interpretation = "Excellent: High job creation potential! This SME is likely to create 300+ jobs, significantly contributing to youth employment."
        elif prediction >= 200:
            interpretation = "Very Good: Strong job creation potential. Expected to create 200+ jobs, making meaningful impact on youth unemployment."
        elif prediction >= 100:
            interpretation = "Good: Moderate job creation potential. Expected to create 100+ jobs, contributing to local employment."
        elif prediction >= 50:
            interpretation = "Fair: Below-average job creation. Expected to create 50-100 jobs. Consider enhancing digital strategies."
        else:
            interpretation = "Limited: Low job creation potential (<50 jobs). Recommend investing in digital transformation to scale hiring."
        
        return PredictionOutput(
            predicted_employees=prediction,
            message="Prediction successful",
            interpretation=interpretation,
            country=country_name,
            sector=sector_name,
            tech_level=tech_level,
            input_features=input_dict
        )
    
    except ValueError as ve:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid input values: {str(ve)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error making prediction: {str(e)}"
        )


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("prediction:app", host="0.0.0.0", port=port, reload=True)
