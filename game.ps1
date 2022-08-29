Add-type -AssemblyName System.windows.forms
Add-Type -AssemblyName System.drawing
Add-Type -AssemblyName presentationCore
#$script is nessacaty for [int]/[bool] etc.
#ideas : EXP Drain Regen Sketch 
[bool]$BossFight = $False
$playtime = [System.Diagnostics.Stopwatch]::new()
$playtime.Start()
$points = 10
$Path = Get-Location 
$ActivePlayer = 1
$currentPartyMembers = @(1,2)
$MagicList =@("FIRE","ICE","BOLT") 
$FireRNG = @(1,2,3)
$CritRNG = @(0,1,2,3,4,5,6,7,8,9)
$CurrentMagic = "NA"
$DrainGain = 5
$TargetPlayer=1
$Floor = 1
$Darkyellow = "#8c8527"
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open("$path\data\ff1bat.mp3")
$mediaPlayer.Play()
[Bool]$MonsterADead = $false
[Bool]$Script:Fighter1Dead = $false
[Bool]$Script:CecilDead = $false
[bool]$Script:ThiefDead = $true
$HPGain = 10
$CecilCureCasts = 5
#region Stats
$DamageOutput = 0
[int]$Fighter1HP = 100
[int]$Fighter1MaxHP = 100
[int]$fighter1Attack = 12
[int]$CecilAttack = 15 #cecil Att
[int]$CecilHP = 90 #cecil HP
[int]$CecilMAXHP = 90 #cecil MAXHP
[int]$ThiefAttack = 24 #thief Att
[int]$ThiefHP = 110 #thief HP
[int]$ThiefMAXHP = 110 #thief MAXHP

$MonsterAHP = 6
$MonsterAAT = 100


#endregion Stats

Function Main {

$iconBase64      = 'iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAMUExURYgLEU8ADO0cJAAAAF5+rw4AAAAEdFJOU////wBAKqn0AAAACXBIWXMAAA7DAAAOwwHHb6hkAAAApUlEQVQ4T6WTSxLEIAhEEe9/52k+mdAkak0NG5F+NrBQ5iF+BuRRyDNDxuiVPCNkqDSCbtBVGlEv9t4ciCi5vwfAxJ3GewOIYAD6HoBuBIBv/U4wge1gW1SLCniHyyLLDKTDEogWegJ2Dj7DxiGGPAPrLXwGVZNfgMuidWiAeQAAksUG+B5LByf6iAREE5oQUfPwYJ0B92C9ASCa3oHjz3rGv8CcH9xUCT/mlxYxAAAAAElFTkSuQmCC'
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)  
$Win = New-Object System.Windows.Forms.Form
$Win.Text = "Final Fantasy Tower: Floor $Floor"
$Win.size = "800,600"
$Win.BackColor = "black"
$Win.ForeColor = "white"
$Win.Icon = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$pointsGauge = New-Object System.Windows.Forms.Label
$pointsGauge.Text = "PTS: $Points"
$pointsGauge.Location = "700,70"
$pointsGauge.ForeColor = "white"
$pointsGauge.size  = "60,24"

$Fighter1AttackPanel = New-Object System.Windows.Forms.Button
$Fighter1AttackPanel.text = "PWR UP (3PTS)"
$Fighter1AttackPanel.Size = "115,20"
$Fighter1AttackPanel.Location = "665,100"
$Fighter1AttackPanel.add_CLick({Fighter1RaiseAttackStat})
$Fighter1AttackPanel.BackColor = "DarkBlue"

$Fighter1HPPanel = New-Object System.Windows.Forms.Button
$Fighter1HPPanel.text = "MaxHP UP (3PTS)"
$Fighter1HPPanel.Size = "115,20"
$Fighter1HPPanel.Location = "665,124"
$Fighter1HPPanel.add_CLick({Fighter1RaiseHPStat})
$Fighter1HPPanel.BackColor = "DarkBlue"

$Fighter1AttackPanelX = New-Object System.Windows.Forms.Button
$Fighter1AttackPanelX.text = "PWR UP (15PTS)"
$Fighter1AttackPanelX.Size = "115,20"
$Fighter1AttackPanelX.Location = "665,148"
$Fighter1AttackPanelX.add_CLick({Fighter1RaiseAttackStatX})
$Fighter1AttackPanelX.BackColor = "DarkBlue"

$Fighter1HPPanelX = New-Object System.Windows.Forms.Button
$Fighter1HPPanelX.text = "MaxHP Up (15PTS)"
$Fighter1HPPanelX.Size = "115,20"
$Fighter1HPPanelX.Location = "665,172"
$Fighter1HPPanelX.add_CLick({Fighter1RaiseHPStatX})
$Fighter1HPPanelX.BackColor = "DarkBlue"

$CecilAttackPanel = New-Object System.Windows.Forms.Button
$CecilAttackPanel.text = "PWR UP (3PTS)"
$CecilAttackPanel.Size = "115,20"
$CecilAttackPanel.Location = "665,200"
$CecilAttackPanel.add_CLick({CecilRaiseAttackStat})
$CecilAttackPanel.BackColor = "DarkRed"

$CecilHPPanel = New-Object System.Windows.Forms.Button
$CecilHPPanel.text = "MaxHP Up (3PTS)"
$CecilHPPanel.Size = "115,20"
$CecilHPPanel.Location = "665,224"
$CecilHPPanel.add_CLick({CecilRaiseHPStat})
$CecilHPPanel.BackColor = "DarkRed"

$CecilAttackPanelX = New-Object System.Windows.Forms.Button
$CecilAttackPanelX.text = "PWR UP (15PTS)"
$CecilAttackPanelX.Size = "115,20"
$CecilAttackPanelX.Location = "665,248"
$CecilAttackPanelX.add_CLick({CecilRaiseAttackStatX})
$CecilAttackPanelX.BackColor = "DarkRed"

$CecilHPPanelX = New-Object System.Windows.Forms.Button
$CecilHPPanelX.text = "MaxHP Up (15PTS)"
$CecilHPPanelX.Size = "115,20"
$CecilHPPanelX.Location = "665,272"
$CecilHPPanelX.BackColor = "DarkRed"
$CecilHPPanelX.add_CLick({CecilRaiseHPStatX})


$ThiefAttackPanel = New-Object System.Windows.Forms.Button
$ThiefAttackPanel.text = "PWR UP (3PTS)"
$ThiefAttackPanel.Size = "115,20"
$ThiefAttackPanel.Location = "665,300"
$ThiefAttackPanel.add_CLick({ThiefRaiseAttackStat})
$ThiefAttackPanel.BackColor = "DarkGreen"

$ThiefHPPanel = New-Object System.Windows.Forms.Button
$ThiefHPPanel.text = "MaxHP Up (3PTS)"
$ThiefHPPanel.Size = "115,20"
$ThiefHPPanel.Location = "665,324"
$ThiefHPPanel.add_CLick({ThiefRaiseHPStat})
$ThiefHPPanel.BackColor = "DarkGreen"

$ThiefAttackPanelX = New-Object System.Windows.Forms.Button
$ThiefAttackPanelX.text = "PWR UP (15PTS)"
$ThiefAttackPanelX.Size = "115,20"
$ThiefAttackPanelX.Location = "665,348"
$ThiefAttackPanelX.add_CLick({ThiefRaiseAttackStatX})
$ThiefAttackPanelX.BackColor = "DarkGreen"

$ThiefHPPanelX = New-Object System.Windows.Forms.Button
$ThiefHPPanelX.text = "MaxHP Up (15PTS)"
$ThiefHPPanelX.Size = "115,20"
$ThiefHPPanelX.Location = "665,372"
$ThiefHPPanelX.BackColor = "DarkGreen"
$ThiefHPPanelX.add_CLick({ThiefRaiseHPStatX})


$CombatButton = New-Object System.Windows.Forms.Button
$CombatButton.text = "Engage"
$CombatButton.Size = "70,40"
$CombatButton.Location = "500,500"
$CombatButton.add_CLick({EngageCombat})
$CombatButton.BackColor = "DarkBlue"

$SaveButton = New-Object System.Windows.Forms.Button
$SaveButton.text = "Save Record"
$SaveButton.Size = "70,40"
$SaveButton.Location = "100,500"
$SaveButton.add_CLick({SaveGameData})
$SaveButton.BackColor = "DarkBlue"

$LoadButton = New-Object System.Windows.Forms.Button
$LoadButton.text = "Load Record"
$LoadButton.Size = "70,40"
$LoadButton.Location = "200,500"
$LoadButton.add_CLick({LoadGameData})
$LoadButton.BackColor = "DarkBlue"

#region BattleUI

$Fighter1ActList = New-Object System.Windows.Forms.Listbox
$Fighter1ActList.Items.Add('Fight')
$Fighter1ActList.Items.Add('Spell')
$Fighter1ActList.Items.Add('Guard up')
$Fighter1ActList.Items.Add('Drain')
$Fighter1ActList.Size = "60,68"
$Fighter1ActList.Location = "600,100"
$Fighter1ActList.foreColor = "White"
$Fighter1ActList.BackColor = "DarkBlue"
$Fighter1ActList.Add_SelectedIndexChanged{
    if ($Fighter1ActList.SelectedIndex -eq 0) {$Fighter1.Image = $Fighter1Readyimg; $fighter1.location = "515,100"}
    if ($Fighter1ActList.SelectedIndex -eq 1) {$Fighter1.Image = $Fighter1Magicimg;$fighter1.location = "525,100"}
    if ($Fighter1ActList.SelectedIndex -eq 2) {$Fighter1.Image = $Fighter1guardimg; $fighter1.location = "520,100"}
    if ($Fighter1ActList.SelectedIndex -eq 3) {$Fighter1.Image = $Fighter1Magicimg;$fighter1.location = "525,100"}
}

$Fighter1HPGauge = New-object System.windows.forms.label
$Fighter1HPGauge.text = "$Fighter1HP / $fighter1MaxHP"
$Fighter1HpGauge.location = "600,75"
$Fighter1HPGauge.Size  = "65,20"
$Fighter1HPGauge.font = "Arial, 10"
$Fighter1HPGauge.foreColor = "White"



$CecilActList = New-Object System.Windows.Forms.Listbox
$CecilActList.Items.Add('Fight')
$CecilActList.Items.Add('Cure')
$CecilActList.Items.Add('Boost')
$CecilActList.Items.Add('Cheer')
$CecilActList.Size = "60,68"
$CecilActList.Location = "600,200"
$CecilActList.foreColor = "White"
$CecilActList.BackColor = "Darkred"
$CecilActList.Add_SelectedIndexChanged{
    if ($CecilActList.SelectedIndex -eq 0) {$Cecil.Image = $CecilReadyimg; $Cecil.location = "535,200"}
    if ($CecilActList.SelectedIndex -eq 1) {$Cecil.Image = $CecilMagicimg;$Cecil.location = "545,200"}
    if ($CecilActList.SelectedIndex -eq 2) {$Cecil.Image = $Cecilguardimg; $Cecil.location = "540,200"}
    if ($CecilActList.SelectedIndex -eq 3) {$Cecil.Image = $Cecilwinimg; $Cecil.location = "535,200"}

}

$CecilHPGauge = New-object System.windows.forms.label
$CecilHPGauge.text = "$CecilHP / $CecilMaxHP"
$CecilHPGauge.location = "600,180"
$CecilHPGauge.Size  = "65,20"
$CecilHPGauge.font = "Arial, 10"
$CecilHPGauge.foreColor = "White"


$ThiefActList = New-Object System.Windows.Forms.Listbox
$ThiefActList.Items.Add('Fight')
$ThiefActList.Items.Add('Mug')
$ThiefActList.Items.Add('Item')
$ThiefActList.Items.Add('Taunt')
$ThiefActList.Size = "60,68"
$ThiefActList.Location = "600,300"
$ThiefActList.foreColor = "White"
$ThiefActList.BackColor = "darkgreen"
$ThiefActList.Add_SelectedIndexChanged{
    if ($ThiefActList.SelectedIndex -eq 0) {$Thief.Image = $ThiefReadyimg; $Thief.location = "515,300"}
    if ($ThiefActList.SelectedIndex -eq 1) {$Thief.Image = $ThiefMagicimg;$Thief.location = "525,300"}
    if ($ThiefActList.SelectedIndex -eq 2) {$Thief.Image = $Thiefguardimg; $Thief.location = "520,300"}
    if ($ThiefActList.SelectedIndex -eq 3) {$Thief.Image = $ThiefReadyimg; $Thief.location = "515,300"}

}

$ThiefHPGauge = New-object System.windows.forms.label
$ThiefHPGauge.text = "$ThiefHP / $ThiefMaxHP"
$ThiefHPGauge.location = "600,280"
$ThiefHPGauge.Size  = "65,20"
$ThiefHPGauge.font = "Arial, 10"
$ThiefHPGauge.foreColor = "White"


$MonsterADMG = New-Object System.Windows.Forms.Label
$MonsterADMG.Text = ""
$MonsterADMG.Location = "260,120"
$MonsterADMG.Size = "60,28"
$MonsterADMG.Font = "Arial Black, 12"
$MonsterADMG.ForeColor = "DarkRed"
$MonsterADMG.backcolor = "Black"
#endregion BattleUI


$Win.Controls.Add($GameWeapon)
$Win.Controls.Add($fighter1)
$Win.Controls.Add($Cecil)
$Win.Controls.Add($CombatButton)
$Win.Controls.Add($Fighter1HpGauge)
$Win.Controls.Add($fighter1ACtList)
$Win.Controls.Add($thief) #nessacary or layer breaks with enemeis, set to invisble until {ThiefJoins}

$Win.Controls.Add($monstera)
$Win.Controls.Add($MonsterADMG)
$Win.Controls.Add($CecilActList)
$Win.Controls.Add($CecilHPGauge)
$win.Controls.Add($background)
$win.Controls.Add($SaveButton)
$win.Controls.Add($LoadButton)
$win.Controls.Add($PointsGauge)
$win.Controls.Add($Fighter1AttackPanel)
$win.Controls.Add($Fighter1HPPanel)
$win.Controls.Add($Fighter1AttackPanelX)
$win.Controls.Add($Fighter1HPPanelX)
$win.Controls.Add($CecilAttackPanel)
$win.Controls.Add($CecilHPPanel)
$win.Controls.Add($CecilAttackPanelX)
$win.Controls.Add($CecilHPPanelX)


$Win.ShowDialog()

} 

Function EngageCombat {

If ($Fighter1Dead -eq $False) {Start-Sleep -milliseconds 800}
If ($Fighter1Actlist.SelectedIndex -eq 0) {
    $Script:ActivePlayer = 1
    PhysicalDamageCalc
    $Fighter1ActList.SelectedIndex = -1
    iF ($fighter1Dead -eq $false) {Restorefighter1}
    }
If ($Fighter1Actlist.SelectedIndex -eq 1) {
    $Script:ActivePlayer = 1
    GetSpell
    $Fighter1ActList.SelectedIndex = -1
    iF ($fighter1Dead -eq $false) {Restorefighter1}
    }
If ($Fighter1Actlist.SelectedIndex -eq 2) {
    $Script:ActivePlayer = 1
    BuffDefense
    $Fighter1ActList.SelectedIndex = -1
    iF ($fighter1Dead -eq $false) {Restorefighter1}
    }

If ($Fighter1Actlist.SelectedIndex -eq 3) {
    $Script:ActivePlayer = 1
    DrainSpell
    $Fighter1ActList.SelectedIndex = -1
    iF ($fighter1Dead -eq $false) {Restorefighter1}
    }

If ($CecilDead -eq $False) {Start-Sleep -milliseconds 800}


#pplayer2
If ($CecilActlist.SelectedIndex -eq 0) {
    $Script:ActivePlayer = 2
    
    CecilPhysicalDamageCalc
    $CecilActlist.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    }
If ($CecilActlist.SelectedIndex -eq 1) {
    $Script:ActivePlayer = 2
    CecilCure
    $CecilActlist.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    }
If ($CecilActlist.SelectedIndex -eq 2) {
    $Script:ActivePlayer = 2
    CecilBoostATTACK
    $CecilActlist.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    
    }
If ($CecilActlist.SelectedIndex -eq 3) {
    $Script:ActivePlayer = 2
    CecilCheer
    $CecilActlist.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    
    }

If ($ThiefDead -eq $False) {Start-Sleep -milliseconds 800}



#pLAYER 3
If ($ThiefActList.SelectedIndex -eq 0) {
    $Script:ActivePlayer = 3
    
    thiefPhysicalDamageCalc
    $ThiefActList.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    }
If ($ThiefActList.SelectedIndex -eq 1) {
    $Script:ActivePlayer = 3
    ThiefMug
    $ThiefActList.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    }
If ($ThiefActList.SelectedIndex -eq 2) {
    $Script:ActivePlayer = 3
    GetItem
    $ThiefActList.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    
    }

If ($ThiefActList.SelectedIndex -eq 3) {
    $Script:ActivePlayer = 3
    ThiefTaunt
    $ThiefActList.SelectedIndex = -1
    iF ($CecilDead -eq $false) {RestorecECIL}
    
    }

    Start-Sleep -milliseconds 800
$MonsterADMG.Text = ""

If ($MonsterADead -eq $False) {
    If ($BossFight -eq $true) {
        $Script:BossOPtion = $FireRNG | Get-Random
        If ($BossOPtion -eq 3) {
            BossDamageCalc
            } Else { 
                MonsterDamageCalc 
            } 
        }  

    }
If ($MonsterADead -eq $False) {
    If ($BossFight -ne $true) {
        MonsterDamageCalc 
    }
    }
If ($MonsterADead -eq $true) {LoadNextFloor}
}



Function PhysicalDamageCalc {




If ($ActivePlayer = 1) {
                        
                                       
                        $fighter1.location = "490,100"
                        $GameWeapon.Location = "464,103"
                        $Fighter1.Image = $Fighter1swingimg 
                        $GameWeapon.size = "28,30"
                        $GameWeapon.image = $W_Excaliburimg 
                        $gameweapon.Visible = $true
                        Start-Sleep -Milliseconds 750
                        RestoreFighter1
                        $gameweapon.Visible = $false
                        
                        
                        $Script:CritChance = $CritRNG | Get-Random
                        If ($CritChance -eq 9) {$Script:Fighter1Attack = $fighter1attack * 2}

                        [int]$Script:DamageOutput = $fighter1Attack * 1.3
                        $Script:MonsterAHP = $MonsterAHP - $DamageOutput
                        
                        If ($MonsterAHP -le 0) {
                        $MonsterADMG.Text = "$DamageOutput"
                        Start-Sleep -Milliseconds 600
                        $MonsterADMG.Text = ""
                        $MonsterA.visible = $false
                        $Script:MonsterADead = $true
                        FloorCompleteRoutine
                        } 
                        If ($CritChance -eq 9) {$Script:Fighter1Attack = $fighter1attack / 2}
                        If ($MonsterAHP -gt 0){$MonsterADMG.Text = "$DamageOutput"}
                        
    }

                        

                        

Write-Host $MonsterAHP -for red                        
Start-Sleep -Milliseconds 800
$MonsterADMG.Text = ""


}

Function GetSPell {

$Script:CurrentMagic = $magiclist | Get-Random

If ($ActivePlayer -eq 1){
    If ($CurrentMagic -eq "Fire") {
                                 $Script:Critpower = $FireRNG | Get-Random
                                 If ($Critpower -eq 3) {$Script:Critpower = $fighter1Attack + $fighter1Attack}
                                 [int]$Script:DamageOutput = $fighter1Attack + $MonsterAAT + $CRITPOWER
                                 #Fire Anim Here
                                 $fighter1.image = $Fighter1Winimg
                                 $fighter1.location = "515,99"
                                 $GameWeapon.visible = $true
                                 $gameweapon.size = "48,48"
                                 $gameWeapon.location = "220,210"
                                 $GameWeapon.image = $S_Fire
                                 Start-Sleep -Milliseconds 750
                                }
    If ($CurrentMagic -eq "Ice") {
                                 [int]$Script:DamageOutput = $fighter1Attack - 2 + $MonsterAAT
                                 $Script:Fighter1Attack++
                                 Write-host $Fighter1ATtack -for Green
                                 #ICE ANIM HERE
                                 $fighter1.image = $Fighter1Winimg
                                 $fighter1.location = "515,99"
                                 $GameWeapon.visible = $true
                                 $gameweapon.size = "38,72"
                                 $gameWeapon.location = "220,210"
                                 $GameWeapon.image = $S_ICE
                                 Start-Sleep -Milliseconds 750
                                }
    If ($CurrentMagic -eq "Bolt") {
                                
                                [int]$Script:DamageOutput = $fighter1Attack + $MonsterAAT + 7
                                #BOLT ANIM HERE
                                 $fighter1.image = $Fighter1Winimg
                                 $fighter1.location = "515,99"
                                 $GameWeapon.visible = $true
                                 $gameweapon.size = "60,64"
                                 $gameWeapon.location = "220,210"
                                 $GameWeapon.image = $S_Bolt
                                 Start-Sleep -Milliseconds 750
                                }

    RestoreFighter1
    $Script:MonsterAHP = $MonsterAHP - $DamageOutput

    $GameWeapon.visible = $false                    
    $MonsterADMG.Text = "$DamageOutput"
    Start-Sleep -Milliseconds 800       
    If ($MonsterAHP -le 0) {
                            $MonsterADMG.Text = ""
                            $MonsterA.visible = $false
                            FloorCompleteRoutine   
                            }
    Write-Host $MonsterAHP -for red
    }

Start-Sleep -Milliseconds 450
$MonsterADMG.Text = ""
}

Function BuffDefense {

[int]$Script:MonsterAAT = $MonsterAAT / 1.5
If ($MonsterAAT -le 0) {$Script:MonsterAAT = 2}
$Fighter1.image = $Fighter1swingimg
$GameWeapon.image = $shieldimg
$GameWeapon.size = "30,32"
$GameWeapon.location = "500,112"
$GameWeapon.visible = $true
Start-Sleep -Seconds 1
$GameWeapon.visible = $false





}

Function DrainSpell {

#drain Anim
$GameWeapon.image = $S_Drain
$GameWeapon.location = "419,100"
$GameWeapon.size = "51,44"
$fighter1.location = "470,100"
$fighter1.image = $fighter1winimg
$GameWeapon.visible = $true
Start-Sleep -Milliseconds 900
$GameWeapon.visible = $false
restorefighter1
#drain math
$script:DrainGain = $MonsterAHP / 13 - $floor 
[int]$script:Fighter1HP = $fighter1HP + $DrainGain
[int]$script:DamageOutput = $MonsterAHP / 14
$MonsterADMG.Text = "$DamageOutput"
Start-Sleep -Milliseconds 800
$MonsterADMG.Text = ""
$script:MonsterAHP = $MonsterAHP - $DamageOutput

If ($Fighter1HP -gt $Fighter1MaxHp) {
    $script:Fighter1HP = $Fighter1MaxHP
    }
$Fighter1HpGauge.Text = "$Fighter1Hp / $fighter1MaxHP"

Write-Host "monHP $monsterAHP"

}


Function CecilPhysicalDamageCalc {




If ($ActivePlayer = 2) {
                        
                                       
                        $Cecil.location = "490,200"
                        $GameWeapon.Location = "464,203"
                        $Cecil.Image = $Cecilswingimg 
                        $GameWeapon.size = "28,30"
                        $GameWeapon.image = $W_Crystalimg 
                        $gameweapon.Visible = $true
                        Start-Sleep -Milliseconds 750
                        RestoreCecil
                        $gameweapon.Visible = $false
                        $Script:CritChance = $CritRNG | Get-Random
                        If ($CritChance -eq 9) {$Script:cecilAttack = $cecilAttack * 2}                        
                        
                        [int]$Script:DamageOutput = $CecilAttack * 1.3
                        $Script:MonsterAHP = $MonsterAHP - $DamageOutput
                        
                        If ($MonsterAHP -le 0) {
                        $MonsterADMG.Text = "$DamageOutput"
                        Start-Sleep -Milliseconds 800
                        $MonsterADMG.Text = ""
                        $MonsterA.visible = $false
                        $Script:MonsterADead = $true
                        FloorCompleteRoutine
                        }
                        If ($CritChance -eq 9) {$Script:cecilAttack = $cecilAttack / 2}   
                        If ($MonsterAHP -gt 0){$MonsterADMG.Text = "$DamageOutput"}
                        
    }

                        

                        

Write-Host $MonsterAHP -for red
                        
}

Function CecilCure {

If ($CecilCureCasts -gt 0){

    [int]$script:HPGain = $Fighter1MaxHp / 9
    [int]$Script:Fighter1HP = $Fighter1HP + $HPGain

    [int]$script:HPGain = $CecilMaxHP / 9
    [int]$Script:CecilHP = $CecilHP + $HPGain

    [int]$script:HPGain = $ThiefMaxHp / 9
    [int]$Script:ThiefHP = $ThiefHP + $HPGain

    If ($Fighter1HP -gt $Fighter1MaxHp) {
    $script:Fighter1HP = $Fighter1MaxHP
        }
    If ($CecilHP -gt $CecilMaxHp) {
    $script:CecilHp = $CecilMaxHP
        }

    If ($ThiefHP -gt $ThiefMaxHp) {
    $script:ThiefHP = $ThiefMaxHP
        }

    $cecil.Location = "510,200"
    $cecil.Image = $cecilwinimg
    Start-Sleep -Milliseconds 700
    $cecil.Location = "540,200"
    $cecil.Image = $cecilimg
    Start-Sleep -Milliseconds 200
    $Fighter1HPGauge.text = "$Fighter1HP / $fighter1MaxHP"
    $CecilHPGauge.text = "$CecilHP / $CecilMaxHP"
    $Fighter1HPGauge.text = "$ThiefHP / $THiefMaxHP"
    $SCript:CecilCureCasts--
    $CecilActList.SelectedIndex
    }

If ($CecilCureCasts -le 0) {
    $cecilHPGauge.Text = "NO MP!"
    Start-Sleep -Seconds 1
    $cecilHPGauge.Text = "$CecilHP / $CecilMaxHP"
    }
}

Function CecilBoostAttack {


[int]$Script:CecilAttack = $CecilAttack * 1.175
$cecil.image = $cecilWinimg
$GameWeapon.image = $Powerupimg
Start-Sleep -Milliseconds 100
$GameWeapon.size = "32,32"
$GameWeapon.location = "540,160"
$GameWeapon.visible = $true
Start-Sleep -Seconds 1
$GameWeapon.visible = $false
$cecil.image = $cecilimg




}

Function CecilCheer {

Write-Host "BF ATT: F: $fighter1Attack C:$CecilAttack T:$thiefAttack"
$cecil.location = "440,200"
$cecil.image = $cecilwinimg
Start-Sleep -Milliseconds 500
$cecil.image = $cecilimg
Start-Sleep -Milliseconds 500
$cecil.image = $cecilwinimg
Start-Sleep -Milliseconds 500
$fighter1.image = $fighter1winimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefwinimg
Start-Sleep -Milliseconds 500
[int]$Script:CecilAttack = $CecilAttack * 1.1
[int]$Script:thiefAttack = $thiefAttack * 1.1
[int]$Script:Fighter1Attack = $Fighter1Attack * 1.1
RestoreCecil
Restorefighter1
Restorethief
Write-Host "AF ATT: F: $fighter1Attack C:$CecilAttack T:$thiefAttack"

}





Function ThiefPhysicalDamageCalc {




If ($ActivePlayer = 3) {
                        
                                       
                        $Thief.location = "470,300"
                        $GameWeapon.Location = "444,303"
                        $Thief.Image = $Thiefswingimg 
                        $GameWeapon.size = "28,30"
                        $GameWeapon.image = $W_rapierimg 
                        $gameweapon.Visible = $true
                        Start-Sleep -Milliseconds 750
                        RestoreThief
                        $gameweapon.Visible = $false
                        $Script:CritChance = $CritRNG | Get-Random
                        If ($CritChance -eq 9) {$Script:ThiefAttack = $ThiefAttack * 2}                        
                        
                        [int]$Script:DamageOutput = $ThiefAttack * 1.3
                        $Script:MonsterAHP = $MonsterAHP - $DamageOutput
                        
                        If ($MonsterAHP -le 0) {
                        $MonsterADMG.Text = "$DamageOutput"
                        Start-Sleep -Milliseconds 800
                        $MonsterADMG.Text = ""
                        $MonsterA.visible = $false
                        $Script:MonsterADead = $true
                        FloorCompleteRoutine
                        }
                        If ($CritChance -eq 9) {$Script:ThiefAttack = $ThiefAttack / 2} 
                        If ($MonsterAHP -gt 0){$MonsterADMG.Text = "$DamageOutput"}
                        
    }

                        

                        

Write-Host $MonsterAHP -for red
$MonsterADMG.Text = ""
}

Function ThiefMug {

If ($ActivePlayer = 3) {
                        
                        $thief.Image = $thiefimg  
                        Start-Sleep -Milliseconds 200            
                        $thief.location = "240,220"
                        $GameWeapon.Location = "211,220"
                        $thief.Image = $Thiefswingimg 
                        $GameWeapon.size = "28,30"
                        $GameWeapon.image = $W_rapierimg 
                        $gameweapon.Visible = $true
                        Start-Sleep -Milliseconds 500
                        $gameweapon.Visible = $false
                        $thief.Image = $thiefimg 
                        Start-Sleep -Milliseconds 500
                        $thief.Image = $thiefswingimg 
                        $gameweapon.Visible = $true
                        Start-Sleep -Milliseconds 500
                        $gameweapon.Visible = $false
                        Restorethief

                        $Script:CritChance = $CritRNG | Get-Random
                        If ($CritChance -eq 9) {$Script:ThiefAttack = $ThiefAttack * 2}    
                        [int]$Script:DamageOutput = $thiefAttack * 1.1 - $MonsterAAT 
                        if ($DamageOutput -le 0) {[int]$Script:Damageoutput = $MonsterAAT / 12}
                        $Script:MonsterAHP = $MonsterAHP - $DamageOutput
                        
                        If ($MonsterAHP -le 0) {
                        $MonsterADMG.Text = "$DamageOutput"
                        Start-Sleep -Milliseconds 800
                        $MonsterADMG.Text = ""
                        $MonsterA.visible = $false
                        $Script:MonsterADead = $true
                        FloorCompleteRoutine
                        }
                        If ($CritChance -eq 9) {$Script:ThiefAttack = $ThiefAttack / 2} 
                        If ($MonsterAHP -gt 0){$MonsterADMG.Text = "$DamageOutput"}
                             
                        [int]$Script:PTSStolen = $Floor / 3 + $MonsterAAT / 10
                        $Script:Points = $points + $PTSStolen
                        $ThiefHPGauge.Text = "$PTSStolen PTS"
                        Start-Sleep -milliSeconds 1200
                        $PointsGauge.Text = "PTS: $points"
                        $thiefHPGauge.Text = "$ThiefHP / $thiefMaxHP"
    }

                        

                        

Write-Host $MonsterAHP -for red
                        

$MonsterADMG.Text = ""

}

Function ThiefTaunt {
$gameweapon.image = $PowerUpImg

Write-Host "BF ATT: F: $fighter1Attack C:$CecilAttack T:$thiefAttack"
$thief.location = "430,300"
$thief.image = $thiefmagicimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefhitimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefswingimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefwinimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefmagicimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefwinimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefhitimg
Start-Sleep -Milliseconds 500
$thief.image = $thiefswingimg
Start-Sleep -Milliseconds 500



$gameweapon.location = "260,120"
$gameweapon.visible = $true
Start-Sleep -Milliseconds 800
$gameweapon.location = "430,250"
Start-Sleep -Milliseconds 800
$gameweapon.visible = $false
[int]$Script:thiefAttack = $thiefAttack * 1.42
[int]$Script:MonsterAAT = $MonsterAAT * 1.2

RestoreThief

}

Function MonsterDamageCalc {

$SCript:TargetPlayer = $currentPartyMembers | Get-Random
#get 1/2/3
Write-host "FT: $TargetPlayer" -ForegroundColor Green
#if p1 selected but p1 


if (($TargetPlayer -eq 1) -or ($TargetPlayer -eq 2) -and ($Fighter1dead -eq $true) -and ($cecildead -eq $true)) {$SCript:TargetPlayer  = 3}
if (($TargetPlayer -eq 2) -or ($TargetPlayer -eq 3) -and ($cecildead -eq $true) -and ($thiefdead -eq $true)) {$SCript:TargetPlayer  = 1}
if (($TargetPlayer -eq 3) -or ($TargetPlayer -eq 1) -and ($thiefdead -eq $true) -and ($Fighter1dead -eq $true)) {$SCript:TargetPlayer  = 2}
Write-host "FT: $TargetPlayer" -ForegroundColor Green
while (($TargetPlayer -eq 1)-and ($Fighter1Dead -eq $true)) {$SCript:TargetPlayer = $currentPartyMembers| Get-Random} 
while (($TargetPlayer -eq 2)-and ($CecilDead -eq $true)) {$SCript:TargetPlayer = $currentPartyMembers |Get-Random} 
while (($TargetPlayer -eq 3)-and ($ThiefDead -eq $true)) {$SCript:TargetPlayer = $currentPartyMembers |Get-Random} 
Write-host "FT: $TargetPlayer" -ForegroundColor Green
If ($TargetPlayer -eq 1) {
                         If ($Fighter1Dead -eq $false) {

                            $Script:Fighter1HP = $Fighter1HP - $MonsteraAT
                            $fighter1.image = $fighter1HitIMG
                            $fighter1.location = "540,100"
                            Start-Sleep -Milliseconds 600
                            $fighter1.location = "520,100"
                            $fighter1.image = $fighter1IMG
                            If ($Fighter1HP -le 0) {
                                $Script:Fighter1HP = 0
                                $Fighter1HPGauge.text = "Dead"
                                $fighter1.size = "48,32"
                                $Fighter1.Image = $Fighter1deadimg
                                $fighter1.location = "490,120"
                            
                                $Script:fighter1dead = $true
                                $fighter1ActList.Enabled = $false
                                $Fighter1HPPanel.Enabled = $false
                                $Fighter1AttackPanel.Enabled = $false
                                $Fighter1HPPanelX.Enabled = $false
                                $Fighter1AttackPanelX.Enabled = $false

                                }
                            }
    If ($fighter1Dead -eq $false) {$fighter1HpGauge.Text = "$Fighter1HP / $fighter1MaxHP"}

    Start-Sleep -Seconds 1
    }




If ($TargetPlayer -eq 2) {
                         If ($CecilDead -eq $false) {
                            $Script:CecilHP = $CecilHP - $MonsteraAT
                            $Cecil.image = $CecilHitIMG
                            $Cecil.location = "550,200"
                            Start-Sleep -Milliseconds 600
                            $Cecil.location = "530,200"
                            $Cecil.image = $CecilIMG
                            If ($CecilHP -le 0) {
                                
                                $Script:CecilDead = $true
                                $Script:CecilHP = 0
                                $CecilHPGauge.text = "Dead"
                                $Cecil.size = "48,32"
                                $Cecil.Image = $Cecildeadimg
                                $Cecil.location = "490,218"
                                
                                
                                $CecilActlist.Enabled = $false
                                $CecilHPPanel.Enabled = $false
                                $CecilAttackPanel.Enabled = $false
                                $CecilHPPanelX.Enabled = $false
                                $CecilAttackPanelX.Enabled = $false
                                
                                }
                            }
    
    If ($cecilDead -eq $false) {$CecilHpGauge.Text = "$CecilHP / $CecilMaxHP"}

    Start-Sleep -Seconds 1
    
    }



If ($TargetPlayer -eq 3) {
                         If ($ThiefDead -eq $false) {
                       
                            $Script:ThiefHP = $ThiefHP - $MonsteraAT
                            $Thief.image = $ThiefHitIMG
                            $Thief.location = "540,300"
                            Start-Sleep -Milliseconds 600
                            $Thief.location = "520,300"
                            $Thief.image = $ThiefIMG
                            If ($ThiefHP -le 0) {
                      
                                $Script:ThiefHP = 0
                                $ThiefHPGauge.text = "Dead"
                                $Thief.size = "48,32"
                                $Thief.Image = $Thiefdeadimg
                                $Thief.location = "490,318"
                                $Script:ThiefDead = $true
                                $ThiefActlist.Enabled = $false
                                $ThiefHPPanel.Enabled = $false
                                $ThiefAttackPanel.Enabled = $false
                                $ThiefHPPanelX.Enabled = $false
                                $ThiefAttackPanelX.Enabled = $false
                                }
                            }

    If ($ThiefDead -eq $false) {$ThiefHpGauge.Text = "$ThiefHP / $thiefMaxHP"}

    Start-Sleep -Seconds 1
    
    }

    Write-Host "Dead - F: $fighter1Dead C:$CecilDead T:$thiefDead" -ForegroundColor red
If (($fighter1Dead -eq $true)-and($CecilDead -eq $true)-and($thiefDead -eq $true)) {
    $combatButton.Enabled = $false
        if ($Floor -eq 20) {$mediaPlayer.open("$path\data\RIP2.mp3")}

    if ($Floor -eq 10) {$mediaPlayer.open("$path\data\RIP2.mp3")}
    if ($floor -ne 10) {$mediaPlayer.open("$path\data\RIP.mp3")}
    

    
    $mediaPlayer.Play()   
    }

}



Function BossDamageCalc {


If ($Fighter1Dead -eq $false) {

    $Script:Fighter1HP = $Fighter1HP - $MonsteraAT
    $fighter1.image = $fighter1HitIMG
    $fighter1.location = "540,100"
    $gameWeapon.size = "75,78"
    $gameWeapon.image = $W_dragonimg
    $gameweapon.location = "445,70"
    $Gameweapon.visible = $true

    Start-Sleep -Milliseconds 600
    $fighter1.location = "520,100"
    $fighter1.image = $fighter1IMG
    If ($Fighter1HP -le 0) {
        $Script:Fighter1HP = 0
        $Fighter1HPGauge.text = "Dead"
        $fighter1.size = "48,32"
        $Fighter1.Image = $Fighter1deadimg
        $fighter1.location = "490,120"
                            
        $SCript:fighter1dead = $true
        $fighter1ActList.Enabled = $false
        $Fighter1HPPanel.Enabled = $false
        $Fighter1AttackPanel.Enabled = $false
        $Fighter1HPPanelX.Enabled = $false
        $Fighter1AttackPanelX.Enabled = $false

        }
    }


    If ($fighter1Dead -eq $false) {$fighter1HpGauge.Text = "$Fighter1HP / $fighter1MaxHP"}
Start-Sleep -Seconds 1
    

                         If ($CecilDead -eq $false) {
                            $Script:CecilHP = $CecilHP - $MonsteraAT
                            $Cecil.image = $CecilHitIMG
                            $Cecil.location = "550,200"

                            $gameWeapon.size = "75,78"
                            $gameWeapon.image = $W_dragonimg
                            $gameweapon.location = "455,170"
                            $Gameweapon.visible = $true
                            Start-Sleep -Milliseconds 600
                            $Cecil.location = "530,200"
                            $Cecil.image = $CecilIMG
                            If ($CecilHP -le 0) {
                                $Script:CecilHP = 0
                                $CecilHPGauge.text = "Dead"
                                $Cecil.size = "48,32"
                                $Cecil.Image = $Cecildeadimg
                                $Cecil.location = "490,218"
                                $Script:CecilDead = $true
                                $CecilActlist.Enabled = $false
                                $CecilHPPanel.Enabled = $false
                                $CecilAttackPanel.Enabled = $false
                                $CecilHPPanelX.Enabled = $false
                                $CecilAttackPanelX.Enabled = $false
                                }
                            }

    If ($CecilDead -eq $false) {$CecilHpGauge.Text = "$CecilHP / $CecilMaxHP"}
    Start-Sleep -Seconds 1
    
    


If ($ThiefDead -eq $false) {
                       
   $Script:ThiefHP = $ThiefHP - $MonsteraAT
   $Thief.image = $ThiefHitIMG
                            $Thief.location = "540,300"
                            $gameWeapon.size = "75,78"
                            $gameWeapon.image = $W_dragonimg
                            $gameweapon.location = "445,270"
                            $Gameweapon.visible = $true
                            Start-Sleep -Milliseconds 600
                            $Thief.location = "520,300"
                            $Thief.image = $ThiefIMG
                            If ($ThiefHP -le 0) {
                      
                                $Script:ThiefHP = 0
                                $ThiefHPGauge.text = "Dead"
                                $Thief.size = "48,32"
                                $Thief.Image = $Thiefdeadimg
                                $Thief.location = "490,318"
                                $Script:ThiefDead = $true
                                $ThiefActlist.Enabled = $false
                                $ThiefHPPanel.Enabled = $false
                                $ThiefAttackPanel.Enabled = $false
                                $ThiefHPPanelX.Enabled = $false
                                $ThiefAttackPanelX.Enabled = $false
                                }
                            }

    If ($thiefDead -eq $false) {$thiefHpGauge.Text = "$thiefHP / $thiefMaxHP"}
    Start-Sleep -Seconds 1

$gameWeapon.visible = $false




If (($fighter1Dead -eq $true)-and($CecilDead -eq $true)-and($thiefDead -eq $true)) {
        $combatButton.Enabled = $false
    if ($Floor -eq 20) {$mediaPlayer.open("$path\data\RIP2.mp3")}

    if ($Floor -ne 20) {$mediaPlayer.open("$path\data\RIP.mp3")}
    $mediaPlayer.Play()   
    }

}

Function LoadData {
    
    #all Graphic Data MUST BE LOADED VIA THIS FUNCTION
    #img res = 32*48, 128*96

    $Fighter1img = (get-item "$Path/data/fighter.png")
    $Fighter1img = [System.Drawing.Image]::Fromfile($Fighter1img)
    $Fighter1deadimg = (get-item "$Path/data/Fighterdead.png")
    $Fighter1deadimg = [System.Drawing.Image]::Fromfile($Fighter1deadimg)
    $Fighter1Winimg = (get-item "$Path/data/fighterwin.png")
    $Fighter1Winimg = [System.Drawing.Image]::Fromfile($Fighter1Winimg)
    $Fighter1readyimg = (get-item "$Path/data/fighterready.png")
    $Fighter1readyimg = [System.Drawing.Image]::Fromfile($Fighter1readyimg)
    $Fighter1Magicimg = (get-item "$Path/data/fighterMagic.png")
    $Fighter1Magicimg = [System.Drawing.Image]::Fromfile($Fighter1Magicimg)
    $Fighter1Guardimg = (get-item "$Path/data/fighterGuard.png")
    $Fighter1Guardimg = [System.Drawing.Image]::Fromfile($Fighter1guardimg)
    $Fighter1HITimg = (get-item "$Path/data/fighterHit.png")
    $Fighter1HITimg = [System.Drawing.Image]::Fromfile($Fighter1HITimg)

    $fighter1Swingimg = (get-item "$Path/data/fighterSwing.png")
    $fighter1Swingimg = [System.Drawing.Image]::Fromfile($fighter1Swingimg)

    $Fighter1 = new-object Windows.Forms.PictureBox
    $Fighter1.Image = $Fighter1img
    $Fighter1.Size = "32,48" #3248
    $Fighter1.Location = "520,100"

    $W_Excaliburimg = (get-item "$Path/data/FighterSword.png")
    $W_Excaliburimg = [System.Drawing.Image]::Fromfile($W_Excaliburimg)

    $W_Crystalimg = (get-item "$Path/data/CecilSword.png")
    $W_Crystalimg = [System.Drawing.Image]::Fromfile($W_Crystalimg)

    $W_Rapierimg = (get-item "$Path/data/ThiefSword.png")
    $W_Rapierimg = [System.Drawing.Image]::Fromfile($W_Rapierimg)

    $W_Dragonimg = (get-item "$Path/data/W_Dragon.png")
    $W_Dragonimg = [System.Drawing.Image]::Fromfile($W_Dragonimg)

    $S_Fire = (get-item "$Path/data/S_fire.png")
    $S_Fire = [System.Drawing.Image]::Fromfile($S_Fire)
    $S_ICE = (get-item "$Path/data/S_ICE.png")
    $S_ICE = [System.Drawing.Image]::Fromfile($S_ICE)
    $S_BOLT = (get-item "$Path/data/S_Bolt.png")
    $S_BOLT = [System.Drawing.Image]::Fromfile($S_BOLT)
    $S_Drain = (get-item "$Path/data/S_Drain.png")
    $S_Drain = [System.Drawing.Image]::Fromfile($S_Drain)

    $GameWeapon = new-object Windows.Forms.PictureBox
    $GameWeapon.Image = $W_Excaliburimg
    $GameWeapon.Size = "28,30" 
    $GameWeapon.Location = "470,99"
    $Gameweapon.Visible = $false

    $monsterAimg = (get-item "$Path/data/monsterA.png")
    $monsterAimg = [System.Drawing.Image]::Fromfile($monsterAimg)


    $shieldimg = (get-item "$Path/data/shield.png")
    $shieldimg = [System.Drawing.Image]::Fromfile($shieldimg)


    $Powerupimg = (get-item "$Path/data/PowerUP.png")
    $Powerupimg = [System.Drawing.Image]::Fromfile($Powerupimg)

    $monstera = new-object Windows.Forms.PictureBox
    $monstera.Image = $monsterAimg
    $monstera.Size = "128,96"
    $monstera.Location = "170,160"

    $Cecilimg = (get-item "$Path/data/cecil.png")
    $Cecilimg = [System.Drawing.Image]::Fromfile($Cecilimg)



    $Cecildeadimg = (get-item "$Path/data/cecildead.png")
    $Cecildeadimg = [System.Drawing.Image]::Fromfile($Cecildeadimg)

    $Cecilwinimg = (get-item "$Path/data/Cecilwin.png")
    $Cecilwinimg = [System.Drawing.Image]::Fromfile($Cecilwinimg)

    $cecilreadyimg = (get-item "$Path/data/cecilready.png")
    $cecilreadyimg = [System.Drawing.Image]::Fromfile($cecilreadyimg)

    $cecilMagicimg = (get-item "$Path/data/cecilMagic.png")
    $cecilMagicimg = [System.Drawing.Image]::Fromfile($cecilMagicimg)

    $cecilGuardimg = (get-item "$Path/data/cecilGuard.png")
    $cecilGuardimg = [System.Drawing.Image]::Fromfile($cecilguardimg)

    $cecilHITimg = (get-item "$Path/data/cecilHit.png")
    $cecilHITimg = [System.Drawing.Image]::Fromfile($cecilHITimg)

    $cecilSwingimg = (get-item "$Path/data/cecilSwing.png")
    $cecilSwingimg = [System.Drawing.Image]::Fromfile($cecilSwingimg)

    $Cecil = New-Object System.Windows.Forms.PictureBox
    $Cecil.Image = $Cecilimg
    $Cecil.Size = "32,48"
    $Cecil.location = "540,200"

    ##############################
    $thiefimg = (get-item "$Path/data/thief.png")
    $thiefimg = [System.Drawing.Image]::Fromfile($thiefimg)



    $thiefdeadimg = (get-item "$Path/data/thiefdead.png")
    $thiefdeadimg = [System.Drawing.Image]::Fromfile($thiefdeadimg)

    $Thiefwinimg = (get-item "$Path/data/Thiefwin.png")
    $Thiefwinimg = [System.Drawing.Image]::Fromfile($Thiefwinimg)

    $Thiefreadyimg = (get-item "$Path/data/thiefready.png")
    $Thiefreadyimg = [System.Drawing.Image]::Fromfile($Thiefreadyimg)

    $ThiefMagicimg = (get-item "$Path/data/thiefMagic.png")
    $ThiefMagicimg = [System.Drawing.Image]::Fromfile($ThiefMagicimg)

    $ThiefGuardimg = (get-item "$Path/data/ThiefGuard.png")
    $ThiefGuardimg = [System.Drawing.Image]::Fromfile($ThiefGuardimg)

    $ThiefHITimg = (get-item "$Path/data/ThiefHit.png")
    $ThiefHITimg = [System.Drawing.Image]::Fromfile($ThiefHITimg)

    $ThiefSwingimg = (get-item "$Path/data/ThiefSwing.png")
    $ThiefSwingimg = [System.Drawing.Image]::Fromfile($ThiefSwingimg)

    $Thief = New-Object System.Windows.Forms.PictureBox
    $Thief.Image = $Thiefimg
    $Thief.Size = "32,48"
    $Thief.location = "520,300"
    $Thief.Visible = $false

  

    $background1img = (get-item "$Path/data/background1.png")
    $background1img = [System.Drawing.Image]::Fromfile($background1img)

    $background2img = (get-item "$Path/data/background2.png")
    $background2img = [System.Drawing.Image]::Fromfile($background2img)

    $background3img = (get-item "$Path/data/background3.png")
    $background3img = [System.Drawing.Image]::Fromfile($background3img)

    $background = New-Object System.Windows.Forms.PictureBox
    $background.Image = $background1img
    $background.Size = "800,60"
    $background.location = "0,0"

MAIN
}

Function RestoreFighter1 {

$fighter1.location = "520,100"
$fighter1.image = $fighter1img

}

Function RestoreCecil{

$cecil.location = "530,200"
$cecil.image = $cecilimg

}

Function RestoreThief{

$thief.location = "520,300"
$thief.image = $thiefimg

}


Function FloorCompleteRoutine {

If ($Fighter1Dead -eq $false) {
$Fighter1.image = $Fighter1Winimg
Start-Sleep -Milliseconds 400
$Fighter1.image = $Fighter1img
Start-Sleep -Milliseconds 400
}
If ($CecilDead -eq $false) {
$Cecil.image = $CecilWinimg
Start-Sleep -Milliseconds 400
$Cecil.image = $Cecilimg
Start-Sleep -Milliseconds 400
}
If ($thiefDead -eq $false) {
$thief.image = $thiefWinimg
Start-Sleep -Milliseconds 400
$thief.image = $thiefimg
Start-Sleep -Milliseconds 400
}

$Script:Floor++
$Win.Text = "Final Fantasy Tower: Floor $floor"
MusicShift
$SCript:BossFight = $False
$Script:MonsterADead = $false
$MonsterA.Visible = $true
[int]$Script:Points = $points + $floor / 1.2
$pointsGauge.Text = "PTS: $points"
LoadNextFloor
}


Function MusicShift {
Write-host $bruh -ForegroundColor Red
If ($floor -eq 4) {
                   $mediaPlayer.open("$path\data\ff3bat.mp3")
                   $mediaPlayer.Play() }
If ($floor -eq 6) {
                   $mediaPlayer.open("$path\data\ff2bat.mp3")
                   $mediaPlayer.Play() }

If ($floor -eq 10) {
                   $mediaPlayer.open("$path\data\ffmqboss.mp3")
                   $mediaPlayer.Play() }

If ($floor -eq 11) {
                   $mediaPlayer.open("$path\data\ff5bat.mp3")
                   $mediaPlayer.Play() }

If ($floor -eq 14) {
                   $mediaPlayer.open("$path\data\jenova.mp3")
                   $mediaPlayer.Play() }
If ($floor -eq 20) {
                   $mediaPlayer.open("$path\data\ffvexdeath.mp3")
                   $mediaPlayer.Play() }

}



function LoadNextFloor {


If ($Floor -eq 2) {
$monsterA2img = (get-item "$Path/data/monsterA2.png")
$monsterA2img = [System.Drawing.Image]::Fromfile($monsterA2img)

$SCript:MonsterAHP = 80
$SCript:MonsterAAT = 10

$MonsterA.Size = "112,76"
$MonsterA.Image = $MonsterA2IMg
    }


If ($Floor -eq 3) {

    $monsterA3img = (get-item "$Path/data/monsterA3.png")
    $monsterA3img = [System.Drawing.Image]::Fromfile($monsterA3img)

$SCript:MonsterAHP = 110
$SCript:MonsterAAT = 12

$MonsterA.Size = "96,128"
$MonsterA.Image = $MonsterA3IMg

    }

If ($Floor -eq 4) {
    $monsterA4img = (get-item "$Path/data/monsterA4.png")
    $monsterA4img = [System.Drawing.Image]::Fromfile($monsterA4img)

$SCript:MonsterAHP = 120
$SCript:MonsterAAT = 14

$MonsterA.Size = "130,128"
$MonsterA.Image = $MonsterA4IMg

    }

If ($Floor -eq 5) {
    $monsterA5img = (get-item "$Path/data/monsterA5.png")
    $monsterA5img = [System.Drawing.Image]::Fromfile($monsterA5img)

$SCript:MonsterAHP = 140
$SCript:MonsterAAT = 17

$MonsterA.Size = "176,128"
$MonsterA.Image = $MonsterA5IMg

    }

If ($Floor -eq 6) {
    $monsterA6img = (get-item "$Path/data/monsterA6.png")
    $monsterA6img = [System.Drawing.Image]::Fromfile($monsterA6img)

$SCript:MonsterAHP = 190
$SCript:MonsterAAT = 19

$MonsterA.Size = "128,160"
$MonsterA.Image = $MonsterA6IMg

    }

If ($Floor -eq 7) {
    $monsterA7img = (get-item "$Path/data/monsterA7.png")
    $monsterA7img = [System.Drawing.Image]::Fromfile($monsterA7img)

$SCript:MonsterAHP = 220
$SCript:MonsterAAT = 21

$MonsterA.Size = "184,160"
$MonsterA.Image = $MonsterA7IMg

    }

If ($Floor -eq 8) {


    $monsterA8img = (get-item "$Path/data/monsterA8.png")
    $monsterA8img = [System.Drawing.Image]::Fromfile($monsterA8img)

$SCript:MonsterAHP = 250
$SCript:MonsterAAT = 23

$MonsterA.Size = "172,120"
$MonsterA.Image = $MonsterA8IMg
ThiefJoins
    }

If ($Floor -eq 9) {
    $monsterA9img = (get-item "$Path/data/monsterA9.png")
    $monsterA9img = [System.Drawing.Image]::Fromfile($monsterA9img)

$SCript:MonsterAHP = 250
$SCript:MonsterAAT = 25

$MonsterA.Size = "128,94"
$MonsterA.Image = $MonsterA9IMg
        

    }

If ($Floor -eq 10) {
    $monsterA10img = (get-item "$Path/data/monstera10.png")
    $monsterA10img = [System.Drawing.Image]::Fromfile($monsterA10img)

$SCript:MonsterAHP = 300
$SCript:MonsterAAT = 30

$MonsterA.Size = "128,192"
$MonsterA.Image = $MonsterA10IMg

    }

If ($Floor -eq 11) {
    
    HealTheParty

    $background.Image = $Background2img
    $monsterA11img = (get-item "$Path/data/monstera11.png")
    $monsterA11img = [System.Drawing.Image]::Fromfile($monsterA11img)

$SCript:MonsterAHP = 230
$SCript:MonsterAAT = 24

$MonsterA.Size = "128,122"
$MonsterA.Image = $MonsterA11IMg

    }


If ($Floor -eq 12) {
    $background.Image = $Background2img
    $monsterA12img = (get-item "$Path/data/monstera12.png")
    $monsterA12img = [System.Drawing.Image]::Fromfile($monsterA12img)

$SCript:MonsterAHP = 260
$SCript:MonsterAAT = 25

$MonsterA.Size = "124,126"
$MonsterA.Image = $MonsterA12IMg
SaveGameData

    }

If ($Floor -eq 13) {
    
    

    $background.Image = $Background2img
    $monsterA13img = (get-item "$Path/data/monstera13.png")
    $monsterA13img = [System.Drawing.Image]::Fromfile($monsterA13img)

$SCript:MonsterAHP = 300
$SCript:MonsterAAT = 28

$MonsterA.Size = "130,134"
$MonsterA.Image = $MonsterA13IMg

    }


If ($Floor -eq 14) {
    $background.Image = $Background2img
    $monsterA14img = (get-item "$Path/data/monstera14.png")
    $monsterA14img = [System.Drawing.Image]::Fromfile($monsterA14img)

$SCript:MonsterAHP = 310
$SCript:MonsterAAT = 30

$MonsterA.Size = "126,128"
$MonsterA.Image = $MonsterA14IMg
SaveGameData

    }

If ($Floor -eq 15) {
    $monsterA15img = (get-item "$Path/data/monstera15.png")
    $monsterA15img = [System.Drawing.Image]::Fromfile($monsterA15img)

$SCript:MonsterAHP = 350
$SCript:MonsterAAT = 32

$MonsterA.Size = "128,96"
$MonsterA.Image = $MonsterA15IMg

    }

If ($Floor -eq 16) {
    
    

    $background.Image = $Background2img
    $monsterA16img = (get-item "$Path/data/monstera16.png")
    $monsterA16img = [System.Drawing.Image]::Fromfile($monsterA16img)

$SCript:MonsterAHP = 380
$SCript:MonsterAAT = 33

$MonsterA.Size = "92,112"
$MonsterA.Image = $MonsterA16IMg

    }


If ($Floor -eq 17) {
    $background.Image = $Background2img
    $monsterA17img = (get-item "$Path/data/monstera17.png")
    $monsterA17img = [System.Drawing.Image]::Fromfile($monsterA17img)

$SCript:MonsterAHP = 400
$SCript:MonsterAAT = 35

$MonsterA.Size = "90,96"
$MonsterA.Image = $MonsterA17IMg
SaveGameData

    }

If ($Floor -eq 18) {
    
    

    $background.Image = $Background2img
    $monsterA18img = (get-item "$Path/data/monstera18.png")
    $monsterA18img = [System.Drawing.Image]::Fromfile($monsterA18img)

$SCript:MonsterAHP = 420
$SCript:MonsterAAT = 37

$MonsterA.Size = "98,126"
$MonsterA.Image = $MonsterA18IMg

    }


If ($Floor -eq 19) {
    $background.Image = $Background2img
    $monsterA19img = (get-item "$Path/data/monstera19.png")
    $monsterA19img = [System.Drawing.Image]::Fromfile($monsterA19img)

$SCript:MonsterAHP = 450
$SCript:MonsterAAT = 41

$MonsterA.Size = "94,92"
$MonsterA.Image = $MonsterA19IMg


    }

If ($Floor -eq 20) {
    $background.Image = $Background2img
    $monsterA20img = (get-item "$Path/data/monstera20.png")
    $monsterA20img = [System.Drawing.Image]::Fromfile($monsterA20img)

$SCript:MonsterAHP = 600
$SCript:MonsterAAT = 52

$MonsterA.Size = "214,248"
$MonsterA.Image = $MonsterA20IMg
    
    $SCript:BossFight = $true

    }

If ($Floor -eq 21) {
    $background.Image = $Background3img
    $monsterA21img = (get-item "$Path/data/monstera21.png")
    $monsterA21img = [System.Drawing.Image]::Fromfile($monsterA21img)

$SCript:MonsterAHP = 600
$SCript:MonsterAAT = 52

$MonsterA.Size = "214,248"
$MonsterA.Image = $MonsterA21IMg
    
    $SCript:BossFight = $false

    }


$MonsterA.Visible = $true
$Script:MonsterAdead = $false
}

Function ThiefJoins {
$Win.Controls.Add($ThiefHpGauge)
$Win.Controls.Add($ThiefActList)
$win.Controls.Add($ThiefAttackPanel)
$win.Controls.Add($ThiefHPPanel)
$win.Controls.Add($ThiefAttackPanelX)
$win.Controls.Add($ThiefHPPanelX)
$SCript:ThiefDead = $false
$thief.Visible = $true
$Script:currentPartyMembers += 3
}

function SaveGameData {
$savebutton.BackColor = "darkgreen"
$savebutton.text = "SAVED!"
$playtime.Stop()
$MinSpent = $playtime.Elapsed.Minutes
###########################################
$filedata = ("Highest Floor: $Floor
In-Game Minutes: $minspent
Points: $Points
FirionMaxHP: $Fighter1MaxHP
FirionHP: $fighter1HP
FirionAT: $Fighter1Attack
CecilMaxHP: $cecilMaxHP
CecilHP: $CecilHP
CecilAT: $CecilAttack
ThiefMaxHP: $ThiefMaxHP
ThiefHP: $thiefHP
ThiefAT: $ThiefAttack")
############################################
Remove-Item -Path "$path\data\SaveData.FF" -ErrorAction SilentlyContinue
New-Item -Name "SaveData.FF" -Value $filedata -Path "$path\data"
Start-Sleep -Seconds 1
$playtime.Start()
$savebutton.BackColor = "blue"
$savebutton.text = "Save Record"
}


Function LoadGameData {
$SaveExist = Test-Path "$path\data\SaveData.FF"
If ($SaveExist -eq $False) {
    $Loadbutton.BackColor = "DarkRed"
    $Loadbutton.text = "NO DATA!"
    Start-Sleep -Seconds 1
    $Loadbutton.BackColor = "darkblue"
    $Loadbutton.text = "Load Record"
}

If ($SaveExist -eq $true) {
    $SaveFile = Get-Item "$path\data\Savedata.ff" 
    $FloorRow = Get-Content -Path $SaveFile | Select -First 1
    $TimeRow = Get-Content -Path $SaveFile | select -Skip 1 | Select -First 1
    $PointsRow = Get-Content -Path $SaveFile | Select -Skip 2 | Select -First 1
    
    $Fighter1MaxHPRow = Get-Content -Path $SaveFile | select -Skip 3 | Select -First 1
    $Fighter1HPRow = Get-Content -Path $SaveFile | select -Skip 4 | Select -First 1
    $Fighter1AttackRow = Get-Content -Path $SaveFile | Select -Skip 5 | Select -First 1

    $CecilMaxHPRow = Get-Content -Path $SaveFile | select -Skip 6 | Select -First 1
    $CecilHPRow = Get-Content -Path $SaveFile | Select -Skip 7 | Select -First 1
    $CecilAttackrow = Get-Content -Path $SaveFile | Select -Skip 8| Select -First 1 
     
    $ThiefMaxHPRow = Get-Content -Path $SaveFile | select -Skip 9 | Select -First 1     
    $ThiefHProw = Get-Content -Path $SaveFile | Select -Skip 10 | Select -First 1
    $ThiefAttackrow = Get-Content -Path $SaveFile | Select -Skip 11| Select -First 1    
      

    [int]$Script:Floor = $FloorRow -replace "Highest Floor: *",""
    [int]$Script:Points = $PointsRow -replace "Points: *",""

    [int]$Script:Fighter1MaxHP = $Fighter1MaxHPRow -replace "FirionMaxHP: *",""
    [int]$Script:Fighter1HP = $Fighter1HPRow -replace "FirionHP: *",""
    [int]$Script:Fighter1Attack = $Fighter1AttackRow -replace "FirionAT: *",""

    [int]$Script:CecilMaxHP = $CecilMaxHPRow -replace "CecilMaxHP: *",""
    [int]$Script:CecilHP = $CecilHPRow -replace "CecilHP: *",""
    [int]$Script:CecilAttack = $CecilAttackrow -replace "CecilAT: *",""

    [int]$Script:ThiefMaxHP = $ThiefMAxHProw -replace "ThiefMaxHP: *",""
    [int]$Script:ThiefHP = $ThiefHProw -replace "ThiefHP: *",""
    [int]$Script:ThiefAttaclk= $ThiefAttackrow -replace "ThiefAT: *",""

    Write-Host $Points -ForegroundColor Yellow
    Write-Host $Floor -ForegroundColor Yellow
    Write-Host $Fighter1HP -ForegroundColor Blue
    Write-Host $Fighter1Attack -ForegroundColor Blue
    Write-Host $CecilHP -ForegroundColor Red
    Write-Host $CecilAttack -ForegroundColor Red
    Write-Host $ThiefHP -ForegroundColor green
    Write-Host $ThiefAttack -ForegroundColor green

    Start-Sleep -Seconds 1
    $fighter1HPGauge.Text = "$Fighter1Hp / $fighter1MaxHP"
    If ($Fighter1HP -le 0) {
        $Script:Fighter1HP = 0
        $Fighter1HPGauge.text = "Dead"
        $fighter1.size = "48,32"
        $Fighter1.Image = $Fighter1deadimg
        $fighter1.location = "490,120"
        $Script:fighter1dead = $true
        $fighter1ActList.Enabled = $false
        $fighter1Attackpanel.Enabled = $False
        $fighter1AttackpanelX.Enabled = $False
        $fighter1Hppanel.Enabled = $False
        $fighter1HppanelX.Enabled = $False
        }

    $cecilHPGauge.Text = "$CecilHp / $CecilMaxHP"
    If ($CecilHP -le 0) {
        $Script:CecilHP = 0
        $CecilHPGauge.text = "Dead"
        $Cecil.size = "48,32"
        $Cecil.Image = $Cecildeadimg
        $Cecil.location = "490,218"
        $Script:CecilDead = $true
        $CecilActlist.Enabled = $false
        $CecilAttackpanel.Enabled = $False
        $CecilAttackpanelX.Enabled = $False
        $cecilHppanel.Enabled = $False
        $cecilHppanelX.Enabled = $False

    }
    Write-Host "Loaded Floor $floor" -f Cyan
    If ($Floor -ge 8) {
        ThiefJoins
        $ThiefHPGauge.Text = "$ThiefHp / $ThiefMaxHP"
        If ($ThiefHP -le 0) {                

            $Script:ThiefHP = 0
            $ThiefHPGauge.text = "Dead"
            $thief.size = "48,32"
            $thief.Image = $thiefdeadimg
            $thief.location = "490,318"
            $Script:thiefDead = $true
            $thiefActlist.Enabled = $false
            $ThiefAttackpanel.Enabled = $False
            $thiefAttackpanelX.Enabled = $False
            $thiefHppanel.Enabled = $False
            $thiefHppanelX.Enabled = $False
        }
    }
    LoadNextFloor
    $Win.Text = "Final Fantasy Tower: Floor $Floor"
    $Loadbutton.BackColor = "blue"
    $Loadbutton.text = "Load Record"

    If (($fighter1Dead -eq $true)-and($CecilDead -eq $true)-and($thiefDead -eq $true)) {
        $mediaPlayer.open("$path\data\RIP.mp3")
        $mediaPlayer.Play()  
        Start-sleep -seconds 27 

        }
    MusicShift
    $pointsGauge.Text = "PTS: $points"
    $Loadbutton.BackColor = "#8c8527"
    $Loadbutton.text = "LOADED!"
    Start-Sleep -Seconds 1
    $Loadbutton.BackColor = "darkblue"
    $Loadbutton.text = "Load Record"

    Write-Host "Dead - F: $fighter1Dead C:$CecilDead T:$thiefDead" -ForegroundColor Green
    }
}


Function HealTheParty {

Write-Host "HealTheParty Called" -f Yellow
$fighter1.size = "32,48"
$cecil.size = "32,48"
$thief.size = "32,48"
$Script:Fighter1HP = $Fighter1MAXHP
$Fighter1Dead = $false
$Fighter1Actlist.Enabled = $true
$Fighter1HPPanel.Enabled = $true
$Fighter1AttackPanel.Enabled = $true
$Fighter1HPPanelX.Enabled = $true
$Fighter1AttackPanelX.Enabled = $true
$Fighter1HPGauge.text = "$Fighter1HP / $Fighter1MAXHP"
RestoreFighter1


$Script:cecilHP = $CECILMAXHP
$Script:CecilCureCasts = 5
$CecilDead = $false
$CecilActlist.Enabled = $true
$CecilHPPanel.Enabled = $true
$CecilAttackPanel.Enabled = $true
$CecilHPPanelX.Enabled = $true
$CecilAttackPanelX.Enabled = $true
$CecilHPGauge.text = "$CecilHP / $CecilMAXHP"
$cecil.Image = $cecilimg
Restorececil

$Script:ThiefHP = $ThiefMAXHP
$ThiefDead = $false
$ThiefActlist.Enabled = $true
$ThiefHPPanel.Enabled = $true
$ThiefAttackPanel.Enabled = $true
$ThiefHPPanelX.Enabled = $true
$ThiefAttackPanelX.Enabled = $true
$ThiefHPGauge.text = "$ThiefHP / $ThiefMAXHP"
$thief.Image = $thiefimg
Restorethief
}



function Fighter1RaiseAttackStat {

if ($points -lt 3) {

    $Fighter1AttackPanel.BackColor = "GRAY"
    $Fighter1AttackPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $Fighter1AttackPanel.Text = "Attack Up (3PTS)"
    $Fighter1AttackPanel.BackColor = "DarkBlue"
    }

if ($points -ge 3) {
    $script:fighter1Attack = $fighter1Attack + 2
    $Script:points = $points - 3
    $Fighter1AttackPanel.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $Fighter1.Image = $Fighter1winimg
    Start-Sleep -seconds 1
    $Fighter1AttackPanel.BackColor = "DarkBlue"
    $Fighter1.Image = $Fighter1img
    }



}

function Fighter1RaiseAttackStatX {

if ($points -lt 15) {

    $Fighter1AttackPanelX.BackColor = "GRAY"
    $Fighter1AttackPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $Fighter1AttackPanelX.Text = "PWR UP (15PTS)"
    $Fighter1AttackPanelX.BackColor = "DarkBlue"
    }

if ($points -ge 15) {
    $script:fighter1Attack = $fighter1Attack + 10
    $Script:points = $points - 15
    $Fighter1AttackPanelX.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $Fighter1.Image = $Fighter1winimg
    Start-Sleep -seconds 1
    $Fighter1AttackPanelX.BackColor = "DarkBlue"
    $Fighter1.Image = $Fighter1img
    }



}

function Fighter1RaiseHPStat {

if ($points -lt 3) {

    $Fighter1hpPanel.BackColor = "GRAY"
    $Fighter1hpPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $Fighter1hpPanel.Text = "MaxHP Up (3PTS)"
    $Fighter1hpPanel.BackColor = "DarkBlue"
    }

if ($points -ge 3) {
    $script:fighter1hp = $fighter1hp + 6
    $script:fighter1MAXhp = $fighter1MAXhp + 6
    $Script:points = $points - 3
    $PointsGauge.Text = "PTS: $points"
    $Fighter1HPPanel.BackColor = "#8c8527"
    $fighter1HpGauge.text = "$fighter1HP / $fighter1MaxHP"
    $Fighter1.Image = $Fighter1winimg
    Start-Sleep -seconds 1
    $Fighter1HPPanel.BackColor = "DarkBlue"
    $Fighter1.Image = $Fighter1img
    }



}

function Fighter1RaiseHPStatX {

if ($points -lt 15) {

    $Fighter1hpPanelX.BackColor = "GRAY"
    $Fighter1hpPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $Fighter1hpPanelX.Text = "MaxHP Up (15PTS)"
    $Fighter1hpPanelX.BackColor = "DarkBlue"
    }

if ($points -ge 15) {
    $script:fighter1hp = $fighter1hp + 30
    $script:fighter1MAXhp = $fighter1MAXhp + 30
    $Script:points = $points - 15
    $PointsGauge.Text = "PTS: $points"
    $Fighter1HPPanelX.BackColor = "#8c8527"
    $fighter1HpGauge.text = "$fighter1HP / $fighter1MaxHP"
    $Fighter1.Image = $Fighter1winimg
    Start-Sleep -seconds 1
    $Fighter1HPPanelX.BackColor = "DarkBlue"
    $Fighter1.Image = $Fighter1img
    }



}

function CecilRaiseAttackStat {

if ($points -lt 3) {

    $CecilAttackPanel.BackColor = "GRAY"
    $CecilAttackPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $CecilAttackPanel.Text = "Attack Up (3PTS)"
    $CecilAttackPanel.BackColor = "DarkRed"
    }

if ($points -ge 3) {
    $script:CecilAttack = $CecilAttack + 2
    $Script:points = $points - 3
    $CecilAttackPanel.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $Cecil.Image = $Cecilwinimg
    Start-Sleep -seconds 1
    $CecilAttackPanel.BackColor = "DarkRed"
    $Cecil.Image = $Cecilimg
    }



}

function CecilRaiseHPStat {

if ($points -lt 3) {

    $CecilHPPanel.BackColor = "GRAY"
    $CecilHPPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $CecilHPPanel.Text = "MaxHP Up (3PTS)"
    $CecilHPPanel.BackColor = "DarkRed"
    }

if ($points -ge 3) {
    $script:CecilHP = $CecilHP + 6
    $script:CecilMAXhp = $CecilMAXhp + 6
    $Script:points = $points - 3
    $PointsGauge.Text = "PTS: $points"
    $CecilHPPanel.BackColor = "#8c8527"
    $CecilHpGauge.text = "$CecilHP / $CecilMaxHP"
    $Cecil.Image = $Cecilwinimg
    Start-Sleep -seconds 1
    $CecilHPPanel.BackColor = "DarkRed"
    $Cecil.Image = $Cecilimg
    }



}

function CecilRaiseAttackStatX {

if ($points -lt 15) {

    $CecilAttackPanelX.BackColor = "GRAY"
    $CecilAttackPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $CecilAttackPanelX.Text = "PWR UP (15PTS)"
    $CecilAttackPanelX.BackColor = "DarkRed"
    }

if ($points -ge 15) {
    $script:CecilAttack = $CecilAttack + 10
    $Script:points = $points - 15
    $CecilAttackPanelX.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $Cecil.Image = $Cecilwinimg
    Start-Sleep -seconds 1
    $CecilAttackPanelX.BackColor = "DarkRed"
    $Cecil.Image = $Cecilimg
    }



}

function CecilRaiseHPStatX {

if ($points -lt 15) {

    $CecilHPPanelX.BackColor = "GRAY"
    $CecilHPPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $CecilHPPanelX.Text = "MaxHP Up (15PTS)"
    $CecilHPPanelX.BackColor = "DarkRed"
    }

if ($points -ge 15) {
    $script:CecilHP = $CecilHP + 30
    $script:CecilMAXhp = $CecilMAXhp + 30
    $Script:points = $points - 15
    $PointsGauge.Text = "PTS: $points"
    $CecilHPPanelX.BackColor = "#8c8527"
    $CecilHpGauge.text = "$CecilHP / $CecilMaxHP"
    $Cecil.Image = $Cecilwinimg
    Start-Sleep -seconds 1
    $CecilHPPanelX.BackColor = "DarkRed"
    $Cecil.Image = $Cecilimg
    }



}


function ThiefRaiseAttackStat {

if ($points -lt 2) {

    $ThiefAttackPanel.BackColor = "GRAY"
    $ThiefAttackPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $ThiefAttackPanel.Text = "Attack Up (3PTS)"
    $ThiefAttackPanel.BackColor = "DarkGreen"
    }

if ($points -ge 3) {
    $script:ThiefAttack = $ThiefAttack + 2
    $Script:points = $points - 3
    $ThiefAttackPanel.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $thief.Image = $thiefwinimg
    Start-Sleep -seconds 1
    $thiefAttackPanel.BackColor = "DarkGreen"
    $thief.Image = $thiefimg
    }



}

function ThiefRaiseHPStat {

if ($points -lt 3) {

    $thiefHPPanel.BackColor = "GRAY"
    $thiefHPPanel.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $thiefHPPanel.Text = "MaxHP Up (3PTS)"
    $thiefHPPanel.BackColor = "Darkgreen"
    }

if ($points -ge 3) {
    $script:thiefHP = $thiefHP + 6
    $script:thiefMAXhp = $thiefMAXhp + 6
    $Script:points = $points - 3
    $PointsGauge.Text = "PTS: $points"
    $thiefHPPanel.BackColor = "#8c8527"
    $thiefHpGauge.text = "$thiefHP / $thiefMaxHP"
    $thief.Image = $thiefwinimg
    Start-Sleep -seconds 1
    $thiefHPPanel.BackColor = "Darkgreen"
    $thief.Image = $thiefimg
    }



}

function ThiefRaiseAttackStatX {

if ($points -lt 15) {

    $ThiefAttackPanelX.BackColor = "GRAY"
    $ThiefAttackPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $ThiefAttackPanelX.Text = "Attack Up (15PTS)"
    $ThiefAttackPanelX.BackColor = "DarkGreen"
    }

if ($points -ge 15) {
    $script:ThiefAttack = $ThiefAttack + 10
    $Script:points = $points - 15
    $ThiefAttackPanelX.BackColor = "#8c8527"
    $PointsGauge.Text = "PTS: $points"
    $thief.Image = $thiefwinimg
    Start-Sleep -seconds 1
    $thiefAttackPanelX.BackColor = "DarkGreen"
    $thief.Image = $thiefimg
    }



}

function ThiefRaiseHPStatX {

if ($points -lt 15) {

    $thiefHPPanelX.BackColor = "GRAY"
    $thiefHPPanelX.Text = "Can't Afford"
    Start-Sleep -Seconds 1
    $thiefHPPanelX.Text = "MaxHP Up (15PTS)"
    $thiefHPPanelX.BackColor = "Darkgreen"
    }

if ($points -ge 15) {
    $script:thiefHP = $thiefHP + 30
    $script:thiefMAXhp = $thiefMAXhp + 30
    $Script:points = $points - 15
    $PointsGauge.Text = "PTS: $points"
    $thiefHPPanelX.BackColor = "#8c8527"
    $thiefHpGauge.text = "$thiefHP / $thiefMaxHP"
    $thief.Image = $thiefwinimg
    Start-Sleep -seconds 1
    $thiefHPPanelX.BackColor = "Darkgreen"
    $thief.Image = $thiefimg
    }



}

##########################
Write-Host "Push Enter if game has not loaded" -b DarkRed -f White

LoadData