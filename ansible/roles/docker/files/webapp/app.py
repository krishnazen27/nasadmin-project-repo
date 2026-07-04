import os
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template(
        "index.html",
        version=os.getenv("APP_VERSION", "development")
    )

@app.route("/health")
def health():
    return {
        "status": "UP",
        "version": os.getenv("APP_VERSION", "development")
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)