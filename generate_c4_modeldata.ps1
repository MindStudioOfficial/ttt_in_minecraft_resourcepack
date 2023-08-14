# PowerShell script to rename textures and generate Mooshroom Spawn Egg custom model JSON files

# Directory for the textures and JSON model files
$texturesDirectory = "assets\minecraft\textures\item\"
$modelsDirectory = "assets\minecraft\models\item\"

# Check if the directories exist, if not create them
if (-not (Test-Path $texturesDirectory)) {
    New-Item -ItemType Directory -Force -Path $texturesDirectory
}

if (-not (Test-Path $modelsDirectory)) {
    New-Item -ItemType Directory -Force -Path $modelsDirectory
}

# Rename the textures
for ($i = 0; $i -le 30; $i++) {
    $oldName = "MinecraftTTT_C4_sprite_0.$("{0:D2}" -f $i).png"
    $newName = "c4_$("{0:D2}" -f $i).png"

    if (Test-Path "$texturesDirectory\$oldName") {
        Rename-Item -Path "$texturesDirectory\$oldName" -NewName $newName -Force
    }
}

# Generate the default mooshroom_spawn_egg.json with all overrides
$overrides = @()
for ($i = 0; $i -le 30; $i++) {
    $overrides += @"
{
    "predicate": {
        "custom_model_data": $i
    },
    "model": "item/mooshroom_spawn_egg_$i"
}
"@
}

$defaultContent = @"
{
    "parent": "minecraft:item/generated",
    "textures": {
        "layer0": "item/c4_00",
        "layer1": "item/c4_00"
    },
    "overrides": [
        $($overrides -join ',')
    ]
}
"@
$defaultContent | Out-File -Encoding utf8NoBOM -FilePath "$modelsDirectory\mooshroom_spawn_egg.json" -Force

# Generate individual JSON files
for ($i = 0; $i -le 30; $i++) {
    $content = @"
{
    "parent": "item/mooshroom_spawn_egg",
    "textures": {
        "layer0": "item/c4_$("{0:D2}" -f $i)",
        "layer1": "item/c4_$("{0:D2}" -f $i)"
    }
}
"@
    $content | Out-File -Encoding utf8NoBOM -FilePath "$modelsDirectory\mooshroom_spawn_egg_$i.json" -Force
}

Write-Host "All textures renamed and JSON files have been generated!"
