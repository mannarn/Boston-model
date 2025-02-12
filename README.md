# Boston Housing Price Prediction with CI/CD

## Architecture Overview

### Core Components:
1. **GitHub Actions**: Orchestrates the entire CI/CD pipeline
2. **Docker Containers**:
   - Training Container: XGBoost environment with hyperparameter inputs
   - API Container: Flask-based prediction service
3. **Kubernetes Jobs**: Parallel hyperparameter tuning trials
4. **Minikube**: Local Kubernetes cluster for testing
5. **XGBoost**: Regression model for price prediction
6. **Joblib**: Model serialization/deserialization

## Key Implementation Steps

### 1. Hyperparameter Tuning System
- **Parallel Kubernetes Jobs**: Created 16 combinations (2^4 grid search)
- **Dynamic Job Generation**: PowerShell script replaces template values
- **Artifact Management**: Models saved with MSE in filenames for versioning

### 2. CI/CD Pipeline Stages
1. **Image Building**:
   - Build and push training Docker image
   - Build and push API service image

2. **Model Optimization**:
   - Start Minikube cluster
   - Execute parallel training jobs
   - Collect and compare MSE metrics

3. **Conditional Deployment**:
   - Only deploy if new model outperforms previous best
   - Update MSE baseline in repository

