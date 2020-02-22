function Get-NicePassword {
    <#
    .SYNOPSIS
        A function to create a defined length password and copy it to the clipboard.
    .DESCRIPTION
        Get-NicePassword -PassLength <1..40> -Pass_Complexity <1..15> -Pass_Seed <0..2147483>

        0000 = 0 = P@assword01
        0001 = 1 = lowercase
        0010 = 2 = uppercase
        0100 = 4 = numbers
        1000 = 8 = special characters

        default = 12 characters of lower+upper+numbers+specials
        
        Each character of the password is the randomized by the seed * Pass_Length * Pass_Complexity + character number.
    .EXAMPLE
        Get-NicePassword
        Creates a 12 character password using all available characters.
    .EXAMPLE
        Get-NicePassword 10 5
        (5 = 0001 + 0100)
        Creates a 10 character password using numbers and lowercase characters.
    .EXAMPLE
        Get-NicePassword 12 15
        (15 = 0001 + 0010 + 0100 + 1000)
        Creates a 10 character password using all available character types.
    .EXAMPLE
        Get-NicePassword 6 1 10044 
        Creates a 6 character password using lower case characters and seeded for predictable results.
    #>
    param(
    [Parameter(Position=0,HelpMessage="How long do you want the password to be?")]
    [ValidateRange(1,40)]
    [int]$Pass_Length = 12,
    [Parameter(Position=1,HelpMessage="How complex should the password be?")]
    [ValidateRange(0,15)]
    [int]$Pass_Complexity = 15,
    [Parameter(Position=2,HelpMessage="How random should the password be?")]
    [ValidateRange(0,2147483)]
    [int]$Pass_Seed = (get-date -uformat %s) % 2147483
    )

    if ($Pass_Complexity -eq 0) {
        $Password = 'P@ssword01'
    } else {
        # Set the $valid_chars array.
        if ($Pass_Complexity -band 1) {$valid_chars += (97..104),(106..107),(109..110),(112..122)} # exclude I, L, O
        if ($Pass_Complexity -band 2) {$valid_chars += (65..72),(74..75),(77..78),(80..90)} # exclude i, l, o
        if ($Pass_Complexity -band 4) {$valid_chars += (50..57)} # exclude 0 and 1
        if ($Pass_Complexity -band 8) {$valid_chars += (33),(35..38),(40..43)} # exclude ' and "

        # Add $Pass_Length characters to the string from the $valid_chars array.
        for ($i = 1; $i -le $Pass_Length; $i++) { $Password += $valid_chars | Get-Random -setseed ((($Pass_Seed + $i) * $Pass_Length * $Pass_Complexity) + $i)| % {[char]$_} }
    }

    set-clipboard $Password
    return $Password
    }
