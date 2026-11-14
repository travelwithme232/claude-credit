# Install credit on Windows: %USERPROFILE%\.local\bin\credit.py + credit.cmd, and turn on the VS Code integration
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$ko = (Get-UICulture).TwoLetterISOLanguageName -eq "ko"
function Say($en, $kr) { if ($ko) { Write-Host $kr } else { Write-Host $en } }

$py = if (Get-Command py -ErrorAction SilentlyContinue) { "py -3" } else { "python" }
$bin = Join-Path $env:USERPROFILE ".local\bin"

function Put($src, $dest) {
    if ((Test-Path $dest) -and ((Get-FileHash $src).Hash -ne (Get-FileHash $dest).Hash)) {
        $q = if ($ko) { "$dest 이(가) 이미 있어요. 덮어쓸까요? [y/N]" } else { "$dest already exists. Overwrite? [y/N]" }
        if ((Read-Host $q) -notmatch '^[yY]$') { Say "  skipped" "  건너뜀"; return }
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    Copy-Item $src $dest -Force
    Say "  installed $dest" "  설치함 $dest"
}

Put "credit" (Join-Path $bin "credit.py")
Set-Content -Path (Join-Path $bin "credit.cmd") -Value "@$py `"%~dp0credit.py`" %*" -Encoding ASCII

# the API key goes to Windows Credential Manager through the keyring package
Invoke-Expression "$py -m pip install --user --quiet keyring"

# VS Code integration: a marked block in ~/.claude/CLAUDE.md and ~/.claude/commands/credit-result.md
Invoke-Expression "$py `"$(Join-Path $bin 'credit.py')`" _install-vscode"
Say "  VS Code integration on" "  VS Code 연동 켬"

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (($userPath -split ";") -notcontains $bin) {
    Say "$bin is not on your PATH. Add it in Settings > System > About > Advanced system settings > Environment Variables, or run:" `
        "$bin 이 PATH 에 없어요. 설정 > 시스템 > 정보 > 고급 시스템 설정 > 환경 변수에서 넣거나 이렇게 실행하세요:"
    Write-Host "  [Environment]::SetEnvironmentVariable('Path', `"$bin;`" + [Environment]::GetEnvironmentVariable('Path','User'), 'User')"
}
Say "Done. Open a new terminal and run: credit" "끝. 새 터미널을 열고 실행: credit"
