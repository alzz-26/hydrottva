from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import joblib

app = Flask(__name__)

# Load model and scaler
model = tf.keras.models.load_model('hydroponic_yield_model.h5')
scaler = joblib.load('scaler.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        input_data = np.array([
            data['Ideal pH'],
            data['Average Temperature'],
            data['Nitrogen'],
            data['Phosphorus'],
            data['Potassium']
        ]).reshape(1, -1)

        # Scale the input data
        input_data_scaled = scaler.transform(input_data)
        yield_prediction = model.predict(input_data_scaled)[0][0]
        yield_percentage = round(yield_prediction * 100, 2)

        return jsonify({'yield_percentage': yield_percentage})
    except Exception as e:
        return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
