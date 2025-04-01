@echo off
cd /d "%~dp0"
echo Sorting folders by size...

powershell -command "Get-ChildItem -Directory | ForEach-Object { $bytes = (Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum; if ($bytes -ge 1073741824) { $size = [math]::Round($bytes/1073741824, 2); $unit = 'GB' } elseif ($bytes -ge 1048576) { $size = [math]::Round($bytes/1048576, 2); $unit = 'MB' } else { $size = [math]::Round($bytes/1024, 2); $unit = 'KB' }; [PSCustomObject]@{ Name = $_.Name; Size = (\"{0:N2} {1}\" -f $size, $unit); Bytes = $bytes } } | Sort-Object Bytes -Descending | ForEach-Object -Begin { $i=1 } -Process { [PSCustomObject]@{ Name = ('{0}. {1}' -f $i++, $_.Name); Size = $_.Size } } | Format-Table -AutoSize | Out-File FoldersSize_Sorted.txt"

type "FoldersSize_Sorted.txt"
echo Done! Check "FoldersSize_Sorted.txt"
pause