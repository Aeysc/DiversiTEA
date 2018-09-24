/// @description move me bb

var dt = GetDT()

// Movement stuff comes here

var xMove = 0.0
var yMove = 0.0

// Input check
// if( keyboard_check( ord( "W" ) ) ) jumping = true
// // if( keyboard_check( ord( "S" ) ) ) ++yMove
// if( keyboard_check( ord( "A" ) ) )
// {
// 	switch( gravDir )
// 	{
// 		case "U": case "D": --xMove; break
// 		case "R": jumping = true; break
// 	}
// }
// if( keyboard_check( ord( "D" ) ) )
// {
// 	switch( gravDir )
// 	{
// 		case "U": case "D": ++xMove; break
// 		case "L": jumping = true; break
// 	}
// }

switch( gravDir )
{
case "U":
	if( keyboard_check( ord( "S" ) ) ) jumping = true
	if( keyboard_check( ord( "A" ) ) ) --xMove
	if( keyboard_check( ord( "D" ) ) ) ++xMove
	break
case "D": // normal gravity
	if( keyboard_check( ord( "W" ) ) ) jumping = true
	if( keyboard_check( ord( "A" ) ) ) --xMove
	if( keyboard_check( ord( "D" ) ) ) ++xMove
	break
case "L":
	if( keyboard_check( ord( "D" ) ) ) jumping = true
	if( keyboard_check( ord( "W" ) ) ) --yMove
	if( keyboard_check( ord( "S" ) ) ) ++yMove
	break
case "R":
	if( keyboard_check( ord( "A" ) ) ) jumping = true
	if( keyboard_check( ord( "S" ) ) ) ++yMove
	if( keyboard_check( ord( "W" ) ) ) --yMove
	break
default: show_debug_message( "You will never get this!" ) break
}

// If not moving you will not look away :)
if( gravDir == "U" || gravDir == "D" )
{
	if( xMove > 0.0 ) image_xscale = 1.0
	else if( xMove < 0.0 ) image_xscale = -1.0
}
else if( gravDir == "L" || gravDir == "R" )
{
	if( yMove > 0.0 ) image_xscale = 1.0
	else if( yMove < 0.0 ) image_xscale = -1.0
}

// Use these for all movement, then apply to x and y
xMove = xMove * moveSpeed * dt
yMove = yMove * moveSpeed * dt

if( jumping )
{
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

if( tilemap_get_at_pixel( tileLayer,x + ( halfWidth * xDir ) + xMove,y ) <= 0 ) x += xMove
else if( gravDir == "L" || gravDir == "R" )
{
	// Smaller means more accurate and also more laggy.
	var minMoveAmount = 0.1 * xDir
	while( tilemap_get_at_pixel( tileLayer,x + ( halfWidth * xDir ) + minMoveAmount,y ) <= 0 ) x += minMoveAmount
	
	grav = 0.0
	jumping = false
}
if( tilemap_get_at_pixel( tileLayer,x,y + ( halfHeight * yDir ) + yMove ) <= 0 ) y += yMove
else if( gravDir == "D" || gravDir == "U" )
{
	// Smaller means more accurate and also more laggy.
	var minMoveAmount = 0.1 * yDir
	while( tilemap_get_at_pixel( tileLayer,x,y + ( halfHeight * yDir ) + minMoveAmount ) <= 0 ) y += minMoveAmount
	
	grav = 0.0
	jumping = false
}

// Attacking stuff here

shotTimer += dt

if( keyboard_check( ord( "J" ) ) && ( shotTimer >= refireTime ) )
{
	shotTimer = 0.0
	
	// TODO: Change bullet dir depending on if you're sideways or whatever orientation you happen to be.
	//  We're inclusive here. ;)
	
	var bull = instance_create_layer( x,y,"ProjectilesLayer",Bullet )
	bull.dir = image_xscale
	bull.image_xscale = image_xscale
	
	audio_play_sound( Ouch1Sound,1,false )
}

// TODO: Make camera move sexily in code :)
