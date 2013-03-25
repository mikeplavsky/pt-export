Param(

  [Parameter(Mandatory=$True, Position=1)]
  [string]$ProjectId,

  [Parameter(Mandatory=$True)]
  [string]$PtKey,

  [Parameter(Mandatory=$False)]
  [string]$Proxy

)

function GetStory {
 process {
    new-object -TypeName PsObject -Property @{ 

      Name = $_.Name
      Type = $_.story_type      
      Estimate = $_.Estimate.InnerText   
      Created = $_.created_at.InnerText
    }
 }
}

$url = "https://www.pivotaltracker.com/services/v3/projects/$ProjectId/stories?type:feature,release"
$params = @{Uri=$url; Header=@{"X-TrackerToken" = $PtKey }}

if ($Proxy) {

    $params.Add( "Proxy", $Proxy)
    $params.Add( "ProxyUseDefaultCredentials", $true)

}

$res = Invoke-WebRequest @params
([xml]$res.Content).stories.ChildNodes | GetStory | Export-CSV -Path "result.csv" -notype


