from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import pandas as pd
import joblib
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
import re


# File paths
DATASET_PATH = 'cleaned_hydroponic_crops_with_npk.csv'
MODEL_PATH = 'hydroponic_yield_model.h5'
SCALER_PATH = 'scaler.pkl'

# Load dataset and train model

def clean_numeric_values(value):
    """Convert values like '25-30' into their average temperature."""
    if isinstance(value, str):
        match = re.match(r'^(\d+)-(\d+)$', value)
        if match:
            return (float(match.group(1)) + float(match.group(2))) / 2
        try:
            return float(value)
        except ValueError:
            return np.nan  # Convert unprocessable values to NaN
    return value

def train_and_save_model():
    df = pd.read_csv(DATASET_PATH)
    
    # Apply cleaning function to numeric columns
    for col in ['Nitrogen', 'Phosphorus', 'Potassium', 'Ideal pH', 'Average Temperature']:
        df[col] = df[col].apply(clean_numeric_values)
    
    # Drop rows with NaN values after conversion
    df = df.dropna()
    
    X = df[['Ideal pH', 'Average Temperature', 'Nitrogen', 'Phosphorus', 'Potassium']]
    # Determine max yield in dataset for percentage conversion
    max_yield = df['Yield'].max()

    # Convert yield to percentage
    df['Yield_Percentage'] = (df['Yield'] / max_yield) * 100
    y = df['Yield_Percentage'] / 100   # Scale yield to 0-1 range

    # Scale the features
    scaler = MinMaxScaler()
    X_scaled = scaler.fit_transform(X)
    joblib.dump(scaler, SCALER_PATH)  # Save the scaler

    # Train-test split
    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42)

    # Define the model
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(64, input_shape=(X_train.shape[1],), activation='relu'),
        tf.keras.layers.Dense(32, activation='relu'),
        tf.keras.layers.Dense(1, activation='sigmoid')
    ])

    model.compile(optimizer='adam', loss='mean_squared_error', metrics=['mae'])
    model.fit(X_train, y_train, epochs=50, batch_size=8, validation_split=0.1)
    model.save(MODEL_PATH)
    print('Model and scaler saved successfully!')

# Train and save model if not already present
try:
    open(MODEL_PATH)
    open(SCALER_PATH)
    print("Model and scaler already exist. Skipping training.")
except FileNotFoundError:
    train_and_save_model()

