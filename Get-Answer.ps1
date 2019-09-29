Function Get-Answer {
    param(
        [parameter(Mandatory)]
        [string]$Question
    )

    if ($Question -eq 'Answer to the Ultimate Question of Life, the Universe, and Everything') {
        42
    }
}