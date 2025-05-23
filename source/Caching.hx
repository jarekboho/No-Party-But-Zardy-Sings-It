#if sys
package;

import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var kadeLogo:FlxSprite;

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var charts = [];


	override function create()
	{

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();

		text = new FlxText(FlxG.width / 2, FlxG.height / 2 + 300,0,"Loading...");
		text.size = 34;
		text.alignment = FlxTextAlign.CENTER;
		text.alpha = 0;

		kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.x -= kadeLogo.width / 2;
		kadeLogo.y -= kadeLogo.height / 2 + 100;
		text.y -= kadeLogo.height / 2 - 125;
		text.x -= 170;
		kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));
		kadeLogo.antialiasing = true;
		
		kadeLogo.alpha = 0;

		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push("assets/shared/images/characters" + "/" + i);
			}
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/ChallengeWeek/images/five-minute-song")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push("assets/ChallengeWeek/images/five-minute-song" + "/" + i);
			}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}

		#end

		toBeDone = Lambda.count(images) + Lambda.count(music);

		var bar = new FlxBar(10,FlxG.height - 50,FlxBarFillDirection.LEFT_TO_RIGHT,FlxG.width,40,null,"done",0,toBeDone);
		bar.color = FlxColor.PURPLE;

		add(bar);

		add(kadeLogo);
		add(text);
		
		#if cpp
		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						var alpha = HelperFunctions.truncateFloat(done / toBeDone * 100,2) / 100;
						kadeLogo.alpha = alpha;
						text.alpha = alpha;
						text.text = "Loading... (" + done + "/" + toBeDone + ")";
					}
			}
		
		});

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	var calledDone = false;

	override function update(elapsed) 
	{
		super.update(elapsed);
	}


	function cache()
	{
		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile(i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			done++;
		}

		loaded = true;

		FlxG.switchState(new TitleState());
	}

}
#end