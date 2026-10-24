$ErrorActionPreference = 'Stop'
$forgeConfigPath = 'C:\Users\karti\.codex\config.toml'
$forgeKeyPath = 'C:\Users\karti\OneDrive\Documents\Outpost\forgegui_config.json'
$forgeEndpoint = 'https://azyjlkhpdgafuobyxoax.supabase.co/functions/v1/forgegui-mcp'
$forgeSaved = Get-Content -LiteralPath $forgeKeyPath -Raw | ConvertFrom-Json
if ($forgeSaved.endpoint -ne $forgeEndpoint -or [string]::IsNullOrWhiteSpace($forgeSaved.api_key)) {
    throw 'Expected ForgeGUI endpoint or stored credential is missing.'
}
$forgeExisting = [IO.File]::ReadAllText($forgeConfigPath)
if ($forgeExisting -match '(?m)^\[mcp_servers\.forgegui(?:\]|\.)') {
    throw 'A ForgeGUI section already exists; inspect it before modifying.'
}
$forgePriorKey = [Environment]::GetEnvironmentVariable('FORGEGUI_API_KEY','User')
if ($forgePriorKey -and $forgePriorKey -ne $forgeSaved.api_key) {
    throw 'A different ForgeGUI user credential already exists; refusing to replace it.'
}
$forgeBlock = @'

[mcp_servers.forgegui]
enabled = true
url = "https://azyjlkhpdgafuobyxoax.supabase.co/functions/v1/forgegui-mcp"
bearer_token_env_var = "FORGEGUI_API_KEY"
startup_timeout_sec = 30
tool_timeout_sec = 180
http_headers = { "X-ForgeGUI-Plugin-Version" = "1.9.6", "X-ForgeGUI-Plugin-Client" = "codex" }
'@
$forgeBackupPath = $forgeConfigPath + '.before-forgegui-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.bak'
Copy-Item -LiteralPath $forgeConfigPath -Destination $forgeBackupPath
try {
    [Environment]::SetEnvironmentVariable('FORGEGUI_API_KEY',[string]$forgeSaved.api_key,'User')
    [IO.File]::WriteAllText($forgeConfigPath,$forgeExisting.TrimEnd()+[Environment]::NewLine+$forgeBlock+[Environment]::NewLine,[Text.UTF8Encoding]::new($false))
} catch {
    [IO.File]::WriteAllText($forgeConfigPath,$forgeExisting,[Text.UTF8Encoding]::new($false))
    [Environment]::SetEnvironmentVariable('FORGEGUI_API_KEY',$forgePriorKey,'User')
    throw
}
$forgeAfter = [IO.File]::ReadAllText($forgeConfigPath)
[pscustomobject]@{
    Configured = $forgeAfter.Contains('[mcp_servers.forgegui]')
    UserCredentialPresent = -not [string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable('FORGEGUI_API_KEY','User'))
    ConfigBackup = $forgeBackupPath
    ExistingConfigPreserved = $forgeAfter.StartsWith($forgeExisting.TrimEnd())
}
