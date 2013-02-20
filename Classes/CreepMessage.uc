class CreepMessage extends LocalMessage;

static function string GetString
(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
)
{
	return "You got creeped!";
}

defaultproperties
{
	bFadeMessage=true
	bIsSpecial=true
	bIsUnique=true
	Lifetime=2

	DrawColor=(R=255,G=128,B=0,A=255)

	StackMode=SM_Down
	PosY=0.1
}