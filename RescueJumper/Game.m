//
//  Game.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 1/29/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "cocos2d.h"

#import "JumpBase.h"
#import "JumpPlateforme.h"

#import "InteractiveElement.h"

#import "CollidObject.h"

#import "HelpLabel.h"

#import "Game.h"
#import "Bipede.h"

#import "CoinBonus.h"

#import "Actioner.h"
#import "GameStateAction.h"

#import "BaseGameButton.h"
#import "ShipGameButton.h"
#import "TourelleGameButton.h"

#import "ChainList.h"

#import "Physics.h"

#import "Display.h"
#import "Screen.h"
#import "AnimatedDisplayObject.h"
#import "StaticDisplayObject.h"
#import "ParticleDisplayObject.h"

#import "CableSystemDisplayObject.h"

#import "PlayerData.h"
#import "TouchManager.h"

#import "ScoreHighLightManager.h"
#import "ScoreLabelHighlightItem.h"

#import "SimpleAudioEngine.h"

#import "ParallaxManager.h"

#import "HomeMenu.h"

#import "HelpScreen.h"

#import "Scores.h"

#import "AvoidDanger.h"

#import "MBDACenter.h"

#import "Tourelle.h"

#import "SkyNode.h"

#define N_PATH_STEPS 10

@implementation Game

@synthesize scrollSpeed;

@synthesize pnjs;
@synthesize jumpBases;
@synthesize collidObjects;
@synthesize interactiveElements;
@synthesize buttons;

@synthesize playerData;
@synthesize scoreHighLightManager;
@synthesize nPlayer;

@synthesize gameStateActioner;

@synthesize touchManager;

@synthesize muteMusicFader;

@synthesize gameTime;

-(id) initWithNPlayer:(NSUInteger)_nPlayer muted:(BOOL)muted
{
	if( (self=[super init]) ) {

		nPlayer = _nPlayer;
		scrollSpeed = 0;
        gameTime = 0;
        
		//[TestFlight passCheckpoint:[NSString stringWithFormat:@"Game started with %d player%@", nPlayer, (nPlayer > 1 ? @"s." : @".")]];

		[[SimpleAudioEngine sharedEngine] preloadEffect:@"bonus.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"hitMetalWall.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"hitRockWall.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"hosto.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"screams.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"scream.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"zombie1.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"zombie2.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"zombie3.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"rocket.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"scoreSound.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"tombe.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"ufo.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"plateformeFall.wav"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"timeEnd.wav"];
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_human.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_octave.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_ship.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bonus.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_bonus_icons.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_wall-palette.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_button.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"atlas_stars.plist"];
		
		[[[CCTextureCache sharedTextureCache] addImage:@"bigvaisseau.png"] retain];
        for (int i = 0; i < 2; ++i) {
            [[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"hopital-back%d.png", i]] retain];
            [[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"hopital-front%d.png", i]] retain];
        }

		[[Display sharedDisplay] initScreens:nPlayer game:self];
		
		[self addChild:[Display sharedDisplay]];
		
		scoreHighLightManager = malloc(sizeof(ScoreHighLightManager *) * nPlayer);
		for (int i = 0; i < nPlayer; ++i) {
			scoreHighLightManager[i] = [[ScoreHighLightManager alloc] initWithPlayer:i];
		}
		
		/*sky = [[StaticDisplayObject alloc] initSprite:@"sky.png" anchor:ccp(0.0, 0.0) isSpriteFrame:NO];
        sky.scale = [Display sharedDisplay].size.width / sky.size.width;
		sky.position = ccp(0, [Display sharedDisplay].size.height - sky.size.height * sky.scale);
		[[Display sharedDisplay] addDisplayObject:sky onNode:ROOTNODE z:-1];*/
        
        for (int i = 0; i < nPlayer; ++i) {
            skyNodes[i] = [[SkyNode alloc] initWithRect:CGRectMake(0, [Display sharedDisplay].size.height / 4, [Display sharedDisplay].size.width, [Display sharedDisplay].size.height * 3/4) nPieces:10];
            skyNodes[i].sunPos = ccp([Display sharedDisplay].size.width / 2, -550);
            [skyNodes[i] updateVertices];
            [skyNodes[i] updateColors];
            [[Display sharedDisplay].screens[i].rootNode addChild:skyNodes[i] z:-1];
        }
		
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
			[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
		
		parallaxManager[2] = [[ParallaxManager alloc] initWithImg:@"layer3.png" offset:184 + 100 + 48 speed:0.1f];
		parallaxManager[1] = [[ParallaxManager alloc] initWithImg:@"layer2.png" offset:184 + 100 speed:0.4f];
		parallaxManager[0] = [[ParallaxManager alloc] initWithImg:@"layer1.png" offset:184 speed:0.7f];
		
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
			[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB5A1];
		
		pnjs = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
										   removeCallBack:@selector(dummyHandler:)
												 delegate:self];
		
		jumpBases = [[ChainList alloc] initWithAddCallbacks:@selector(jumpBaseAdded:)
											 removeCallBack:@selector(jumpBaseRemoved:)
												   delegate:self];
		
		collidObjects = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
												 removeCallBack:@selector(dummyHandler:)
													   delegate:self];
        
        interactiveElements = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
                                                       removeCallBack:@selector(dummyHandler:)
                                                             delegate:self];
        
        buttons = [[ChainList alloc] initWithAddCallbacks:@selector(dummyHandler:)
                                           removeCallBack:@selector(dummyHandler:)
                                                 delegate:self];
        
		cableSystem = [[CableSystemDisplayObject alloc] initWithGame:self];
		[[Display sharedDisplay] addDisplayObject:cableSystem onNode:SCROLL z:-1];
        
        if (!muted) {
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3" loop:YES];
            [CDAudioManager sharedManager].backgroundMusic.volume = 0;
			muteMusicFader = YES;
		}

        touchManager = malloc(sizeof(TouchManager *) * nPlayer);
        for (int i = 0; i < nPlayer; ++i)
            touchManager[i] = [[TouchManager alloc] initWithGame:self player:i];
        
        gameStateActioner = [[Actioner alloc] init];
        
        playerData = malloc(sizeof(PlayerData *) * nPlayer);
        for (int i = 0; i < nPlayer; ++i)
            playerData[i] = [[PlayerData alloc] initWithGame:self];
        
		[self schedule:@selector(update:) interval:1.0f/60.0f];
		
	}
	
	return self;
}

- (void)update:(ccTime)dt {
    
    if (dt > 1.0f/10.0f)
        return;
	
	[gameStateActioner update:dt];
    
    [buttons iterateOrRemove:^BOOL(id entry) {
        BaseGameButton *current = entry;
        return ![current update:dt];
    } removeOnYES:YES exit:NO];
	
	for (int i = 0; i < 3; ++i)
		[parallaxManager[i] update:dt scrollX:scrollSpeed];
	
	for (int i = 0; i < nPlayer; ++i)
		[scoreHighLightManager[i] update:dt];
	
    if ([SimpleAudioEngine sharedEngine].isBackgroundMusicPlaying) {
        if (muteMusicFader && [CDAudioManager sharedManager].backgroundMusic.volume > 0) {
            [CDAudioManager sharedManager].backgroundMusic.volume-=dt;
            if ([CDAudioManager sharedManager].backgroundMusic.volume < 0.0f)
                [CDAudioManager sharedManager].backgroundMusic.volume = 0.0f;
        } else if (!muteMusicFader && [CDAudioManager sharedManager].backgroundMusic.volume < 1.0f) {
            [CDAudioManager sharedManager].backgroundMusic.volume+=dt;
            if ([CDAudioManager sharedManager].backgroundMusic.volume > 1.0f)
                [CDAudioManager sharedManager].backgroundMusic.volume = 1.0f;
        }
    }
    
    for (int i = 0; i < nPlayer; ++i)
        [skyNodes[i] updateStarsColors];
	    
	[[MBDACenter sharedMBDACenter] update:dt];
	[Display sharedDisplay].scrollX += -scrollSpeed * dt;
    gameTime += dt;
}

- (void)processBipedes:(ccTime)dt {
	[pnjs iterateOrRemove:^BOOL(id entry) {
		Bipede *bipede = entry;
		return [self processBipede:dt bipede:bipede];
	} removeOnYES:YES exit:NO];
	
	for (int i = 0; i < nPlayer; ++i) {
		[playerData[i].bipedes iterateOrRemove:^BOOL(id entry) {
			Bipede *bipede = entry;
			return [self processBipede:dt bipede:bipede];
		} removeOnYES:YES exit:NO];
	}
}

- (void)processJumpBases:(ccTime)dt {
	[jumpBases iterateOrRemove:^BOOL(id entry) {
		JumpBase *jumpBase = entry;
        CGRect collidRect = [jumpBase collidRect];
		if (!jumpBase.toDelete)
			[jumpBase update:dt];
		return jumpBase.toDelete || collidRect.origin.x + collidRect.size.width < -[Display sharedDisplay].scrollX;
	} removeOnYES:YES exit:NO];
    
    [interactiveElements iterateOrRemove:^BOOL(id entry) {
		InteractiveElement *interactiveElement = entry;
        CGRect collidRect = [interactiveElement collidRect];
		if (!interactiveElement.toDelete)
			[interactiveElement update:dt];
		return interactiveElement.toDelete || collidRect.origin.x + collidRect.size.width < -[Display sharedDisplay].scrollX;
    } removeOnYES:YES exit:NO];
}

- (void)processCollidRect:(ccTime)dt {
	[collidObjects iterateOrRemove:^BOOL(id entry) {
		CollidObject *collidObject = entry;
        CGRect collidRect = [collidObject collidRect];
		if (!collidObject.sprite.visible || collidRect.origin.x + collidRect.size.width < -[Display sharedDisplay].scrollX)
			return YES;
		[collidObject update:dt];
		return !collidObject.sprite.visible;
	} removeOnYES:YES exit:NO];
}

- (BOOL)processBipede:(ccTime)dt bipede:(Bipede *)bipede  {
	[bipede update:dt];
    
	if (bipede.sprite.position.x + bipede.Vx * dt <= -[Display sharedDisplay].scrollX && bipede.currentJumpBase != nil && ![bipede.actioner.currentAction isKindOfClass:[AvoidDanger class]]) {
        if (!scrollSpeed)
            return NO;
        AvoidDanger *avoidDanger = [[AvoidDanger alloc] initWithBipede:bipede game:self dangerPos:CGPointMake(scrollSpeed > 0 ? bipede.sprite.position.x - bipede.sprite.size.width : bipede.sprite.position.x + bipede.sprite.size.width, bipede.sprite.position.y)];
		[bipede.actioner setCurrentAction:avoidDanger interrupted:YES];
        [avoidDanger release];
		return NO;
	}
    
	CGRect visibleRect = CGRectMake(-[Display sharedDisplay].scrollX, 0, [Display sharedDisplay].size.width * 2, [Display sharedDisplay].size.height * 2);
	CGRect bipedeRect = CGRectMake(bipede.sprite.position.x - bipede.sprite.size.width / 2, bipede.sprite.position.y, bipede.sprite.size.width, bipede.sprite.size.height);
	if (!bipede.sprite.visible || (!CGRectContainsRect(visibleRect, bipedeRect) && !CGRectIntersectsRect(visibleRect, bipedeRect))) {
		bipede.currentJumpBase = nil;
		if (!bipede.saved) {
			[bipede.movement onKilled];
		} else {
			[bipede.movement onSaved];
		}
		return YES;
	}        
	return NO;
}

- (BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	return [((GameStateAction *)gameStateActioner.currentAction) touchBegan:touch withEvent:event player:player];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[((GameStateAction *)gameStateActioner.currentAction) touchMoved:touch withEvent:event player:player];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event player:(NSInteger)player {
	[((GameStateAction *)gameStateActioner.currentAction) touchEnded:touch withEvent:event player:player];
}

- (void)jumpBaseAdded:(JumpBase *)jumpBase {

}

- (void)jumpBaseRemoved:(JumpBase *)jumpBase {
	//[[NSNotificationCenter defaultCenter] removeObserver:jumpBase];
	[[NSNotificationCenter defaultCenter] postNotificationName:JUMP_BASE_REMOVED object:jumpBase];
	[jumpBase.onBoard iterateOrRemove:^BOOL(id entry) {
		Bipede *bipede = entry;
		[bipede currentJumpBaseDeleted];
		return YES;
	} removeOnYES:YES exit:NO];
}

- (void)addScore:(CGFloat)score player:(NSUInteger)_player pos:(CGPoint)pos {
	[self addScore:score player:_player];
	if (pos.x < -[Display sharedDisplay].scrollX)
		pos.x += 50;
	if (pos.x > -[Display sharedDisplay].scrollX + [Display sharedDisplay].size.width)
		pos.x -= 50;
	
	if (pos.y < 0)
		pos.y += 50;
	if (pos.y > [Display sharedDisplay].size.height)
		pos.x -= 50;
    ScoreHighlightItem *scoreItem = [[ScoreLabelHighlightItem alloc] initWithPos:pos score:score player:_player];
	[scoreHighLightManager[_player] addScoreHightLight:scoreItem];
    [scoreItem release];
}

- (void)addScore:(CGFloat)score player:(NSUInteger)_player {
	playerData[_player].score += score;
}

- (void)dummyHandler:(id)entry {}

- (void)moveBipede:(Bipede *)bipede from:(NSInteger)from to:(NSInteger)to {
	if (from == to)
		return;

	if (to < nPlayer) {
		[playerData[to].bipedes addEntry:bipede];
	} else {
		[pnjs addEntry:bipede];
	}

	if (from < nPlayer) {
		[playerData[from].bipedes iterateOrRemove:^BOOL(id entry) {
			return entry == bipede;
		} removeOnYES:YES exit:YES];
	} else {
		[pnjs iterateOrRemove:^BOOL(id entry) {
			return entry == bipede;
		} removeOnYES:YES exit:YES];
	}
}

- (void)buttonVisible:(BOOL)visible {
    [buttons iterateOrRemove:^BOOL(id entry) {
        BaseGameButton *gameButton = entry;
        gameButton.sprite.visible = visible;
        return NO;
    } removeOnYES:NO exit:NO];
}

- (BOOL)addLeft:(NSInteger)addLeft buttonType:(GameButtonType)buttonType player:(NSUInteger)player {
    __block BOOL result;
    
    [buttons iterateOrRemove:^BOOL(id entry) {
        BaseGameButton *button = entry;
        if (button.buttonType == buttonType && button.player == player) {
            [button addLeft:addLeft];
            result = YES;
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    
    return result;
}

- (NSUInteger)getLeft:(GameButtonType)buttonType player:(NSUInteger)player {
    __block NSUInteger result;
    
    [buttons iterateOrRemove:^BOOL(id entry) {
        BaseGameButton *button = entry;
        if (button.buttonType == buttonType && button.player == player) {
            result = button.nLeft;
            return YES;
        }
        return NO;
    } removeOnYES:NO exit:YES];
    
    return result;
}

/*- (void)cleanGame {
    BOOL(^bipedeCleaner)(id entry) = ^(id entry) {
        Bipede *bipede = entry;
        bipede.currentJumpBase = nil;
        return YES;
    };
    [pnjs iterateOrRemove:bipedeCleaner removeOnYES:YES exit:NO];
    //for (int i = 0; i < nPlayer; ++i) {
    //    [playerData[i].bipedes iterateOrRemove:bipedeCleaner removeOnYES:YES exit:NO];
    //}
    [jumpBases iterateOrRemove:^BOOL(id entry) {
        return YES;
    } removeOnYES:YES exit:NO];
    [collidObjects iterateOrRemove:^BOOL(id entry) {
        return YES;
    } removeOnYES:YES exit:NO];
    [interactiveElements iterateOrRemove:^BOOL(id entry) {
        return YES;
    } removeOnYES:YES exit:NO];
    [buttons iterateOrRemove:^BOOL(id entry) {
        return YES;
    } removeOnYES:YES exit:NO];
    for (int i = 0; i < nPlayer; ++i) {
        [playerData[i] release];
        playerData[i] = [[PlayerData alloc] initWithGame:self];
        
        [[Display sharedDisplay].screens[i] setTopStat:nil];
    }
    [Display sharedDisplay].scrollX = 0;
    [MBDACenter reset];
}*/

- (void)dealloc {    
    [[[CCTextureCache sharedTextureCache] addImage: @"bigvaisseau.png"] release];
    for (int i = 0; i < 2; ++i) {
        [[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"hopital-back%d.png", i]] release];
        [[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"hopital-front%d.png", i]] release];
    }
    
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	
	[pnjs release];
	[jumpBases release];
	[collidObjects release];
    [buttons release];
    [interactiveElements release];
    
	[sky release];
	for (int i = 0; i < 3; ++i)
		[parallaxManager[i] release];
	for (int i = 0; i < nPlayer; ++i)
		[playerData[i] release];
	free(playerData);
	for (int i = 0; i < nPlayer; ++i) {
		[scoreHighLightManager[i] release];
	}
	free(scoreHighLightManager);
	for (int i = 0; i < nPlayer; ++i)
		[touchManager[i] release];
	free(touchManager);
	[self removeChild:[Display sharedDisplay] cleanup:YES];

	[Display reset];
    [MBDACenter reset];

	[gameStateActioner release];
	[cableSystem release];
    
	[super dealloc];
}

@end
