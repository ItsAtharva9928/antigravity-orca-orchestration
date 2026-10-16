<#
.SYNOPSIS
    Antigravity CLI + Orca Two-Tier Multi-Agent Orchestration Installer (Windows PowerShell)

.DESCRIPTION
    Installs the multi-agent-orchestrator plugin, rules, subagents, and skills
    into Google Antigravity CLI (~/.gemini/config/plugins/multi-agent-orchestrator and AGENTS.md).

.PARAMETER DryRun
    Simulates the installation without modifying any files.

.PARAMETER Force
    Overwrites existing files without prompting.
#>

[CmdletBinding()]
param (
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$targetPluginDir = Join-Path $HOME ".gemini\config\plugins\multi-agent-orchestrator"
$targetGlobalRules = Join-Path $HOME ".gemini\config\AGENTS.md"
$targetUserRules = Join-Path $HOME "AGENTS.md"

Write-Host @"

   _   _  _ _____ ___ ____ ____     _ __     _____ _______   __
  / \ | \| |_   _|_ _/ ___|  _ \   / \\ \   / /_ _|_   _\ \ / /
 / _ \| .` | | |  | | |  _| |_) | / _ \\ \ / / | |  | |  \ V / 
/ ___ \ |\ | | |  | | |_| |  _ < / ___ \\ V /  | |  | |   | |  
/_/   \_\_| \_|_| |___\____|_| \_\_/   \_\\_/  |___| |_|   |_|  
+ Orca Two-Tier Multi-Agent Orchestration Architecture for Antigravity CLI

"@ -ForegroundColor Cyan

Write-Host "==> Target Plugin Directory: $targetPluginDir" -ForegroundColor Blue
Write-Host "==> Target Rule Files:       $targetGlobalRules, $targetUserRules" -ForegroundColor Blue

if ($DryRun) {
    Write-Host "[DRY-RUN MODE] No files will be modified." -ForegroundColor Yellow
}
Write-Host ""

# 1. Install Plugin
if (-not $DryRun) {
    if (-not (Test-Path $targetPluginDir)) {
        New-Item -ItemType Directory -Path $targetPluginDir -Force | Out-Null
    }
    Copy-Item -Path (Join-Path $scriptDir "plugin.json") -Destination $targetPluginDir -Force
    Copy-Item -Path (Join-Path $scriptDir "rules") -Destination $targetPluginDir -Recurse -Force
    Copy-Item -Path (Join-Path $scriptDir "skills") -Destination $targetPluginDir -Recurse -Force
    Copy-Item -Path (Join-Path $scriptDir "agents") -Destination $targetPluginDir -Recurse -Force
    Write-Host "[Installed] Plugin multi-agent-orchestrator in ~/.gemini/config/plugins" -ForegroundColor Green

    # 2. Deploy Global AGENTS.md
    $ruleSrc = Join-Path $scriptDir "rules\AGENTS.md"
    if (Test-Path $ruleSrc) {
        Copy-Item -Path $ruleSrc -Destination $targetGlobalRules -Force
        Copy-Item -Path $ruleSrc -Destination $targetUserRules -Force
        Write-Host "[Installed] AGENTS.md global orchestration rules" -ForegroundColor Green
    }
} else {
    Write-Host "[DryRun] Would install plugin and global rules." -ForegroundColor Cyan
}

# 3. Check CLI Toolchain
Write-Host ""
Write-Host "==> Verifying Shared Engineering Toolchain:" -ForegroundColor Yellow

$tools = @(
    @{ Name = "ast-grep (sg)"; Exe = "ast-grep" },
    @{ Name = "Biome"; Exe = "biome" },
    @{ Name = "agent-browser"; Exe = "agent-browser" },
    @{ Name = "ripgrep (rg)"; Exe = "rg" },
    @{ Name = "Orca CLI"; Exe = "orca" }
)

foreach ($t in $tools) {
    $cmd = Get-Command $t.Exe -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "  [OK] $($t.Name) found at $($cmd.Source)" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $($t.Name) not found in PATH." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Installation completed! Launch 'agy' in any directory to start." -ForegroundColor Cyan
