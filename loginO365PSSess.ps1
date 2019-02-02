#  examples are educational... clear text creds in a script is either bold or reckless, i forget which

$adm365 = "adminuser@thedomain.onmicrosoft.com"
$pass = ConvertTo-SecureString "pa55word1ntxt?nevah!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ( $pass)
$sess = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $sess -AllowClobber
