//==============================================================================
// MutNoPeace (C) 2011 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class MutNoPeace extends Mutator
	config(MutNoPeace);

var() globalconfig float MinSpawnTimeInterval, MaxSpawnTimeInterval;
var() globalconfig int AmountOfCreeps;
var() globalconfig class<Monster> CreepClass;
var() globalconfig int CreepOffset;
var() globalconfig float UDamageBonusTime;

event MatchStarting()
{
 	StartNextCreep();
}

final function StartNextCreep()
{
	SetTimer( Max( Rand( MaxSpawnTimeInterval ), MinSpawnTimeInterval ), false );
}

event Timer()
{
	local xPawn P;
	local array<xPawn> myNoobs;

	// Abort, until new match starts.
	if( Level.Game.bGameEnded )
	{
		SetTimer( 0.0f, false );
		return;
	}

	foreach DynamicActors( class'xPawn', P )
	{
		if( P.IsA('Monster') || P.Health <= 0 )
		{
			continue;
		}

		myNoobs[myNoobs.Length] = P;
	}

	if( myNoobs.Length > 0 )
	{
		P = myNoobs[Rand( myNoobs.Length - 1 )];
		if( P != none )
		{
			if( OmzeilPlaats( P.Location, GetMonsterClass(), CreepOffset*(AmountOfCreeps/4 + 1) + P.CollisionRadius, AmountOfCreeps ) )
			{
				if( PlayerController(P.Controller) != none )
				{
					PlayerController(P.Controller).ReceiveLocalizedMessage( class'CreepMessage' );
				}

				P.EnableUDamage( UDamageBonusTime );
			}
		}
	}
	StartNextCreep();
}

function class<Monster> GetMonsterClass()
{
	return CreepClass;
}

final function bool OmzeilPlaats( Vector dest, class<Actor> classToSpawn, float force, int amount )
{
	local Vector point;
	local Vector rotVect;
	local int i;
	local float angle;
	local bool bsuccess;

   	point = dest;
	for( i = 0; i < amount; ++ i )
	{
		angle = 180/amount*(i+1) / pi;

		rotVect.X = force * cos( angle );
		rotVect.Y = force * sin( angle );
		if( Spawn( classToSpawn,,, point + rotVect, rotator(rotVect) ) != none )
		{
			bsuccess = true;
		}
	}
	return bsuccess;
}

static function FillPlayInfo( PlayInfo Info )
{
	super.FillPlayInfo( Info );

	Info.AddSetting( default.FriendlyName,
		"CreepClass",
		"Creep class", 0, 1, "Text",,,, true );

	Info.AddSetting( default.FriendlyName,
		"AmountOfCreeps",
		"Amount of Creeps", 0, 1, "Text", "2;1:25",,, true );

	Info.AddSetting( default.FriendlyName,
		"MinSpawnTimeInterval",
		"Minimum Spawn Time Interval", 0, 1, "Text", "3;5:999",,, true );

	Info.AddSetting( default.FriendlyName,
		"MaxSpawnTimeInterval",
		"Maximum Spawn Time Interval", 0, 1, "Text", "3;10:999",,, true );

	Info.AddSetting( default.FriendlyName,
		"CreepOffset",
		"Creep Radius Offset", 0, 1, "Text", "3;40:300",,, true );

	Info.AddSetting( default.FriendlyName,
		"UDamageBonusTime",
		"UDamage Bonus Time", 0, 1, "Text", "3;5:999",,, true );
}

static function string GetDescriptionText( string PropName )
{
	switch( PropName )
	{
		case "CreepClass":
			return "The creeps monster class name.";

		case "AmountOfCreeps":
			return "The amount of creeps to spawn for every interval.";

		case "MinSpawnTimeInterval":
			return "Minimum time for the random interval in seconds.";

		case "MaxSpawnTimeInterval":
			return "Maximum time for the random interval in seconds.";
	}
	return super.GetDescriptionText( PropName );
}

defaultproperties
{
	FriendlyName="No Peace"
	Description="With this mutator a random player will be creeped out by a certain monster every random interval between the maximum and minimum set time. Created by Eliot Van Uytfanghe @ 2011."

	CreepClass=class'Krall'
	AmountOfCreeps=6
	MinSpawnTimeInterval=15
	MaxSpawnTimeInterval=30
	CreepOffset=40
	UDamageBonusTime=15

	bAddToServerPackages=true
}
