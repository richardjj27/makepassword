# A function to create a defined length password and copy it to the clipboard

function get-nicepassword {
    param(
    [Parameter(Position=0)]
    [ValidateRange(1,40)]
    [int]$pass_length=10,
    #HelpMessage="How long do you want the password to be?")]
    [Parameter(Position=1)]
    [ValidateRange(0,15)]
    [int]$pass_complexity=0
    #HelpMessage="How complex should the password be?")]
    )
 
    # 0000 = P@assword01
    # 0001 = lowercase (97..122)
    # 0010 = uppercase (65..90)
    # 0100 = numbers (48..57)
    # 1000 = special characters (33..47)

    if ($pass_complexity -eq 0) {
        $password = 'P@ssword01'
    } else {
        if ($pass_complexity -band 1) {$valid_chars += (97..104),(106..107),(109..110),(112..122)} # exclude I, L, O
        if ($pass_complexity -band 2) {$valid_chars += (65..72),(74..75),(77..78),(80..90)} # exclude i, l, o
        if ($pass_complexity -band 4) {$valid_chars += (50..57)} # exclude 0 and 1
        if ($pass_complexity -band 8) {$valid_chars += (33..43)}

        for ($i=1; $i -le $pass_length; $i++) { $password += $valid_chars | Get-Random | % {[char]$_} }
    }

    set-clipboard $password
    return $password
    }

get-nicepassword -pass_length 25 4

