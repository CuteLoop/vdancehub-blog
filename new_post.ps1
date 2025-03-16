Param(
    [Parameter(Mandatory = $true)]
    [string]$PostSlug
)

# Set variables for date formatting
$year = Get-Date -Format "yyyy"
$date = Get-Date -Format "MM-dd"  # Month and day for filename prefix

# Define paths relative to the repository root
$projectDir = "my-dance-blog"
$postsDir = Join-Path $projectDir "content\posts\$year"

# Ensure the year-based posts directory exists
if (-Not (Test-Path $postsDir)) {
    New-Item -ItemType Directory -Path $postsDir -Force | Out-Null
    Write-Host "Created directory: $postsDir"
}

# Build the relative path for Hugo new command
$hugoPostPath = "posts/$year/$PostSlug.md"

# Change directory into the Hugo project, run hugo new, then return
Push-Location $projectDir
try {
    hugo new $hugoPostPath
} catch {
    Write-Error "Error running 'hugo new'. Make sure Hugo is installed and available in PATH."
    Pop-Location
    exit 1
}
Pop-Location

# Define full paths for the old and new file names
$oldFile = Join-Path $postsDir "$PostSlug.md"
$newFile = Join-Path $postsDir "$date-$PostSlug.md"

# Rename the file to include the date prefix in MM-dd format
try {
    Rename-Item -Path $oldFile -NewName "$date-$PostSlug.md" -ErrorAction Stop
    Write-Host "Post created: $newFile"
} catch {
    Write-Error "Failed to rename post. File '$oldFile' not found or already renamed."
}
