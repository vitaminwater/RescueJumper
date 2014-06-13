//
//  Ship.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/4/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Ship.h"
#import "Smoke.h"

#import "Game.h"
#import "PlayerData.h"
#import "Scores.h"

#import "ShipGenerator.h"

#import "Display.h"
#import "Screen.h"
#import "StaticDisplayObject.h"
#import "AnimatedDisplayObject.h"
#import "TextDisplayObject.h"
#import "ParticleDisplayObject.h"

#import "ScoreHighLightManager.h"
#import "BonusHighlightItem.h"

#import "Bipede.h"
#import "Actioner.h"
#import "Fall.h"
#import "BipedeBonusTime.h"

#import "JumpPlateforme.h"

#import "CollidObject.h"

@implementation Ship

@synthesize passengersIn;
@synthesize shipDelegate;
@synthesize desiredVx;

- (id)initWithGame:(Game *)_game position:(CGPoint)_position capacity:(NSUInteger)capacity {
	
	if (self = [super initWithGame:_game]) {
		position = _position;
		active = YES;
		passengersLeft = capacity;
        passengersIn = 0;
		exploding = NO;
        leaving = NO;
		
		smokeManager = [[SmokeManager alloc] init];
		
		AnimatedDisplayObject *_sprite = [[AnimatedDisplayObject alloc] initAnimatedNode:@"ship_bot1.png" defaultScale:1.0f anchor:ccp(0.5, 0.5)];
		[_sprite initAnim:@"floating" n:7 delay:0.1 animPrefix:@"ship_bot"];
		[_sprite setAnim:@"floating" repeat:YES];
		position.x += _sprite.size.width / 2;
		position.y += _sprite.size.height / 2;
		_sprite.position = position;
		
		top = [[StaticDisplayObject alloc] initSprite:@"ship_top.png" anchor:ccp(1, 0) isSpriteFrame:YES];
		top.position = ccp(112, 105);
		top.rotation = 90;
		
		[_sprite addSubDisplayObject:top];
		
		labelLeft = [[TextDisplayObject alloc] initWithFont:@"burgley19.fnt" anchor:ccp(0.5, 0.5) text:[NSString stringWithFormat:@"%d", passengersLeft]];
		labelLeft.position = ccpAdd(position, ccp(-25, 0));
		
		[[Display sharedDisplay] addDisplayObject:labelLeft onNode:FRONT z:0];
		
		sprite = _sprite;
		[[Display sharedDisplay] addDisplayObject:sprite onNode:SHIP z:0];
		
		for (int i = 0; i < game.nPlayer; ++i)
			[game.playerData[i] addStat:STAT_N_SHIP n:1 pts:0];

		canHaveNext = NO;

		size = sprite.size;
		
		Vx = (game.scrollSpeed / 2);
        desiredVx = Vx;
        
        shipSound = [[SimpleAudioEngine sharedEngine] playEffect:@"ufo.wav" pitch:1 pan:0 gain:0 loop:YES];
	}
	return self;
	
}

- (void)bipedeAdded:(Bipede *)bipede {
    
    static NSDictionary *explodeDict = nil;
    static NSDictionary *persoinshipDict = nil;
    
	[super bipedeAdded:bipede];

    Vx = (desiredVx / 3);
    
    if ([bipede.movement savedSprite]) {
        CGPoint end;
        if (bipede.bonus && [bipede.bonus isKindOfClass:[BipedeBonusTime class]])
            end = ccp(368/* + game.playerData[bipede.player].currentClockGuysSaved * 24*/, [Display sharedDisplay].size.height - 16);
        else
            end = self.sprite.position;
		if (bipede.player == ZOMBIE_PLAYER || (bipede.bonus && [bipede.bonus isKindOfClass:[BipedeBonusTime class]])) {
			for (int i = 0; i < game.nPlayer; ++i) {
				BonusHighlightItem *bonusItem = [[BonusHighlightItem alloc] initWithSprite:[bipede.movement savedSprite] start:self.sprite.position end:end scaleStart:1.2f scaleEnd:0.8f duration:1.0f delay:0.3f player:i];
				[game.scoreHighLightManager[i] addScoreHightLight:bonusItem];
				[bonusItem release];
			}
		} else {
			BonusHighlightItem *bonusItem = [[BonusHighlightItem alloc] initWithSprite:[bipede.movement savedSprite] start:self.sprite.position end:end scaleStart:1.0f scaleEnd:0.8f duration:1.0f delay:0.3f player:bipede.player];
			[game.scoreHighLightManager[bipede.player] addScoreHightLight:bonusItem];
			[bonusItem release];
		}
    }

	if (bipede.player == ZOMBIE_PLAYER) {
        if (!explodeDict)
            explodeDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ship_explode" ofType:@"plist"]] retain];

		[[Display sharedDisplay] spawnParticleDict:explodeDict pos:sprite.position];
		[[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
        [[SimpleAudioEngine sharedEngine] stopEffect:shipSound];
        shipSound = 0;
        [[Display sharedDisplay] shakeScreens:30];

		[game.jumpBases iterateOrRemove:^BOOL(id entry) {
			JumpBase *jumpBase = entry;
			if (jumpBase.type != JUMPBASE_PLATEFORME || fabs(jumpBase.sprite.position.x - sprite.position.x) > 200 || fabs(jumpBase.sprite.position.y - sprite.position.y) > 200)
				return NO;
			JumpPlateforme *plateforme = entry;
			[plateforme blockedWall:rand() % (NSInteger)plateforme.sprite.size.width force:4.0f];
			return NO;
		} removeOnYES:NO exit:NO];
		
		for (int i = 0; i < game.nPlayer; ++i) {
			[game.playerData[i].bipedes iterateOrRemove:^BOOL(id entry) {
				Bipede *current = entry;
				if (current.currentJumpBase != nil || fabs(current.sprite.position.x - sprite.position.x) > 200.0f || fabs(current.sprite.position.y - sprite.position.y) > 200.0f)
					return NO;
				if (current.sprite.position.x - sprite.position.x > 0)
					current.Vx = ((200.0f - (current.sprite.position.x - sprite.position.x)) / 200.0f) * (100.0f + rand() % 40);
				else
					current.Vx = ((-200.0f - (current.sprite.position.x - sprite.position.x)) / 200.0f) * (100.0f + rand() % 40);
				current.Vy = 400.0f;
                Fall *fall = [[Fall alloc] initWithBipede:current game:game];
				[current.actioner setCurrentAction:fall interrupted:YES];
                [fall release];
				return NO;
			} removeOnYES:NO exit:NO];
            
            [game addScore:BROKEN_SHIP player:i pos:sprite.position];
            [game.playerData[i] addStat:STAT_N_BROKEN_SHIP n:1 pts:BROKEN_SHIP];
		}
		
		[game.collidObjects iterateOrRemove:^BOOL(id entry) {
			CollidObject *collidObject = entry;
			if (!collidObject.breakable || fabs(collidObject.sprite.position.x - sprite.position.x) > 200 || fabs(collidObject.sprite.position.y - sprite.position.y) > 200)
				return NO;
			[collidObject hit:rand() % (NSInteger)collidObject.sprite.size.height force:4.0f];
			return NO;
		} removeOnYES:NO exit:NO];
		
		[shipDelegate shipDestroyed:self];
		
		exploding = YES;
		self.active = NO;
		bipede.sprite.visible = NO;
		toDelete = YES;
		return;
	}
	--passengersLeft;
    ++passengersIn;
	labelLeft.string = [NSString stringWithFormat:@"%d", passengersLeft];
	active = passengersLeft > 0;
    leaving = !active;
	if (!passengersLeft) {
        [shipDelegate shipFull:self player:bipede.player];
	}
	if (bipedeEffect < 0.01)
		bipedeEffect = M_PI;
	if (bipede.bonus != nil) {
		[bipede.bonus execute];
        [game.playerData[bipede.player] addStat:STAT_BONUS_HUMAN n:1 pts:BIPEDE_BONUS];
		[game addScore:BIPEDE_BONUS player:bipede.player pos:bipede.sprite.position];
	}
	bipede.saved = YES;
	bipede.sprite.visible = NO;
    
    if (!persoinshipDict)
        persoinshipDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"persoinship" ofType:@"plist"]] retain];
	CCParticleSystemQuad *particles = [[CCParticleSystemQuad alloc] initWithDictionary:persoinshipDict];
	particles.position = ccp(bipede.sprite.position.x, bipede.sprite.position.y + 20);
	particles.autoRemoveOnFinish = YES;
	[[Display sharedDisplay].screens[bipede.player].backNode addChild:particles];
    [particles release];
    
}

- (void)activate {}

- (void)update:(ccTime)dt {
	if (exploding || self.sprite.position.y - self.sprite.size.height / 2 > [Display sharedDisplay].size.height) {
		//if (!toDelete && [((AnimatedDisplayObject *)sprite) animEnded]) {
			sprite.visible = NO;
			toDelete = YES;
		//}
		return;
	}
	if (!leaving) {
        NSUInteger nPlayer = 0;
        for (int i = 0; i < game.nPlayer; ++i)
            nPlayer += [game.playerData[i].bipedes count];
        if (nPlayer == game.nPlayer) {
            active = NO;
        } else {
            active = YES;
        }
    }
    
    if (shipSound) {
        CGFloat gain = 1;
        if (sprite.position.x + sprite.size.width / 2 > [Display sharedDisplay].size.width - [Display sharedDisplay].scrollX)
            gain = (([Display sharedDisplay].size.width - [Display sharedDisplay].scrollX) - (sprite.position.x - sprite.size.width / 2)) / sprite.size.width;
        else if (sprite.position.x - sprite.size.width / 2 < 0)
            gain = (sprite.position.x + sprite.size.width / 2) / sprite.size.width;
        else if (sprite.position.y + sprite.size.height / 2 > [Display sharedDisplay].size.height)
            gain = ([Display sharedDisplay].size.height - (sprite.position.y - sprite.size.height / 2)) / sprite.size.height;
        else if (sprite.position.y - sprite.size.height / 2 < 0)
            gain = (sprite.position.y + sprite.size.height / 2) / sprite.size.height;
        if (gain >= 0 && gain <= 1) {
            //NSLog(@"%f", gain);
            alSourcef(shipSound, AL_GAIN, gain);
        }
    }
    
    Vx += (desiredVx - Vx) * dt * 2;
	[smokeManager update:dt];
	CGPoint pos = ccp(sprite.position.x, sprite.position.y - sprite.size.height / 2);
	sprite.position = ccp(sprite.position.x + Vx * dt,
						  (!leaving ?	position.y + cosf(lifeTime) * 30.0f - (bipedeEffect > 0.01 ? sinf(bipedeEffect) * 10.0f : 0) :
												sprite.position.y + (100.0f * dt)));
	top.rotation += ((!leaving ? 90.0f : 0) - top.rotation) / 20.0f;
	bipedeEffect /= 1.0f + (dt * 10.0f);
	if (!((int)sprite.position.x % 10))
		[smokeManager getSmoke:CGPointMake(-game.scrollSpeed / 2.0f * dt, -game.scrollSpeed / 2.0f * dt) pos:pos];
	labelLeft.position = ccpAdd(sprite.position, ccp(-25, 0));
	labelLeft.scale = bipedeEffect > 1.0f ? bipedeEffect : 1.0f;
    lifeTime += dt;
}

- (void)leave {
    active = NO;
    leaving = YES;
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2.0f, sprite.position.y - sprite.size.height * 0.25f,
					  sprite.size.width, sprite.size.height * 0.5f);
}

- (CGFloat)touchHeightAdded {
    return sprite.size.height / 4.0f;
}

- (NSUInteger)type {
    return JUMPBASE_SHIP;
}

- (void)dealloc {
    if (shipSound)
        [[SimpleAudioEngine sharedEngine] stopEffect:shipSound];
	[top release];
	[labelLeft release];
	[smokeManager release];
	[super dealloc];
}

@end
