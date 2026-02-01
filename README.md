# Reference Flask App for Azure App Services

This is a project with reference Flask application. Projects includes script creating AppService Web App with all required configuration to run application in Azure cloud without problems.

## Run the application locally

1. Create and activate a virtual environment:
   - Windows (PowerShell):

     ```cmd
     python -m venv .venv
     .venv\Scripts\Activate.ps1
     pip install -r requirements.txt
     ```
  
   - Linux (Bash):

     ```sh
     python3 -m venv .venv
     source .venv/bin/activate
     pip install -r requirements.txt
     ````

1. Configure the message to be shown:
    - copy file `.env.example` to `.env`, edit message in the `.env` file;
    - or configure it directly in the system:
      - Windows (PowerShell): `$env:APP_MESSAGE="Hello from your machine!"`
      - Linux (Bash): `export APP_MESSAGE="Hello from your machine!"`

1. Start the app:
    - `python src/app.py`

The app will be available at http://127.0.0.1:5000/ and the health check at http://127.0.0.1:5000/healthz.

## Run the application in the Azure cloud

1. In file `infrastructure/infra-create.sh`, change region (location) to one available to you.
1. In Azure portal open **Cloud Shell**. Verify if shell uses Bash. If it uses PowerShell - switch to Bash.
1. Paste the content of `infrastructure/infra-create.sh` into **Cloud Shell**. Wait until script is completed. Verify if there is no error.
1. In VS Code (or Codespaces) install **Azure Tools** extension: press Ctrl-Shift-X, select **Azure Tools**, and click Install.
1. In VS Code (Codespaces):
   - Open **Azure** extension (A icon on the left sidebar, or press Ctrl-Shift-A).
   - Sign in to Azure (if required).
   - Expand *Azure for Students*, expand *AppService*, right click your application, select **Deploy to Web App...**.
1. Wait until deployment is completed.
1. Open Azure Portal. Open your application in App Services, select Overview, click Browse tab.

The app will be available at https://flask-app-00000.azurewebsites.net/ (number will be diffrent).

## Notes

1. As plans F1 and B1 are very slow, restarts often, and sleeps automatically, script configures web application as **Always on** (see: application > Settings > Configuration > General Settings tab > Always on).
1. When you develop your application, you can switch to B2 plan for the moment to deploy application faster (AppService > AppService plan > Scale up). It makes a huge change!
1. AppService > Configuration > Settings > Stack Settings tab > Startup Command explanation: 
   1. Application is started by `gunicorn` web server and not `python` interpreter, because `gunicorn` automatically restarts application in case of failure - it is recommended way of running Python apps in production.
   1. `--bind=0.0.0.0:8000` : application uses port 8000 required by AppService, instead of default Flask port 5000.
   1. `src.app:app` : Flask application object named **app**, is located in **app.py** file inside **src** folder (`<folder>.<file>:<object>`).
1. The last line `app.run(debug=True, port=5000)` is executed only when app.py is started by Python. When `grunicorn` starts application this line is ignored.