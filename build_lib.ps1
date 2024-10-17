# Created with chatGPT
# Created with chatGPT
# Created with chatGPT
# Created with chatGPT

# Set the directory containing the Lua files
$inputDir = ".\function"  # Replace with the actual directory path
$outputFile = ".\magicchex_lib.lua"  # Replace with the output file path

# Check if the directory exists
if (-Not (Test-Path $inputDir)) {
    Write-Host "Directory $inputDir does not exist."
    exit
}

# Initialize or clear the output file
New-Item -Path $outputFile -ItemType File -Force | Out-Null

# Loop through each file in the directory
Get-ChildItem -Path $inputDir | ForEach-Object {
    $file = $_.FullName
    $fileName = Split-Path -Path $file -Leaf  # Get just the filename

    # Check if it's a file (not a directory)
    if (-not $_.PSIsContainer) {
        # Append the file content with comments to mark start
        Add-Content -Path $outputFile -Value ("-- [[$fileName]]")
        Get-Content -Path $file | Add-Content -Path $outputFile
        Add-Content -Path $outputFile -Value ("")
    }
}

Write-Host "All files have been concatenated into $outputFile."
