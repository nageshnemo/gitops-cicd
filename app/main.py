from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, Google Cloud CI/CD with GitHub Actions!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
