$host.ui.RawUI.WindowTitle = "Password Generator"
$pos = 1
$symbols = $false
$lenght = 0

$DebugMode = $false


function Set-ConsoleSizeAndColor {
    param (
        [int]$Width = 120,
        [int]$Height = 30,
        [ConsoleColor]$BackgroundColor = 'Black',
        [ConsoleColor]$ForegroundColor = 'White'
    )

    [console]::BackgroundColor = $BackgroundColor
    [console]::ForegroundColor = $ForegroundColor

    Clear-Host

    $maxWidth = [console]::LargestWindowWidth
    $maxHeight = [console]::LargestWindowHeight

    $finalWidth = [math]::Min($Width, $maxWidth)
    $finalHeight = [math]::Min($Height, $maxHeight)

    [console]::WindowWidth = $finalWidth
    [console]::WindowHeight = $finalHeight

    [console]::BufferWidth = $finalWidth
    [console]::BufferHeight = $finalHeight

    Clear-Host
}


function Center-Text {
    param (
        [string]$Text
    )

    $cleanText = $Text -replace '\x1b\[[0-9;]*m', ''

    $consoleWidth = [console]::WindowWidth

    $padding = [math]::Max(0, ($consoleWidth - $cleanText.Length) / 2)

    $centeredText = " " * [math]::Floor($padding) + $Text

    Write-Host $centeredText
}


function Gen-Password {
    param (
        [int]$Lengthpass,
        [bool]$Symbolpass
    )
    
    $password = @() 
    $group_counter = 0  

    $symbols = @('!', '@', '#', '$', '%', '&', '?')

    $letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $digits = '0123456789'

    for ($i = 1; $i -le $Lengthpass; $i++) {
        if ($Symbolpass -and (Get-Random -Minimum 0 -Maximum 4) -eq 0) {
            $randomchar = $symbols[(Get-Random -Minimum 0 -Maximum $symbols.Length)]
        } elseif ($Symbolpass -and (Get-Random -Minimum 0 -Maximum 4) -eq 1) {
            $randomchar = $letters[(Get-Random -Minimum 0 -Maximum $letters.Length)]
        } else {
            if (Get-Random -Minimum 0 -Maximum 2) {
                $randomchar = $letters[(Get-Random -Minimum 0 -Maximum $letters.Length)]
            } else {
                $randomchar = $digits[(Get-Random -Minimum 0 -Maximum $digits.Length)]
            }
        }

        $password += $randomchar
        $group_counter++

        if ($group_counter -eq 3 -and $i -ne $Lengthpass) {
            $password += "-"
            $group_counter = 0
        }
    }

    return -join $password  
}






function Draw-Menu{
    param (
        [int]$Position,
        [bool]$Symbols
    )
    Clear-Host
    Write-Host "`n`n"
    Center-Text "PowerShell Password Generator"
    Write-Host ""
    Center-Text "For simple password generation"
    Write-Host "`n`n`n`n"

    if ($Position -eq 1){
        Center-Text "$([char]27)[48;5;13m$([char]27)[38;5;0m[1]$([char]27)[48;5;0m$([char]27)[38;5;13m Generate  [2] $(if ($lenght -eq 0) {"___"} else {"$([char]27)[48;5;0m$([char]27)[38;5;13;4m$lenght$([char]27)[24m"})  $(if($Symbols -eq $false) {"[ ]"} else {"[*]"}) Allow special symbols"
    }
    if ($Position -eq 2){
        Center-Text "[1] Generate  $([char]27)[48;5;13m$([char]27)[38;5;0m[2]$([char]27)[48;5;0m$([char]27)[38;5;13m $(if ($lenght -eq 0) {"___"} else {"$([char]27)[48;5;0m$([char]27)[38;5;13;4m$lenght$([char]27)[24m"})  $(if($Symbols -eq $false) {"[ ]"} else {"[*]"}) Allow special symbols"
    }
    if ($Position -eq 3){
        Center-Text "[1] Generate  [2] $(if ($lenght -eq 0) {"___"} else {"$([char]27)[48;5;0m$([char]27)[38;5;13;4m$lenght$([char]27)[24m"})  $([char]27)[48;5;13m$([char]27)[38;5;0m$(if($Symbols -eq $false) {"[ ]"} else {"[*]"})$([char]27)[48;5;0m$([char]27)[38;5;13m Allow special symbols"
    }
    Write-Host "`n`n"
}










Set-ConsoleSizeAndColor -Width 75 -Height 20 -BackgroundColor Black -ForegroundColor Magenta
Draw-Menu -Position 1 -Symbols $false -Symbolpass

do {

    $choice = [Console]::ReadKey($true).Key 

    if ($DebugMode -eq $true){
        Write-Host "$choice"
    }


    if (($pos -eq 1) -and (($choice -eq "Enter")-or ($choice -eq "Spacebar"))){
        Draw-Menu -Position $pos -Symbols $symbols
        Center-Text "$(Gen-Password -Lengthpass $lenght -Symbolpass $symbols)"
    }

    if (($pos -eq 2) -and ($choice -ne "A") -and ($choice -ne "D")){
        if ((($choice -eq "W") -or ($choice -eq "UpArrow")) -and $lenght -eq " "){
            $lenght = 0
            $lenght = $lenght + 3
            Draw-Menu -Position $pos -Symbols $symbols
        } else {
            if (($choice -eq "W") -or ($choice -eq "UpArrow")){
                $lenght = $lenght + 3
                Draw-Menu -Position $pos -Symbols $symbols
            }
        }
        if ((($choice -eq "S") -or ($choice -eq "DownArrow")) -and ($lenght -ne 0)){
            $lenght = $lenght - 3
            Draw-Menu -Position $pos -Symbols $symbols
        }

        if ((($choice -eq "D1") -or ($choice -eq "NumPad1")) -or (($choice -eq "D2") -or ($choice -eq "NumPad2")) -or (($choice -eq "D3") -or ($choice -eq "NumPad3")) -or (($choice -eq "D4") -or ($choice -eq "NumPad4")) -or (($choice -eq "D5") -or ($choice -eq "NumPad5")) -or (($choice -eq "D6") -or ($choice -eq "NumPad6")) -or (($choice -eq "D7") -or ($choice -eq "NumPad7")) -or (($choice -eq "D8") -or ($choice -eq "NumPad8")) -or (($choice -eq "D9") -or ($choice -eq "NumPad9")) -or (($choice -eq "D0") -or ($choice -eq "NumPad0"))){
            $choice = $choice -replace '[^\d]', ''
            [string]$lenght += $choice
            [int]$lenght = [string]$lenght
            Draw-Menu -Position $pos -Symbols $symbols
        }
        if (($choice -eq "Backspace") -and ($lenght -ne " ") -and ($lenght -ne 0)){
            [string]$lenght = [int]$lenght
            [int]$lenght = $lenght.Substring(0, $lenght.Length - 1)
            Draw-Menu -Position $pos -Symbols $symbols
        }
    }

    if (($choice -eq "A") -or ($choice -eq "LeftArrow")){
        if ($pos -gt 1){[int]$pos--}
        Draw-Menu -Position $pos -Symbols $symbols
    }

    if (($choice -eq "D") -or ($choice -eq "RightArrow")){
        if ($pos -lt 3){[int]$pos++}
        Draw-Menu -Position $pos -Symbols $symbols
    }

    if (($choice -eq "Enter") -or ($choice -eq "Spacebar")){

        if ($pos -eq 3){
            if ($symbols -eq $true) {
                $symbols = $false
                Draw-Menu -Position $pos -Symbols $symbols
            } else {
                if ($symbols -eq $false) {
                $symbols = $true
                Draw-Menu -Position $pos -Symbols $symbols
            }
            }
        }
    }

    if ($DebugMode -eq $true){
        if ($choice -eq "Z"){
            Write-Host "Position: $pos"
            Write-Host "Allow Symbols: $symbols"
            Write-Host "Lenght: $lenght"
        }
    }
} until ($choice -eq "Escape") 
