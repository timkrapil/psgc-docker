$LogStashServer = "127.0.0.1"
$LogStashPort = "5000"

$tcpConnection = New-Object System.Net.Sockets.TcpClient($LogStashServer, $LogStashPort)
$tcpStream = $tcpConnection.GetStream()
$writer = New-Object System.IO.StreamWriter($tcpStream)
$writer.AutoFlush = $true

Get-ChildItem / -Recurse -file  | ForEach-Object {
    $json = $_ | Select-Object -Property fullname,lastwritetime,DirectoryName,Extension,Name,IsReadOnly,CreationTime,LastAccessTime,Length | convertto-json -Compress
    $writer.WriteLine($json) 
} 


$writer.Close()
$tcpConnection.Close()