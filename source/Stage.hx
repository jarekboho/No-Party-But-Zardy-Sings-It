package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;

class Stage
{
    public var curStage:String = '';
    public var halloweenLevel:Bool = false;
    public var camZoom:Float;
    public var hideLastBG:Bool = false;
    public var tweenDuration:Float = 2;
    public var toAdd:Array<Dynamic> = [];
    public var swagBacks:Map<String, Dynamic> = [];
    public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = [];
    public var animatedBacks:Array<FlxSprite> = [];
    public var layInFront:Array<Array<FlxSprite>> = [[], [], []];
    public var slowBacks:Map<Int, Array<FlxSprite>> = [];

    public function new(daStage:String)
    {
        this.curStage = daStage;
        camZoom = 1.05;
        halloweenLevel = false;
		if (PlayStateChangeables.Optimize) return;

						camZoom = 0.7;
						curStage = 'zardyBruh';
						PlayState.ZardyBackground = new FlxSprite(-600, -200);
						PlayState.ZardyBackground.frames = Paths.getSparrowAtlas('five-minute-song/Zardy2BG','ChallengeWeek');
						PlayState.ZardyBackground.animation.addByPrefix('Maze','BG', 24);
						PlayState.ZardyBackground.antialiasing = true;
						PlayState.ZardyBackground.animation.play('Maze');
						PlayState.instance.add(PlayState.ZardyBackground);

						PlayState.instance.vine = new FlxSprite(155,620);

						PlayState.instance.vine.antialiasing = true;

						PlayState.instance.vine.frames = Paths.getSparrowAtlas("five-minute-song/ZardyWeek2_Vines","ChallengeWeek");
				
						PlayState.instance.vine.animation.addByPrefix("vine","Vine Whip instance",Math.floor(24 * PlayState.songMultiplier),false);
						PlayState.instance.vine.setGraphicSize(Std.int(PlayState.instance.vine.width * 0.85));
						
						PlayState.instance.vine.alpha = 0;
				
						PlayState.instance.add(PlayState.instance.vine);
    }
}