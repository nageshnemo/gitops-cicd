from flask import Flask, render_template_string

app = Flask(__name__)

@app.route('/')
def hello():
    # HTML template for a simple styled response
    html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>GKE Hosted Application</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin: 0;
                padding: 0;
                background-color: #f4f4f9;
            }
            header {
                background-color: #6200ea;
                color: white;
                padding: 20px 0;
            }
            h1 {
                margin: 0;
            }
            p {
                font-size: 18px;
                color: #333;
            }
        </style>
    </head>
    <body>
        <header>
            <h1>Welcome to My Application</h1>
        </header>
        <main>
            <p>This application is hosted on <strong>Google Kubernetes Engine and managed in ArgoCD(GKE)</strong>!</p>
        </main>
    </body>
    </html>
    """
    return render_template_string(html)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
