function prompt {
    # changement du nom de la fenêtre
    $host.UI.RawUI.WindowTitle = (Get-Location).Path
    # récupération du nom de l'utilisateur
    $currentUser = Split-Path -leaf -path (Get-ChildItem Env:\USERPROFILE).Value
    # récupération du nom de l'ordinateur
    $pcName = (Get-ChildItem Env:\USERNAME).Value
    # récupération du chemin courrant
    $path = getRelative((Get-Location).Path)
    # vérirification si le shell est administrateur
    $isAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    # récupération de la durée de la dernière commande
    $lastCommand = Get-History -Count 1
    if ($lastCommand) {
        $runTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds
        if ($runTime -gt 0) {
            if ($runTime -ge 60) {
                $ts = [timespan]::fromseconds($runTime)
                $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
                $timeString = -join ($min, " min ", $sec, " sec")
            } else {
                $timeString = [math]::Round(($runTime), 2)
                $timeString = -join (($timeString.ToString()), " sec")
            }
            Write-Host "[$timeString]" -ForegroundColor Blue
        }
    }

    Write-Host -NoNewLine "| " -ForegroundColor Red
    Write-Host -NoNewLine "$currentUser@$pcName" -ForegroundColor Gray
    Write-Host -NoNewLine " : " -ForegroundColor White
    Write-Host -NoNewLine "$path\" -ForegroundColor Yellow
    Write-Host -NoNewLine ($(if ($isAdmin) { "#" } else { "$" })) -ForegroundColor Green
    Write-Host -NoNewLine " >>>" -ForegroundColor DarkGreen
    Return " "
}

function getRelative {
    
    param (
        [string[]]$path
    )

    $user = (Get-ChildItem Env:\USERPROFILE).Value
    if ($path -like "$user*") {
        $path = $path.Replace($user, "~")
    }

    return $path
}

Import-Module -Name Terminal-Icons