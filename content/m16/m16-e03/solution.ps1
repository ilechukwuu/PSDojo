$Done = @('FS-01')

# Work queue of the patch night

$Done += 'FS-02'

$Queue = [System.Collections.Generic.List[string]]::new()

$Queue.Add('FS-03')
$Queue.Add('FS-04')
$Queue.Add('FS-05')
$null = $Queue.Remove('FS-04')

$StillQueued = $Queue.Contains('FS-05')
$Waiting = $Queue.Count
