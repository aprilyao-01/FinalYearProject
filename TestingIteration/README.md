# Unit Testing for Guardian

This README file is the guidance for running unit tests for the Guardian app.

## Prerequisites

- Xcode (latest version recommended)
- Guardian Xcode project file (Guardian.xcodeproj)
- A Mac computer

## Running Unit Tests

To run unit tests for the Guardian app, follow the steps below:

1. Open the Guardian Xcode project file `Guardian.xcodeproj`.
2. Ensure the Guardian Xcode project contains a test target `GuardianUnitTests`.
3. Go to `Product` > `Scheme` > `Edit Scheme`. In the left panel select `Test`.
4. In the "Info" tab, under "Test" section, click the `Options` button on the right hand side (not the "Options" menu tab), and uncheck the **Execute in parallel on Simulator** option.
5. Click "Close" to save the changes.
6. To run single tests, click the **diamond-shaped icons** next to each test case in the Xcode source editor's gutter. To run all tests at once, select `Product` > `Test` from the menu bar or press `Cmd+U`.
7. Xcode will execute the tests and display the results in the "Test Navigator" tab, which can be accessed by clicking the top-left corner "Navigator" icon (looks like a list) and selecting the "Test" tab (icon with a checkmark inside a diamond).
8. The Test Navigator will show a summary of the test results, with green checkmarks indicating successful tests and red X marks denoting failed tests. You can click on a test result to view more details, including any error messages.

## Additional Instructions
### Clean Build Folder and Close Simulator Before Each Time Running Tests
To ensure consistent test results, it's highly recommended to clean the build folder and close the simulator before each time running tests:

1. In the Xcode menu, go to `Product` > `Clean Build Folder` or press `Shift + Cmd + K` to clean the build folder.
2. Close the iOS simulator if it's open.
3. Run all the tests by pressing `Cmd + U` or clicking the diamond-shaped icons next to each test case in the Xcode source editor's gutter to run single test case.

### Use iPhone 14 Simulator for Running Unit Tests
For reference, I used XCode 14.3. Simulator: iPhone XR (iOS 15.5) and iPhone 14 (iOS 16.4). Real device: iPhone XR (iOS 15.5 and 16.4) for the whole development and testing process.<br>
Please note that unit tests will not run on *iPhone XR*. Use the iPhone 14 simulator instead to get reliable testing experience:
1. In the Xcode toolbar, click on the active scheme (located next to the "Stop" button), then select the "iPhone 14" simulator from the list of available devices.
2. Run all tests by pressing `Cmd + U` or clicking the diamond-shaped icons next to each test case in the Xcode source editor's gutter to run single test case.

### Enabling and Checking Code Coverage
To enable code coverage and check the results, follow these steps:
1. Go to `Product` > `Scheme` > `Edit Scheme`. In the left panel select `Test`.
2. In the `Option` tab, check the **Code Coverage** option to enable it.
3. Click "Close" to save the changes.
4. Run all the tests by pressing `Cmd + U` or clicking the diamond-shaped icons next to each test case in the Xcode source editor's gutter to run single test case.
5. Wait for test run over and show result.
6. Open the "Report Navigator" by clicking the "Navigator" icon (looks like a list) on the top-left corner of the Xcode window and selecting the last "Report" tab (icon with a report paper).
7. Under the "Test" section, you will see the most recent test results. Double-click the `Coverage` button.
8. The "Coverage" report displays the code coverage percentage for each file in this project. You can click on a file to view the specific lines of code that were executed or not executed during this test.



