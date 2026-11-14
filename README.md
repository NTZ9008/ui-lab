# ui-lab

Automated UI testing lab repository for **ITDS362**, covering **Part 1 (Selenium IDE)** and **Part 3 (Robot Framework)** against the Selenium web form practice page and QuickPizza.

## Repository Structure

- **`selenium-ide/`**: Contains the Selenium IDE test suite (`ui-lab.side`) with the `web form` and `QP-01 customer` tests, plus the exported JUnit 4 file (`QP01customerTest.java`). Tests run from the command line through `selenium-side-runner` against ChromeDriver.
- **`robot/`**: Contains the Python dependencies (`requirements.txt`), Robot Framework (`7.5.1`) and SeleniumLibrary (`6.9.0`) test suites (`first.robot`, `web_form.robot`, `pizza_scenario.robot`), reusable keywords and locators (`resources/quickpizza.resource`), and committed headless run artifacts (`results/run1` and `results/run2`).

## How to Run

### Part 1 — Selenium IDE (`selenium-ide/`)

Ensure `CHROMEDRIVER` is set and added to `PATH`, then run the `.side` suite from `selenium-ide/`:

```powershell
$env:CHROMEDRIVER = "C:\drivers\chromedriver-win64\chromedriver.exe"
$env:Path = (Split-Path $env:CHROMEDRIVER) + ";" + $env:Path
cd selenium-ide
npx --yes selenium-side-runner@4.0.13 ui-lab.side
```

### Part 3 — Robot Framework (`robot/`)

Activate the virtual environment inside `robot/`, ensure `CHROMEDRIVER` is set, and run any suite or the headless QuickPizza scenario:

```powershell
$env:CHROMEDRIVER = "C:\drivers\chromedriver-win64\chromedriver.exe"
cd robot
.\.venv\Scripts\Activate.ps1
robot first.robot
robot web_form.robot
robot -d results/run1 -v BROWSER:headlesschrome pizza_scenario.robot
```
