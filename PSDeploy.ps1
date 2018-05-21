
<#PSScriptInfo

.VERSION 0.2.3

.GUID de439f5f-af3a-4273-ac2c-8d9cce3ff19f

.AUTHOR jdfenw@gmail.com

.COMPANYNAME John D. Fisher

.COPYRIGHT Copyright (c) 2018 John D. Fisher

.TAGS 

.LICENSEURI https://github.com/jfishe/battery/blob/master/LICENSE.md

.PROJECTURI https://github.com/jfishe/battery

.ICONURI 

.EXTERNALMODULEDEPENDENCIES PSDeploy, PlatyPS

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 PSDeploy Script

#> 

Deploy ScheduleTask_Test-IsOnBattery {
    By PlatyPS {
        FromSource 'docs'
        To "ScheduleTask_Test-IsOnBattery\en-US"
        Tagged Help, Module
        WithOptions @{
            Force = $true
        }
    }
}
