# ShipTest
Visual Studio solution and Powershell scripts to test Sitecore.Ship 0.4.0.

## Usage
1. Install the following Sitecore instances (e.g. using SIM):
 - shipsc75rev150212
 - shipsc80rev140922
 - shipsc80rev141212
 - shipsc80rev150223
 - shipsc80rev150427
 - shipsc80rev150621
2. Build the solution.
3. Publish each of the projects (each project has its own publish profile to the named Sitecore site mentioned in step 1).
4. Run scripts\start-tests.ps1 to deploy a Sitecore update package and a zip package (located in resources folder) to each of the instances and publish the items in two languages.