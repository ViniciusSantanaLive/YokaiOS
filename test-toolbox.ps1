Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "YokaiOS Toolbox v1.0.0"
$Form.Size = New-Object System.Drawing.Size(800, 600)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 24)

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "YOKAI OS"
$Label.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$Label.ForeColor = [System.Drawing.Color]::FromArgb(139, 92, 246)
$Label.AutoSize = $true
$Label.Location = New-Object System.Drawing.Point(300, 50)
$Form.Controls.Add($Label)

$SubLabel = New-Object System.Windows.Forms.Label
$SubLabel.Text = "Windows 11 Ultra-Otimizado para Gaming"
$SubLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$SubLabel.ForeColor = [System.Drawing.Color]::FromArgb(148, 163, 184)
$SubLabel.AutoSize = $true
$SubLabel.Location = New-Object System.Drawing.Point(250, 100)
$Form.Controls.Add($SubLabel)

$Btn = New-Object System.Windows.Forms.Button
$Btn.Text = "Testar"
$Btn.Size = New-Object System.Drawing.Size(200, 50)
$Btn.Location = New-Object System.Drawing.Point(300, 200)
$Btn.BackColor = [System.Drawing.Color]::FromArgb(139, 92, 246)
$Btn.ForeColor = [System.Drawing.Color]::White
$Btn.FlatStyle = "Flat"
$Btn.Add_Click({ [System.Windows.Forms.MessageBox]::Show("YokaiOS funcionando!") })
$Form.Controls.Add($Btn)

[void]$Form.ShowDialog()
