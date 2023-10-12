using assembly "/usr/local/share/PackageManagement/NuGet/Packages/microsoft.build.17.7.2/lib/net7.0/Microsoft.Build.dll"

[CmdletBinding()]
param(
  [Parameter(ValueFromPipeline,
    ValueFromPipelineByPropertyName,
    Mandatory,
    Position = 1,
    ParameterSetName = "Default",
    HelpMessage = "The path to the project file to build the solution for. Defaults to the first .*proj file in the current directory.")]
  [string]$ProjectPath
)

begin {
  $ProjectPath = [System.IO.Path]::GetFullPath($ProjectPath)
  $ProjectFileExists = [System.IO.File]::Exists($ProjectPath);

  Set-Location $(Split-Path $ProjectPath)

  Write-Debug("Processing project file $ProjectPath...");
  Write-Debug("File exists: ${ProjectFileExists ? "YES!" : "NO"}...");
  if (!$ProjectFileExists) {
    Write-Error("Project file $ProjectPath does not exist.");
    exit 1;
  }
}

process {
  slngen --launch false "$ProjectPath" --configuration "Local;Debug;Testing;Staging;Production;Release"
  # [Microsoft.Build.Execution.ProjectInstance]$project = [Microsoft.Build.Execution.ProjectInstance]::FromFile($ProjectPath)
  [System.Xml.Linq.XDocument]$project = [System.Xml.Linq.XDocument]::Load($ProjectPath)
  $projectReferences = $project.Descendants("ProjectReference")
  $projectReferences | ForEach-Object {
    $projectReference = $_
    $projectReferencePath = $projectReference.Attribute("Include").Value
    $includeInSolutionFile = [bool]::Parse($projectReference.Attribute("IncludeInSolutionFile")?.Value ?? "true")
    if ($includeInSolutionFile) {
      $projectReferenceFullPath = Join-Path (Split-Path $ProjectPath) $projectReferencePath
      Write-Debug("Processing project reference $projectReferenceFullPath...")
      dotnet sln add $projectReferenceFullPath
    }
  }

  $includeInSolutionFile = [bool]::Parse($project.Descendants("IncludeInSolutionFile")?.Value ?? "true")
  if ($includeInSolutionFile) {
    dotnet sln add "$ProjectPath"
  }
}
