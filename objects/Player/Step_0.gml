/// @description move me bb

var dt = GetDT()

// Movement stuff comes here

var xMove = 0.0
var yMove = 0.0

switch( gravDir )
{
case "U":
	if( keyboard_check( moveDown1 ) || keyboard_check( moveDown2 ) ) jumping = true
	if( keyboard_check( moveLeft1 ) || keyboard_check( moveLeft2 ) ) --xMove
	if( keyboard_check( moveRight1 ) || keyboard_check( moveRight2 ) ) ++xMove
	break
case "D": // normal gravity
	if( keyboard_check( moveUp1 ) || keyboard_check( moveUp2 ) ) jumping = true
	if( keyboard_check( moveLeft1 ) || keyboard_check( moveLeft2 ) ) --xMove
	if( keyboard_check( moveRight1 ) || keyboard_check( moveRight2 ) ) ++xMove
	break
case "L":
	if( keyboard_check( moveRight1 ) || keyboard_check( moveRight2 ) ) jumping = true
	if( keyboard_check( moveUp1 ) || keyboard_check( moveUp2 ) ) --yMove
	if( keyboard_check( moveDown1 ) || keyboard_check( moveDown2 ) ) ++yMove
	break
case "R":
	if( keyboard_check( moveLeft1 ) || keyboard_check( moveLeft2 ) ) jumping = true
	if( keyboard_check( moveDown1 ) || keyboard_check( moveDown2 ) ) ++yMove
	if( keyboard_check( moveUp1 ) || keyboard_check( moveDown2 ) ) --yMove
	break
default: show_debug_message( "You will never get this!" ) break
}

// If not moving you will not look away :)
if( gravDir == "U" || gravDir == "D" )
{
	if( xMove > 0.0 ) image_xscale = 1.0
	else if( xMove < 0.0 ) image_xscale = -1.0
}
else if( gravDir == "L" )
{
	if( yMove > 0.0 ) image_xscale = 1.0
	else if( yMove < 0.0 ) image_xscale = -1.0
}
else if( gravDir == "R" )
{
	if( yMove > 0.0 ) image_xscale = -1.0
	else if( yMove < 0.0 ) image_xscale = 1.0
}

// Use these for all movement, then apply to x and y
xMove = xMove * moveSpeed * dt
yMove = yMove * moveSpeed * dt

if( jumping )
{
	// The first second of your jump.
	if( landed && !audio_is_playing( JumpSound ) )
	{
		PlaySoundText( JumpSound,JumpSoundTextSpr,x,y + 8 )
	}
	
	landed = false
	// if( gravDir == "D" ) yMove += jumpPower * dt
	// else yMove -= jumpPower * dt
	switch( gravDir )
	{
	case "U": yMove += jumpPower * dt; break
	case "D": yMove -= jumpPower * dt; break
	case "L": xMove += jumpPower * dt; break
	case "R": xMove -= jumpPower * dt; break
	}
}

grav += gravAcc * dt
// if( gravDir == "D" ) yMove += grav * dt
// else yMove -= grav * dt
switch( gravDir )
{
case "U": yMove -= grav * dt; break
case "D": yMove += grav * dt; break
case "L": xMove -= grav * dt; break
case "R": xMove += grav * dt; break
}
// if( yMove > maxFallSpeed ) yMove = maxFallSpeed

// These guys tell -1 to 1 which direction you go in
var xDir = ( ( xMove != 0.0 ) ? xMove / abs( xMove ) : 0.0 )
var yDir = ( ( yMove != 0.0 ) ? yMove / abs( yMove ) : 0.0 )

if( tilemap_get_at_pixel( tileLayer,x + ( halfWidth * xDir ) + xMove,y ) <= 0 )
{
	x += xMove
	if( gravDir == "L" || gravDir == "R" ) landed = false
}
else if( gravDir == "L" || gravDir == "R" )
{
	// Smaller means more accurate and also more laggy.
	var minMoveAmount = 0.1 * xDir
	while( tilemap_get_at_pixel( tileLayer,x + ( halfWidth * xDir ) + minMoveAmount,y ) <= 0 ) x += minMoveAmount
	
	grav = 0.0
	jumping = false
	
	if( !audio_is_playing( LandSound ) && !landed )
	{
		PlaySoundText( LandSound,LandSoundTextSpr,x,y + textOffset )
		landed = true
	}
}
else
{
	if( !audio_is_playing( HitWallSound ) ) PlaySoundText( HitWallSound,HitWallSoundTextSpr,x,y - textOffset )
}
if( tilemap_get_at_pixel( tileLayer,x,y + ( halfHeight * yDir ) + yMove ) <= 0 )
{
	y += yMove
	if( gravDir == "D" || gravDir == "U" ) landed = false
}
else if( gravDir == "D" || gravDir == "U" )
{
	// Smaller means more accurate and also more laggy.
	var minMoveAmount = 0.1 * yDir
	while( tilemap_get_at_pixel( tileLayer,x,y + ( halfHeight * yDir ) + minMoveAmount ) <= 0 ) y += minMoveAmount
	
	grav = 0.0
	jumping = false
	
	if( !audio_is_playing( LandSound ) && !landed )
	{
		PlaySoundText( LandSound,LandSoundTextSpr,x,y + textOffset )
		landed = true
	}
}
else
{
	if( !audio_is_playing( HitWallSound ) ) PlaySoundText( HitWallSound,HitWallSoundTextSpr,x,y - textOffset )
}

// Play footstep sounds.

if( landed )
{
	footStepTimer += dt
	switch( gravDir )
	{
	case "U": case "D":
		if( xMove != 0.0 && footStepTimer > footStepDuration )
		{
			footStepTimer = 0.0
			
			if( leftFoot )
			{
				leftFoot = false
				PlaySoundText( ( ( random_range( 0,10 ) > 5 )
					? LeftFoot1Sound : LeftFoot2Sound ),
					LeftFootSoundTextSpr,x - 8,y + 16 )
			}
			else
			{
				leftFoot = true
				PlaySoundText( ( ( random_range( 0,10 ) > 5 )
					? RightFoot1Sound : RightFoot2Sound ),
					RightFootSoundTextSpr,x + 8,y + 16 )
			}
		}
		break
	case "L": case "R":
		if( yMove != 0.0 && footStepTimer > footStepDuration )
		{
			footStepTimer = 0.0
			
			if( leftFoot )
			{
				leftFoot = false
				PlaySoundText( ( ( random_range( 0,10 ) > 5 )
					? LeftFoot1Sound : LeftFoot2Sound ),
					LeftFootSoundTextSpr,x - 8,y + 16 )
			}
			else
			{
				leftFoot = true
				PlaySoundText( ( ( random_range( 0,10 ) > 5 )
					? RightFoot1Sound : RightFoot2Sound ),
					RightFootSoundTextSpr,x + 8,y + 16 )
			}
		}
		break
	}
}

// Attacking stuff here

shotTimer += dt

if( ( keyboard_check( shoot1 ) || keyboard_check( shoot2 ) ) && ( shotTimer >= refireTime ) )
{
	shotTimer = 0.0
	
	var bull = instance_create_layer( x,y,"ProjectilesLayer",Bullet )
	// bull.dir = image_xscale
	// bull.image_xscale = image_xscale
	switch( gravDir )
	{
	case "U": case "D":
		bull.xMove = image_xscale
		bull.image_xscale = image_xscale
		break
	case "L":
		bull.yMove = image_xscale
		bull.image_angle = -90 * image_xscale
		break
	case "R":
		bull.yMove = -image_xscale
		bull.image_angle = 90 * image_xscale
		break
	}
	
	// audio_play_sound( SlashSound,1,false )
	PlaySoundText( SlashSound,SlashSoundTextSpr,x + textOffset * image_xscale,y - textOffset * 1.5 )
}

if( keyboard_check_pressed( ord( "M" ) ) )
{
	audio_master_gain( 0.0 )
	audio_stop_all()
	// Any other music you add put here.
}
else if( keyboard_check_pressed( ord( "N" ) ) )
{
	audio_master_gain( 1.0 )
	audio_play_sound( bgMusic,10,false )
}

if( keyboard_check_pressed( vk_enter ) ) room_goto_next()

// Play error sound and give error message if key that isnt mapped is pressed
if( keyboard_check( vk_anykey ) )
{
	if( !keyboard_check( moveUp1 ) &&
		!keyboard_check( moveUp2 ) &&
		!keyboard_check( moveDown1 ) &&
		!keyboard_check( moveDown2 ) &&
		!keyboard_check( moveLeft1 ) &&
		!keyboard_check( moveLeft2 ) &&
		!keyboard_check( moveRight1 ) &&
		!keyboard_check( moveRight2 ) &&
		!keyboard_check( shoot1 ) &&
		!keyboard_check( shoot2 ) &&
		!keyboard_check( interact1 ) &&
		!keyboard_check( interact2 ) )
	{
		// TODO: Put error sound and message in here
		// PlaySoundText( ... )
	}
}

// Window stuff, I'm not sure where else to put this so here is fine I guess.
if( keyboard_check( vk_control ) && keyboard_check( ord( "F" ) ) )
{
	window_set_fullscreen( true )
}
else if( keyboard_check( vk_escape ) )
{
	window_set_fullscreen( false )
}

// TODO: Make camera move sexily in code :)