# UI lab results

Tool parts that I chose: Part 1 (Selenium IDE) and Part 3 (Robot Framework)

## Part 0
- Step 0.1, Chrome version: Google Chrome 157.0.8103.51 (Official Build) (64-bit)
- Step 0.3, ChromeDriver version: ChromeDriver 157.0.8103.51 (653674df293788cf4932c40d914e9e15b41a2d31-refs/branch-heads/8103_38@{#9})
- Step 0.4, locator of Pizza, Please!: button[name="pizza-please"]
- Step 0.4, locator of Excluded tools: select
- Step 0.4, locator of Must be vegetarian: #default-checkbox
- Step 0.4, locator of Custom Pizza Name: input#pizza-name
- Step 0.5, pizza name, tool and calories of the run by hand: Lab Pizza 20261114-185452, tool: Scissors, calories per slice: 425

| Step | Actual result | Pass or fail |
|------|---------------|--------------|
| 1 | Heading "Looking to break out of your pizza routine?" appeared | Pass |
| 2 | Max Calories per Slice, Excluded tools, Must be vegetarian, and Custom Pizza Name appeared | Pass |
| 3 | Max Calories per Slice showed 600, Knife selected, Must be vegetarian ticked, Custom Pizza Name showed Lab Pizza 20261114-185452 | Pass |
| 4 | Recommendation showed Name: Lab Pizza 20261114-185452, Tool: Scissors, Calories per slice: 425 | Pass |
| 5 | Page displayed "Please log in first." below Love it! | Pass |
| 6 | Admin login succeeded and "Latest pizza recommendations" appeared | Pass |
| 7 | Admin list showed "Lab Pizza 20261114-185452 (tool=Scissors, ingredients_number=5) (newest)" | Pass |

## Part 1: Selenium IDE
- Firefox version and Node.js version: Mozilla Firefox 160.0 (64-bit), Node.js v22.20.0
- Step 1.4, the line of the failed check and the line Tests:
  `Actual value 'Received!' did not match 'Received' during assertText:id=message:Received`
  `Tests:       1 failed, 1 total` (Time: `3.574 s`; after restoring `Received!`: `Tests: 1 passed, 1 total`, `2097 ms`)
- Step 1.5, target chosen for Submit, and why the recorded one was fragile: `xpath=//button[@type='submit']`. The recorded `css=.btn` target relies on Bootstrap visual styling classes that break if styling changes or if another `.btn` element appears before Submit, whereas `xpath=//button[@type='submit']` anchors directly to the button's semantic `type="submit"` attribute.
- Step 1.6, commands changed, added or deleted after recording: Replaced default recorded targets (`id=floating_filled` and ambiguous `id=pizza-name`) with `xpath=//label[normalize-space()='Max Calories per Slice']/../input` and `css=input#pizza-name`, and used `addSelection` (`css=select`, `label=Knife`) on the excluded-tools multi-select; omitted redundant recording-only clicks and window resize steps; and added explicit synchronization (`waitForElementVisible`, `waitForElementPresent` for `xpath=//select/option[normalize-space()='Knife']`), dynamic naming (`executeScript` + `echo` for `Lab Pizza YYYYMMDD-HHMMSS`), and input, recommendation, and rating assertions (`assertValue`, `assertSelectedLabel`, `assertChecked`, `assertText`, `assertNotText`, `storeText` + `executeScript` + `assert`, and `id=rate-result` -> `Please log in first.`).
- Step 1.6, the pizza names of run 1 and run 2, from the lines info: echo:
  - Run 1: `info: echo: Lab Pizza 20261114-190305`
  - Run 2: `info: echo: Lab Pizza 20261114-190336`
- Step 1.6, the line Tests: of both runs:
  - Run 1: `Tests: 2 passed, 2 total` (`web form` `2292 ms`, `QP-01 customer` `11794 ms`, `Time: 15.071 s`)
  - Run 2: `Tests: 2 passed, 2 total` (`web form` `1983 ms`, `QP-01 customer` `6014 ms`, `Time: 8.908 s`)
- Step 1.7, one line of QP01customerTest.java that needs rewriting, and why: Line 91 (`assertThat(value, is("vars.get("pizzaName").toString()"));`) needs rewriting because Selenium IDE's Java JUnit export wrapped the interpolated `vars.get("pizzaName").toString()` inside double quotes without escaping, producing invalid Java syntax that fails to compile instead of `assertThat(value, is(vars.get("pizzaName").toString()));` (in addition, line 98 interpolates a literal `"vars.get(\"pizzaName\").toString()"` string and line 66 omits `.clear()` before `.sendKeys("600")`).

## Part 3: Robot Framework
- robot --version: `Robot Framework 7.5.1 (Python 3.11.9 on win32)`
- Step 3.2, failure message for the wrong title: `Title should have been 'Web Form' but was 'Web form'.` (`1 test, 0 passed, 1 failed`)
- Step 3.8, run 1, result, elapsed time and pizza name: `PASS` (`1 test, 1 passed, 0 failed`), elapsed time `11.178929 s` (suite `11.497259 s`), pizza name `Lab Pizza 20261114-191756` (recommended tool: `Scissors`, calories per slice: `600`)
- Step 3.8, run 2, result, elapsed time and pizza name: `PASS` (`1 test, 1 passed, 0 failed`), elapsed time `10.726844 s` (suite `11.070873 s`), pizza name `Lab Pizza 20261114-191834` (recommended tool: `Scissors`, calories per slice: `575`)

## Part B
1. On QuickPizza, three separate number inputs share the identical `id="floating_filled"` attribute (`$$("#floating_filled").length` returned `3` in Step 0.4), and `#pizza-name` also becomes duplicated between `<input id="pizza-name">` and `<h2 id="pizza-name">` once a recommendation renders. Because CSS ID selectors and DOM ID lookups expect uniqueness and match only the first element in document order, a bare `#floating_filled` locator cannot reliably identify *Max Calories per Slice* if field order shifts or hidden inputs exist. Likewise, `#pizza-name` works before submission but collides with the output heading afterward. Anchoring locators with label context or an explicit element tag—such as `xpath://label[contains(.,'Max Calories')]/../input` and `css:input#pizza-name`—keeps test scripts targeted at the intended input control.

2. QuickPizza recommends randomized pizza recipes matching the user's constraints, so an automated test cannot assert hardcoded ingredient combinations or exact calorie figures without turning brittle. Step 7 instead applies a consistency oracle across two independent views: the test reads the dynamically generated `Name` (`Lab Pizza YYYYMMDD-HHMMSS`) and recommended `Tool` from the customer view and checks that the exact same name and `tool=...` value appear in the `/admin` recommendations list. Using a second-level timestamp (`YYYYMMDD-HHMMSS`) isolates each execution so the admin check cannot accidentally match leftover data from earlier lab runs on the shared site. Because the backend must persist the exact request name and chosen tool to render them identically on `/admin`, this oracle validates end-to-end persistence and cross-view consistency without restricting valid random outputs.

3. In the customer recommendation card, QuickPizza renders the pizza's list of ingredients rather than a visible "Vegetarian: Yes" text field, whereas the underlying `POST /api/pizza` JSON response includes an explicit `"vegetarian": true` property. From the UI alone, an automated test can only verify vegetarian compliance indirectly by reading the displayed ingredient names and asserting that non-vegetarian meat toppings are absent. However, maintaining a UI ingredient blocklist is fragile if the server introduces new ingredient names or phrasing. A stronger check combines the UI verification with inspecting the `POST /api/pizza` HTTP payload (via browser network interception or a direct API assertion) to confirm `"vegetarian": true` directly in the response JSON.

4. Robot Framework required slightly more upfront setup (`.venv`, `requirements.txt`, passing `CHROMEDRIVER` in `service=executable_path=...`, and building `quickpizza.resource`) than recording initially in Selenium IDE, which generated the base steps quickly. For waiting, Selenium IDE required explicit `waitForElementVisible` and `waitForElementPresent` commands between interactions, whereas Robot Framework combined `SeleniumLibrary`'s `timeout=10s` default with readable custom waits such as `Wait Until Page Contains Element    id:svelte-announcer` inside `Open QuickPizza` and `Wait Until The Page Is Ready`. In diagnostic output, `selenium-side-runner` gave terse Jest summaries (`Tests: 2 passed, 2 total` in `15.071 s` and `8.908 s`) and exported Java containing compile/runtime bugs (such as line 91 of `QP01customerTest.java`), whereas Robot Framework produced structured `log.html`, `report.html`, `output.xml`, and captured screenshots in `results/run1` and `results/run2`. Once the resource keywords were defined, Robot Framework was considerably faster to read, maintain, and troubleshoot than editing 29 flat commands in a `.side` JSON file.

5. Our team would choose **Robot Framework** over Selenium IDE for Project 2. First, separating selectors and multi-step flows into `robot/resources/quickpizza.resource` kept `pizza_scenario.robot` clean and domain-focused, while Selenium IDE stored everything as flat command lists and produced broken JUnit 4 export code when converting tests to code. Second, Robot Framework's built-in HTML logs (`log.html`, `report.html`), machine-readable `output.xml` (recording `11.178929 s` and `10.726844 s` test timings), automatic failure screenshots, and explicit step screenshots (`Capture Page Screenshot` / `Capture Element Screenshot` saved under `results/run1` and `results/run2`) make debugging CI failures much faster than console-only `selenium-side-runner` output. Together, keyword reuse and rich reporting make Robot Framework far better suited for an evolving Project 2 suite.

6. Recording the Submit button on `web-form.html` generated `css=.btn`, which matches any element carrying Bootstrap's generic button styling class rather than the submit action itself. If another button styled with `.btn` (such as Cancel or Reset) is inserted earlier in the form, or if CSS classes change during a redesign, `css=.btn` will either trigger the wrong control or fail to find the element. Updating the target to `xpath=//button[@type='submit']` binds the locator to the semantic `<button>` tag and its HTML submission role (`type="submit"`). Because semantic HTML form attributes change far less often than visual CSS classes, `xpath=//button[@type='submit']` remains stable across UI restyling.

7. If QuickPizza alters the calorie input markup, `${MAX CALORIES}` only needs to be updated on line 11 of `robot/resources/quickpizza.resource` under `*** Variables ***`. That single variable holds `xpath://label[contains(.,'Max Calories')]/../input` and is shared by `Turn On Advanced` and `Fill In The Pizza Request`. Because `robot/pizza_scenario.robot` calls only high-level keywords (`Turn On Advanced`, `Fill In The Pizza Request`, `Ask For A Pizza`) without hardcoding any DOM locators, the test scenario file stays completely isolated from markup changes. Editing `${MAX CALORIES}` inside `quickpizza.resource` therefore repairs every keyword and test case using that field in one change.
