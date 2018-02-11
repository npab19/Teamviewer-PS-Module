<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.145
	 Created on:   	2018-02-10 7:06 PM
	 Created by:   	MaximeB
	 Organization: 	MB_Tools
	 Filename:     	TeamViewerPSModules.psm1
	-------------------------------------------------------------------------
	 Module Name: TeamViewerPSModules
	===========================================================================
#>

function Test-TVToken ($token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$TokenTest = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/ping" -Method GET -Headers $header -ContentType application/json
	$TokenTest.token_valid
}

function Get-TVAccountInformation ($token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Account = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/account" -Method GET -Headers $header -ContentType application/json
	$Account
}

function Get-TVDeviceId ($alias, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Device = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices?full_list=true" -Method GET -Headers $header -ContentType application/json
	$DeviceInformation = $Device.devices | Where-Object {$_.alias -like "*$alias*"}
	$DeviceInformation.device_id
}

function Get-TVDevicesId ($token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices?full_list=true" -Method GET -Headers $header -ContentType application/json
}

function Get-TVUserID ($UserEmail, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Users = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/users?email=$UserEmail" -Method GET -Headers $header -ContentType application/json
	$UserInformation = $Users.users | Where-Object { $_.email -like "*$UserEmails*" }
	$UserInformation.id
}

function Get-TVUserInformation ($Userid, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Users = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/users/$Userid" -Method GET -Headers $header -ContentType application/json
	$Users
}

function Get-TVUsers ($token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Users = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/users?full_list=true" -Method GET -Headers $header -ContentType application/json
	$Users.Users
}

function Share-TVGroup ($GroupID, $GroupPermissions, $UserId, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$body = @{
		Users    = @(
			@{
				userid	     = "$UserId"
				permissions  = "$permission"
			}
		)
	} | ConvertTo-Json
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/groups/$GroupID/share_group" -Method Post -Headers $header -ContentType application/json -Body "$body"
}

function Unshare-TVGroup ($GroupID, $UserId, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$body = @{
		Users	  = @(
			@{
				userid	     = "$UserId"
			}
		)
	} | ConvertTo-Json
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/groups/$groupID/unshare_group" -Method Post -Headers $header -ContentType application/json -Body "$body"
}

function Create-TVUser ($UserEmail, $defaultUserPermissions, $defaultUserLanguage, $defaultUserPassword, $UserFullName, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$body = (@{
			email		= $UserEmail
			password	= $defaultUserPassword
			name	  	= $UserFullName
			language  	= $defaultUserLanguage
			permission 	= $defaultUserPermissions
		}) | ConvertTo-Json
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/users" -Method Post -Headers $header -ContentType application/json -Body $body
}

function Delete-TVDevice ($deviceID, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices/$deviceID" -Method Delete -Headers $header -ContentType application/json
}

function Assign-TVPolicy ($devicesID, $policyid, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$body = (@{
			policy_id    = $policyid
		}) | ConvertTo-Json
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices/$devicesID" -Method PUT -Headers $header -ContentType application/json
}

function Assign-TVGroup ($devicesID, $groupID, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$body = (@{
			groupid	  = $groupID
		}) | ConvertTo-Json
	Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/devices/$devicesID" -Method PUT -Headers $header -ContentType application/json
}

function Get-TVPolicyId ($policyname, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$policies = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/teamviewerpolicies" -Method get -Headers $header -ContentType application/json
	$policieinfo = $policies.policies | Where-Object { $_.name -eq "$policyname" }
	$policieinfo.policy_id
}

function Get-TVGroupID ($name, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Group = Invoke-RestMethod -Uri "https://webapi.teamviewer.com//api/v1/groups?name=$name" -Method get -Headers $header -ContentType application/json
	$Group.groups.id
}

function Get-TVGroups ($token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Group = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/groups" -Method get -Headers $header -ContentType application/json
	$Group.groups
}

function Get-TVGroupDetail ($token, $groupID)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Group = Invoke-RestMethod -Uri "https://webapi.teamviewer.com/api/v1/groups/$groupID" -Method get -Headers $header -ContentType application/json
	$Group
}

function Cleanup-TVDevices ($onlineState, $LastSeen, $token)
{
	$header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$header.Add("authorization", "Bearer  $token")
	$Device = Get-TVDevicesId
	$DeviceInformation = $Device.devices | Where-Object { $_.online_state -eq "$onlineState" -and $_.last_seen -like "$LastSeen*" }
	$DeviceInformation.device_id
	foreach ($item in $DeviceInformation)
	{
		Delete-TVDevice -deviceID $item.device_id
	}
}


Export-ModuleMember -Function Test-TVToken,
					Get-TVAccountInformation,
					Get-TVDeviceId,
					Get-TVDevicesId,
					Get-TVUserID,
					Get-TVUserInformation,
					Get-TVUsers,
					Share-TVGroup,
					Unshare-TVGroup,
					Create-TVUser,
					Delete-TVDevice,
					Assign-TVPolicy,
					Assign-TVGroup,
					Get-TVPolicyId,
					Get-TVGroupID,
					Get-TVGroups,
					Get-TVGroupDetail,
					Cleanup-TVDevices