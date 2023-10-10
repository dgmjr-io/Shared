[CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline,
    ValueFromPipelineByPropertyName,
    Mandatory,
    Position = 1,
    ParameterSetName = "Default",
    HelpMessage = "The path to the project file to build the solution for. Defaults to the first .*proj file in the current directory.")]
    [string]
    $ProjectPath
  )

  begin {
    $ProjectFileExists = [System.IO.File]::Exists($ProjectPath);

    Set-Location $([System.IO.Path]::GetDirectoryName($ProjectPath))

    Write-Debug("Processing project file $ProjectPath...");
    Write-Debug("File exists: ${ProjectFileExists ? "YES!" : "NO"}...");
    if (!$ProjectFileExists) {
      Write-Error("Project file $ProjectPath does not exist.");
      return;
    }
  }

  process {
    slngen --launch false $ProjectPath
    $project = [System.Xml.Linq.XDocument]::Load($ProjectPath)
    $projectReferences = $project.Descendants("ProjectReference")
    $projectReferences | ForEach-Object {
      $projectReference = $_
      $projectReferencePath = $projectReference.Attribute("Include").Value
      $projectReferenceFullPath = Join-Path (Split-Path $ProjectPath) $projectReferencePath
      Write-Debug("Processing project reference $projectReferenceFullPath...")
      dotnet sln add $projectReferenceFullPath
    }
    dotnet sln add $ProjectPath
  }
