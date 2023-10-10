@{
    RootModule              = "Invoke-SlnGen.psm1"
    ModuleVersion           = '0.0.1'
    GUID                    = '157ae50e-c14e-4322-9d62-228f90abb286'
    Author                  = 'David G. Moore, Jr.'
    CompanyName             = 'DGMJR-IO'
    Copyright               = '© 2023 David G. Moore, Jr. <david@dgmjr.io>, All Rights Reserved'
    Description             = 'A PowerShell module to invoke the slngen process'
    ScriptsToProcess        = @("Invoke-SlnGen.ps1")
    FunctionsToExport       = @("Invoke-SlnGen")
    DotNetFrameworkVersion  = "2.0"
    CLRVersion = "2.0"
    PrivateData   = @{
        PSData = @{
            ProjectUri                 = 'https://github.com/dgmjr-ps/InvokeBuild'
            LicenseUri                 = 'https://opensource.org/lienses/MIT'
            Tags                       = @('PowerShell', 'slngen')
            PowerShellGetFormatVersion = '3.0'
        }
    }
}
