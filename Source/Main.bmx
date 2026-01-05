SuperStrict

Framework brl.standardio
Import brl.linkedlist
Import brl.textstream
Import brl.filesystem

Type WaterSample
    Field station:String
    Field parameter:String
    Field value:String
    Field date:String
    Field ecoScore:Float
End Type

Local samples:TList = New TList
Local file:TTextStream = ReadFile("Data/ArizonaGilaLakePleasant_WaterQuality_2024-2026_v1.csv")
If Not file Then RuntimeError "CSV not found"

Local header:String = file.ReadLine()

While Not file.Eof()
    Local line:String = file.ReadLine().Trim()
    If line = "" Continue
    Local fields:String[] = line.Split(",")
    If fields.length < 11 Continue
    
    Local s:WaterSample = New WaterSample
    s.station = fields[0]
    s.parameter = fields[5]
    s.value = fields[7]
    s.date = fields[8]
    s.ecoScore = Float(fields[10])
    samples.AddLast(s)
Wend
file.Close()

Local totalScore:Float = 0
Local count:Int = 0
Print "Arizona Water Quality Summary (2024-2026):"
For Local s:WaterSample = EachIn samples
    Print s.station + " | " + s.parameter + " = " + s.value + " (" + s.date + ") EcoScore: " + s.ecoScore:.2f
    totalScore :+ s.ecoScore
    count :+ 1
Next

If count > 0
    Local avgScore:Float = totalScore / count
    Print "Average Eco-Impact Score: " + avgScore:.3f + " → Priority if < 0.75"
End If
