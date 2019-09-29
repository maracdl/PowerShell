Describe "Get Answer" {
    Context "Correct output" {
        It "Returns the correct value" {
            Get-Answer -Question 'Answer to the Ultimate Question of Life, the Universe, and Everything' | Should be 42
        }
    }
}


