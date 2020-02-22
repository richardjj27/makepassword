# A function to create a defined length password and copy it to the clipboard

function get-nicepassword {
    param([int]$pass_length = 10, [int]$pass_complexity = 1)

    # 0001 = lowercase (97..122)
    # 0010 = uppercase (65..90)
    # 0100 = numbers (48..57)
    # 1000 = special characters (33..47)

    $password = -join ((65..90) + (97..122) | Get-Random -Count 20 | % {[char]$_})
    }

get-nicepassword 10