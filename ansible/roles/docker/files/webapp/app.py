from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Docker on AWS EC2!  to the webapp.py file new updated code"

app.run(host="0.0.0.0", port=80)
