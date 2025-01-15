#Объявление глобальных переменных
$host.ui.RawUI.WindowTitle = "Password Generator"
$pos = 1
$symbols = $false
$lenght = 0

#Debug мод
$DebugMode = $false


function Set-ConsoleSizeAndColor {
    param (
        [int]$Width = 120,
        [int]$Height = 30,
        [ConsoleColor]$BackgroundColor = 'Black',
        [ConsoleColor]$ForegroundColor = 'White'
    )

    # Устанавливаем цвет фона и текста
    [console]::BackgroundColor = $BackgroundColor
    [console]::ForegroundColor = $ForegroundColor

    # Очистка консоли для применения цвета фона
    Clear-Host

    # Получаем максимальные размеры окна
    $maxWidth = [console]::LargestWindowWidth
    $maxHeight = [console]::LargestWindowHeight

    # Ограничиваем размеры окна
    $finalWidth = [math]::Min($Width, $maxWidth)
    $finalHeight = [math]::Min($Height, $maxHeight)

    # Устанавливаем размеры окна
    [console]::WindowWidth = $finalWidth
    [console]::WindowHeight = $finalHeight

    # Устанавливаем размеры буфера
    [console]::BufferWidth = $finalWidth
    [console]::BufferHeight = $finalHeight

    # Полностью очищаем буфер с новым фоном
    Clear-Host
}


function Center-Text {
    param (
        [string]$Text
    )

    # Удаляем управляющие последовательности (цветовые коды ANSI)
    $cleanText = $Text -replace '\x1b\[[0-9;]*m', ''

    # Получаем ширину консоли
    $consoleWidth = [console]::WindowWidth

    # Вычисляем количество пробелов для отступа
    $padding = [math]::Max(0, ($consoleWidth - $cleanText.Length) / 2)

    # Формируем строку с отступом
    $centeredText = " " * [math]::Floor($padding) + $Text

    # Выводим текст
    Write-Host $centeredText
}


function Gen-Password {
    param (
        [int]$Lengthpass,
        [bool]$Symbolpass
    )
    
    $password = @()  # Массив для накопления символов
    $group_counter = 0  # Счётчик символов в текущей группе

    # Заданные специальные символы
    $symbols = @('!', '@', '#', '$', '%', '&', '?')

    for ($i = 1; $i -le $Lengthpass; $i++) {
        if ($Symbolpass -and (Get-Random -Minimum 0 -Maximum 2) -eq 1) {
            # Случайный специальный символ
            $randomchar = $symbols[(Get-Random -Minimum 0 -Maximum $symbols.Length)]
        } else {
            # Случайная цифра
            $randomchar = [char](Get-Random -Minimum 48 -Maximum 58)
        }

        $password += $randomchar
        $group_counter++

        # Добавляем дефис после каждых 3 символов, если это не последний символ
        if ($group_counter -eq 3 -and $i -ne $Lengthpass) {
            $password += "-"
            $group_counter = 0
        }
    }

    return -join $password  # Преобразуем массив в строку
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
    Center-Text "For simple password generation only!"
    Center-Text "(not secure)"
    Write-Host "`n`n`n"

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







#                                                                                            Начало



Set-ConsoleSizeAndColor -Width 75 -Height 20 -BackgroundColor Black -ForegroundColor Magenta
Draw-Menu -Position 1 -Symbols $false -Symbolpass

#Цикл отрисовки и считывания нажатий
do {

    $choice = [Console]::ReadKey($true).Key #считывание нажатия

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
} until ($choice -eq "Escape") #Выход из программы