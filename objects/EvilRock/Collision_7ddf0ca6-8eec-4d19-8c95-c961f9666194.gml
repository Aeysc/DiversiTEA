/// @description destroy self and bullet

var diff = x - other.x
x += ( diff / abs( diff ) ) * knockbackSpeed

PlaySoundText( SplooshSound,OuchSoundTextSpr,x,y - 16 )

instance_destroy( other,false )

--hp
// image_blend = c_red
flashTimer = 0.0
if( hp < 1 )
{
	TryGivingAchievement( AchieveKillEnemy )
	instance_destroy( id,false )
}