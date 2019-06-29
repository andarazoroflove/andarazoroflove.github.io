Dim FSO, objFile, RegEx, strDestin, strSource 
Set FSO = CreateObject("Scripting.FileSystemObject")
Set RegEx = New RegExp
RegEx.Global = True
RegEx.Pattern = "[ ]{2,}" 
Const ForReading = 1
strSource = Wscript.StdIn.ReadLine
strDestin = "c:\output.txt" 
Set objFile = FSO.CreateTextFile(strDestin, True)
objFile.Write strSource
objFile.Close 