# Flask App for Azure App Services

This is a sample Flask application ready to be deployed to Azure App Services.

## Run locally

1. Create and activate a virtual environment:
	- Windows (PowerShell):
	  - `python -m venv .venv`
	  - `.venv\Scripts\Activate.ps1`
    - Linux (Bash):
      - `python3 -m venv .venv`
      - `source .venv\bin\activate`    
1. Install dependencies:
	- `pip install -r requirements.txt`
1. (Optional) Set the message shown on the home page:
    - copy file `.env.example` to `.env`, and edit message in the `.env` file
    - or configure it directly in the system:
      - Windows (PowerShell):
     	- `$env:APP_MESSAGE="Hello from your machine!"`
      - Linux (Bash):
        - `export APP_MESSAGE="Hello from your machine!"`
1. Start the app:
    - `python app/app.py`

The app will be available at http://127.0.0.1:5000/ and the health check at http://127.0.0.1:5000/healthz.

## Run in the Azure cloud

1. In file `infrastructure/infra-create.ps1` change region to one available to you.
1. In Azure portal open Azure Shell. Verify if shell uses PowerShell.
1. Paste the content of `infrastructure/infra-create.ps1` into Shell. Wait until script is completed. Verify if there is no errors.
1. In VSCode open Azure extension (A icon on the left sidebar), select your subscription, open AppService, open your application and deploy the repository.
1. Wait until deployment is completed.

The app will be available at https://flask-app-00000.azurewebsites.net/ (number will be diffrent).

## Notes

1. Flask by default uses port 5000.
1. App service requires port 8000. 