param(
    [string]$RootDir = ".",
    [string]$OutputFile = "combined_gd_files.txt"
)

Write-Host "Combining .gd files (GDScript files)" -ForegroundColor Green
Write-Host "Folder: $((Get-Item $RootDir).FullName)" -ForegroundColor Yellow
Write-Host ""

# Check if folder exists
if (-not (Test-Path $RootDir)) {
    Write-Host "ERROR: Folder '$RootDir' does not exist!" -ForegroundColor Red
    exit 1
}

# Get absolute path
$RootDir = (Get-Item $RootDir).FullName

# Get absolute path for output file
$OutputFile = Join-Path (Get-Location) $OutputFile

Write-Host "Output file: $OutputFile" -ForegroundColor Cyan
Write-Host ""

# Remove old output file
if (Test-Path $OutputFile) {
    Remove-Item $OutputFile -Force
    Write-Host "Removed old file: $OutputFile"
}

# Create empty UTF-8 file
try {
    [System.IO.File]::WriteAllText($OutputFile, "", [System.Text.Encoding]::UTF8)
    Write-Host "Created output file: $OutputFile" -ForegroundColor Green
}
catch {
    Write-Host "ERROR creating output file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Find all .gd files, excluding common Godot project folders
$gdFiles = Get-ChildItem -Path $RootDir -Recurse -Filter "*.gd" | 
    Where-Object { 
        # Exclude Godot project system folders
        -not $_.FullName.Contains('\\.godot\') -and
        -not $_.FullName.Contains('\\addons\\') -and
        # Exclude common cache and temporary folders
        -not $_.FullName.Contains('\\Cache\\') -and
        -not $_.FullName.Contains('\\.import\\') -and
        # Exclude backup files if present
        -not $_.Name.EndsWith('.backup.gd') -and
        -not $_.Name.EndsWith('.bak.gd')
    }

$fileCount = 0
$totalFiles = $gdFiles.Count

if ($totalFiles -eq 0) {
    Write-Host "No suitable .gd files found!" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found GDScript files: $totalFiles"
Write-Host ""

foreach ($file in $gdFiles) {
    $fileCount++
    $relativePath = $file.FullName.Replace($RootDir, "").TrimStart('\', '/')
    $percent = [math]::Round(($fileCount / $totalFiles) * 100, 1)
    
    Write-Progress -Activity "Processing GDScript files" -Status "$fileCount/$totalFiles ($percent%) - $relativePath" -PercentComplete $percent
    
    try {
        # Read all lines from file
        $lines = Get-Content $file.FullName -Encoding UTF8
        
        # Remove ONLY completely empty lines (preserve indentation important for GDScript)
        $nonEmptyLines = @()
        foreach ($line in $lines) {
            # Keep the line if it's not empty (preserves spaces and tabs for indentation)
            # GDScript is indentation-sensitive, so we must preserve whitespace
            if ($line.Trim() -ne "") {
                $nonEmptyLines += $line
            }
        }
        
        # Remove empty lines only from start and end of file
        while ($nonEmptyLines.Count -gt 0 -and $nonEmptyLines[0].Trim() -eq "") {
            $nonEmptyLines = $nonEmptyLines[1..($nonEmptyLines.Count-1)]
        }
        while ($nonEmptyLines.Count -gt 0 -and $nonEmptyLines[-1].Trim() -eq "") {
            $nonEmptyLines = $nonEmptyLines[0..($nonEmptyLines.Count-2)]
        }
        
        # Join lines back together (GDScript uses LF line endings typically)
        $content = $nonEmptyLines -join "`n"
        
        # Create file block with proper formatting
        $fileBlock = @"
# ==================================================
# file: $relativePath
# ==================================================
$content


"@
        
        # Append to output file
        [System.IO.File]::AppendAllText($OutputFile, $fileBlock, [System.Text.Encoding]::UTF8)
        
        Write-Host "Processed [$fileCount/$totalFiles]: $relativePath" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR processing: $relativePath" -ForegroundColor Red
        Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Progress -Activity "Processing GDScript files" -Completed

# Verify the file was created and get its info
if (Test-Path $OutputFile) {
    $fileInfo = Get-Item $OutputFile
    Write-Host ""
    Write-Host "=" * 50
    Write-Host "Done! Processed GDScript files: $fileCount/$totalFiles" -ForegroundColor Green
    Write-Host "Result saved to: $($fileInfo.FullName)" -ForegroundColor Cyan
    Write-Host "File size: $($fileInfo.Length) bytes" -ForegroundColor Cyan
    
    # Show first few lines as preview
    try {
        $preview = Get-Content $OutputFile -TotalCount 10 -Encoding UTF8
        Write-Host ""
        Write-Host "Preview (first 10 lines):" -ForegroundColor Yellow
        $preview | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    }
    catch {
        Write-Host "Could not read output file for preview" -ForegroundColor Yellow
    }
}
else {
    Write-Host ""
    Write-Host "ERROR: Output file was not created!" -ForegroundColor Red
    exit 1
}

# Open folder with result (optional)
Write-Host ""
$openFolder = Read-Host "Open result folder? (y/n)"
if ($openFolder -eq 'y' -or $openFolder -eq 'Y') {
    try {
        Invoke-Item (Split-Path $OutputFile -Parent)
    }
    catch {
        Write-Host "Could not open folder: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}