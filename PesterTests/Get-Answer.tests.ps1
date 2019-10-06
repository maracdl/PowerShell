Describe "Get Answer" {
    Context "Correct output" {
        It "Returns the correct value" {
            Get-Answer -Question 'Answer to the Ultimate Question of Life, the Universe, and Everything' | Should be 42
        }
    }
}

describe 'Operating System' {
    context 'Service Availability' {
        it 'Eventlog is running' {
            $svc = Get-Service -Name Eventlog
            $svc.Status | Should Be running
        }
    }
}


