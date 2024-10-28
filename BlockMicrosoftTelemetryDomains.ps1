If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit	
}

# path to the hosts file
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"

# path to backup the current hosts file
$backupPath = "C:\Windows\System32\drivers\etc\hosts.bak"

# hosts file content
$defaultHostsContent = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handle within DNS itself.
#       127.0.0.1       localhost
#       ::1             localhost

# Block Razer and ASUS Downloads
#
0.0.0.0 synapse3ui-common.razerzone.com
0.0.0.0 bespoke-analytics.razerapi.com
0.0.0.0 discovery.razerapi.com
0.0.0.0 manifest.razerapi.com
0.0.0.0 cdn.razersynapse.com
0.0.0.0 assets.razerzone.com
0.0.0.0 assets2.razerzone.com
0.0.0.0 deals-assets-cdn.razerzone.com
0.0.0.0 synapse-3-webservice.razerzone.com
0.0.0.0 albedozero.razerapi.com
0.0.0.0 gms.razersynapse.com
0.0.0.0 fs.razersynapse.com
0.0.0.0 id.razer.com
0.0.0.0 liveupdate01s.asus.com
0.0.0.0 asusactivateservice.azurewebsites.net
0.0.0.0 rog-live-service.asus.com
0.0.0.0 dlcdn-rogboxbu1.asus.com
0.0.0.0 dlcdn-rogboxbu2.asus.com
0.0.0.0 mymessage.asus.com
0.0.0.0 gaming-config.asus.com
0.0.0.0 rog-content-platform.asus.com
0.0.0.0 nomos.asus.com
0.0.0.0 dlcdnrog.asus.com
0.0.0.0 account.asus.com

"@

# check if hosts file exists and backup
if (Test-Path -Path $hostsFile) {
    Copy-Item -Path $hostsFile -Destination $backupPath -Force

}

# overwrite the hosts file with default content
$defaultHostsContent | Set-Content -Path $hostsFile -Force

# define the URL of the .txt file
$url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/native.winoffice.txt"

# download the file from the URL
$downloadedFileContent = Invoke-WebRequest -Uri $url -UseBasicParsing

# check if the local file exists, if not, create it
if (-not (Test-Path $hostsFile)) {
    New-Item -Path $hostsFile -ItemType File
}

# append the downloaded content to the local file
$downloadedFileContent.Content | Add-Content -Path $hostsFile

# flush dns cache to apply changes
ipconfig /flushdns
