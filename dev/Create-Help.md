Create the Markdown templates from the module. If a help.xml file already exists, the templates will use that info.

```Powershell
Import-Module .\ScheduleTask_Test-IsOnBattery -Force
New-MarkdownHelp -Module ScheduleTask_Test-IsOnBattery -Force -OutputFolder ".\out" -Locale "en-US" -HelpVersion 0.2.0.0
```
Edit the templates in `.\out`:

* `..\dude\ScheduleTask_Test-IsOnBattery.md`
    * Delete `{{Please enter FwLink manually}}` and fill in `{{ }}` module description.
    * Remove `Cmdlets` which is not supporte
    * Rename to `README.md` if you want Github to display this file when you enter the `docs` folder.
* In the other files fill in the Github URL next to `online version:`. Fill in the rest of the template with the help information.

Generate the help.xml file. ErrorAction is needed because second level heading doesn't comply with the HelpSchema. This doesn't affect the xml since HelpInfo is not generated.

```Powershell
Invoke-PSDeploy . -ErrorAction SilentlyContinue
```

AllowClobber is needed to avoid conflict with BurntToast module, which should already be installed.

```Powershell
Install-Module -Name ScheduleTask_Test-IsOnBattery -Scope CurrentUser -AllowClobber
```

Add `HelpInfoURI = 'https://github.com/jfishe/battery/tree/master/HelpInfo'` to
psd1 file and add to `..\dude\ScheduleTask_Test-IsOnBattery.md`
on `Download Help Link: https://github.com/jfishe/battery/tree/master/HelpInfo`.

This will create the cab file and allow updatable help to install from a saved
location. URL doesn't actually work but is used as a key by Update-Help to know
which module supports updating. Get-Help `ScheduleTask_Test-IsOnBattery
-Online` returns the help for the first function, rather than the landing page.

```Powershell
Invoke-PSDeploy . -ErrorAction SilentlyContinue
New-ExternalHelpCab -CabFilesFolder '.\dudehelp\en-US\'  -OutputFolder '.\HelpInfo' -LandingPagePath ".\dude\ScheduleTask_Test-IsOnBattery.md" -Verbose
Update-Help -Module ScheduleTask_Test-IsOnBattery -Verbose -LiteralPath ".\HelpInfo" -Force -UICulture $Host.CurrentCulture
```
Looks like we need to add an `about_ScheduleTask_Test-IsOnBattery.md`. Get-Help platyPS returns the about page.
