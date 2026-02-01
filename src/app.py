import os
from flask import Flask, jsonify
from dotenv import load_dotenv


load_dotenv()

app = Flask(__name__)

@app.route('/')
def hello_world():
    message = os.getenv("APP_MESSAGE", "Hello, World!")
    return message + "v5"

@app.route('/healthz')
def health_check():
    return jsonify({"status": "ok"}), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
