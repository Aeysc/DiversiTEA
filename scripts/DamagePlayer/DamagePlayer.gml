/// @param_whereFromX

var player = instance_find( Player,0 )

// room_goto( room )

if( global.GAME_DIFFICULTY != "E" ) --player.hp

if( !audio_is_playing( PlayerOuchSound ) )
{
	PlaySoundText( PlayerOuchSound,OuchSoundTextSpr,player.x,player.y - 8 )
}

var xDiff = argument0 - player.x
if( xDiff != 0 ) player.x -= ( xDiff / abs( xDiff ) ) * 45
else player.y -= 30
player.y -= 10

if( player.hp < 1 )
{
	room_goto( room )
}