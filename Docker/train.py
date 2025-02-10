#Importing the required libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from xgboost import XGBRegressor
from sklearn.metrics import mean_squared_error
import joblib

#Loading the dataset
data_url = "http://lib.stat.cmu.edu/datasets/boston"
raw_df = pd.read_csv(data_url, sep="\s+", skiprows=22, header=None)
data = np.hstack([raw_df.values[::2, :], raw_df.values[1::2, :2]])
target = raw_df.values[1::2, 2]

column_names = [
    "CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM", "AGE", "DIS", "RAD", "TAX",
    "PTRATIO", "B", "LSTAT"
]

boston_df = pd.DataFrame(data, columns=column_names)
boston_df['MEDV'] = target

X = boston_df.drop('MEDV', axis=1)
y = boston_df['MEDV']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


# Get hyperparameters from command line
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("--n_estimators", type=int, required=True)
parser.add_argument("--max_depth", type=int, required=True)
parser.add_argument("--learning_rate", type=float, required=True)
parser.add_argument("--subsample", type=float, required=True)
args = parser.parse_args()

# Simulate command-line arguments
#args = parser.parse_args(['--n_estimators', '100', '--max_depth', '3', '--learning_rate', '0.1', '--subsample', '0.8'])
# MSE: 5.8546915926708305

# Train model
model = XGBRegressor(
    n_estimators=args.n_estimators,
    max_depth=args.max_depth,
    learning_rate=args.learning_rate,
    subsample=args.subsample
)
model.fit(X_train, y_train)

# Evaluate
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
print(f"MSE: {mse}\n")


# Save model and metrics

joblib.dump(model, f"/data/model_{args.n_estimators}_{args.max_depth}.joblib")
with open(f"/data/metrics_{args.n_estimators}_{args.max_depth}.txt", "w") as f:
    f.write(str(mse))
    """

# Save model and metrics in the current directory
joblib.dump(model, f"model_{args.n_estimators}_{args.max_depth}.joblib")
with open(f"metrics_{args.n_estimators}_{args.max_depth}.txt", "w") as f:
    f.write(str(mse))
    """