/// @description init vars pls pls

gravAcc = 0.26 // dont change pls, I use this everywhere
moveSpeed = 4.1
grav = 0.0
maxFallSpeed = 2.6
jumping = false
jumpPower = 4.6 // from 4.6
refireTime = 0.178 * 60.0
shotTimer = 0.0
tileLayer = layer_tilemap_get_id( "TileLayer" )
halfWidth = sprite_get_width( sprite_index ) / 2.0
halfHeight = sprite_get_height( sprite_index ) / 2.0
gravDir = "D" // U/up, D/down, L/left, R/right
landed = false
textOffset = 16
footStepTimer = 0.0
footStepDuration = 0.12 * 60.0
leftFoot = false

hp = GetHPBasedOnDifficulty( 9999,3,1 )

sprite_index = global.PLAYER_SPRITE