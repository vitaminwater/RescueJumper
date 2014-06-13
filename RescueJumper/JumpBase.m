//
//  JumpPlateForme.m
//  RescueJumper
//
//  Created by Constantin CLAUZEL on 2/7/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "Game.h"
#import "cocos2d.h"

#import "JumpBase.h"

#import "DisplayObject.h"

#import "PlayerData.h"

#import "Bipede.h"

@implementation JumpBase

@synthesize active;
@synthesize canJump;

@synthesize capacityMax;
@synthesize currentLoad;
@synthesize onBoard;

@synthesize Vx;
@synthesize Vy;
@synthesize size;

@synthesize nLinks;

@synthesize moveEntryPoints;
@synthesize canHaveNext;
@synthesize toDelete;
@synthesize isDeletable;

@synthesize isCabled;

@synthesize sprite;

@synthesize lifeTime;
@synthesize timeUnused;
@synthesize lastTouch;

@synthesize partsLeft;

@synthesize color;

- (id)initWithGame:(Game *)_game {
	
	if (self = [super init]) {
		game = _game;
		canHaveNext = NO;
		linkedTo = 0;
		currentLink = 0;
        nLinks = 0;
		active = NO;
		canJump = YES;
        moveEntryPoints = NO;
		toDelete = NO;
		isCabled = NO;
        isDeletable = NO;
		player = NEUTRAL_PLAYER;
		
		screamSound = 0;
		
		capacityMax = 1000;
		currentLoad = 0;
		
		lifeTime = 0;
        timeUnused = 0;
		
		onBoard = [[ChainList alloc] initWithAddCallbacks:@selector(bipedeAdded:) removeCallBack:@selector(bipedeRemoved:) delegate:self];
		partsLeft = [[ChainList alloc] initWithAddCallbacks:@selector(dummy:) removeCallBack:@selector(dummy:) delegate:self];
        
	}
	return self;
	
}

- (void)bipedeAdded:(Bipede *)bipede {
	currentLoad += [bipede.movement getWeight];
	if (currentLoad >= capacityMax) {
		if (!screamSound)
			screamSound = [[SimpleAudioEngine sharedEngine] playEffect:@"screams.wav"];
	}
    timeUnused = 0;
}

- (void)bipedeRemoved:(Bipede *)bipede {
	currentLoad -= [bipede.movement getWeight];
	if (currentLoad < capacityMax) {
		[[SimpleAudioEngine sharedEngine] stopEffect:screamSound];
		screamSound = 0;
	}
    timeUnused = 0;
}

- (void)activate {
	active = YES;
}

- (void)blockedWall:(NSInteger)hitPoint force:(CGFloat)force {}

- (void)addNextForPlayer:(NSUInteger)_player jumpBase:(JumpBase *)next fromPos:(CGPoint)from toPos:(CGPoint)to {
	JBlink *last = linkedTo;
    timeUnused = 0;
    next.timeUnused = 0;
	for (JBlink *current = linkedTo; current; current = current->next) {
		if (current->base == next && current->player == _player) {
            current->from = from;
			current->to = to;
			current->lastJumper = 100;
			return;
        }
    }
	JBlink *newL = malloc(sizeof(JBlink));
	newL->player = _player;
	newL->base = [next retain];
	newL->lastJumper = 1000;
    newL->from = from;
    newL->to = to;
	newL->next = 0;
	if (last) {
		for (; last->next; last = last->next);
		last->next = newL;
	} else {
		linkedTo = newL;
	}
	currentLink = newL;
    if (!nLinks)
        next.color = color;
    else
        next.color = (color + 1) % 5;
    nLinks++;
}

- (void)replaceNextForPlayer:(NSUInteger)_forPlayer from:(JumpBase *)from to:(JumpBase *)to {
	JBlink *found = 0;
    timeUnused = 0;
    from.timeUnused = 0;
    to.timeUnused = 0;
	for (JBlink *current = linkedTo; current; current = current->next) {
		if (current->base == from && current->player == _forPlayer) {
			found = current;
		} else if (current->base == to && current->player == _forPlayer) {
			[self removeNext:from];
			return;
		}
	}
	if (found) {
		[found->base release];
		found->base = [to retain];
	}
}

- (JumpBase *)getNextForPlayer:(NSUInteger)pl from:(CGPoint *)from to:(CGPoint *)to waitTime:(CGFloat)waitTime {
	if (!currentLink)
		return nil;
	JBlink *tmp = currentLink;
	while (!(currentLink->base.active && (currentLink->player == pl || pl == ZOMBIE_PLAYER) && currentLink->lastJumper >= waitTime && (currentLink->base.player == pl || currentLink->base.player == NEUTRAL_PLAYER || pl == ZOMBIE_PLAYER))) {
		currentLink = currentLink->next ? currentLink->next : linkedTo;
		if (currentLink == tmp)
			return nil;
	}
	tmp = currentLink;
	currentLink = currentLink->next ? currentLink->next : linkedTo;
	tmp->lastJumper = 0;
	*from = tmp->from;
	*to = tmp->to;
	return tmp->base;
}

- (void)removeNext:(JumpBase *)jumpBase {
	JBlink *last = 0;
	if(currentLink && currentLink->base == jumpBase) {
		if (currentLink == linkedTo && !currentLink->next)
			currentLink = 0;
		else
			currentLink = currentLink->next ? currentLink->next : linkedTo;
	}
	for (JBlink *current = linkedTo; current; current = current->next) {
		if (current->base == jumpBase) {
			if (last)
				last->next = current->next;
			else
				linkedTo = current->next;
			[current->base release];
			free(current);
            nLinks--;
			return;
		}
		last = current;
	}
}

- (void)update:(ccTime)dt {
	CGRect fromCollidRect = [self collidRect];
	for (JBlink *current = linkedTo; current;) {
		current->lastJumper += dt;
		if (current->base.active && Vx == 0 && Vy == 0 && current->base.Vx == 0 && current->base.Vy == 0) {
			current = current->next;
		} else {
			CGRect toCollidRect = [current->base collidRect];
            CGPoint from = ccp(current->to.x + toCollidRect.origin.x, current->to.y + toCollidRect.origin.y);
            CGPoint to = ccp(current->from.x + fromCollidRect.origin.x, current->from.y + fromCollidRect.origin.y);
			if (!current->base.active || toCollidRect.origin.y < -toCollidRect.size.height || ccpDistance(from, to) > game.playerData[current->player].maxJumpDistance * 1.2f) {
					JBlink *tmp = current->next;
					[self removeNext:current->base];
					current = tmp;
			} else {
                if (current->base.moveEntryPoints && current->base->Vx) {
                    current->to.x -= current->base->Vx * dt;
                    current->to.x = (current->to.x < 0 ? 0 : (current->to.x > toCollidRect.size.width ? toCollidRect.size.width : current->to.x));
                }
				current = current->next;
            }
		}
	}
	
	if (currentLoad >= capacityMax)
		Vy += (-80 - Vy) * dt * 5;
	else
		Vy += (-Vy) * dt * 1.5;
	
	sprite.position = ccp(sprite.position.x + Vx * dt, sprite.position.y + Vy * dt);
    
    if (currentLoad) {
        GLubyte tmp;// * (cosf(lifeTime * 3.0f) + 1) / 2;
        
        if (currentLoad >= capacityMax)
            tmp = 0;
        else
            tmp = (GLubyte)255 - ((CGFloat)currentLoad / (CGFloat)capacityMax) * 255;
        sprite.color = (ccColor3B){255, tmp, tmp};
    } else
        sprite.color = ccWHITE;
    
	if (linkedTo == 0 && sprite.position.y <= -100) {
		[onBoard iterateOrRemove:^BOOL(id entry) {
			[((Bipede *)entry) currentJumpBaseDeleted];
			return YES;
		} removeOnYES:YES exit:NO];
		toDelete = YES;
	}
    if (![onBoard count])
        timeUnused += dt;
	lifeTime += dt;
}

- (void)jumpBaseRemoved:(NSNotification *)note {
	JumpBase *tmp = [note object];
	if (tmp.player != NEUTRAL_PLAYER && tmp.partsLeft.count) {
		__block JBlink *toAdd = 0;
		__block NSInteger i = 0;
		CGRect plateformeCollidRect = [tmp collidRect];
		for (JBlink *current = linkedTo; current; current = current->next) {
			if (current->base != tmp)
				continue;
			if (!toAdd)
				toAdd = malloc(10 * sizeof(JBlink));
			[tmp.partsLeft iterateOrRemove:^BOOL(id entry) {
				JumpBase *part = entry;
				CGRect partCollidRect = [part collidRect];
				CGPoint to = current->to;
				to.x -= partCollidRect.origin.x - plateformeCollidRect.origin.x;
				to.x = to.x < 0 ? 0 : (to.x > part.sprite.size.width ? part.sprite.size.width : to.x);
				toAdd[i].base = part;
				toAdd[i].from = current->from;
				toAdd[i].to = to;
				toAdd[i].player = current->player;
				++i;
				return i >= 10;
			} removeOnYES:NO exit:YES];
		}
		if (toAdd) {
			for (--i; i >= 0; --i) {
				[self addNextForPlayer:toAdd[i].player jumpBase:toAdd[i].base fromPos:toAdd[i].from toPos:toAdd[i].to];
			}
			free(toAdd);
		}
	}
	[self removeNext:tmp];
}

- (BOOL)linksTo {
	return linkedTo != 0;
}

- (BOOL)linkedTo:(JumpBase *)jumpBase {
    for (JBlink *current = linkedTo; current; current = current->next) {
        if (current->base == jumpBase)
            return YES;
    }
    return NO;
}

- (void)setPlayer:(NSUInteger)_player {
	player = _player;
	if (player < game.nPlayer)
		sprite.mainScreen = player;
	else
		sprite.mainScreen = -1;
}

- (CGRect)collidRect {
	return CGRectMake(sprite.position.x - sprite.size.width / 2,
					  sprite.position.y - sprite.size.height / 2,
					  sprite.size.width, sprite.size.height);
}

- (CGFloat)touchHeightAdded {
    return [onBoard count] ? 60 : 0;
}

- (NSUInteger)type {
    return JUMPBASE;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	for (JBlink *current = linkedTo; current;) {
		JBlink *tmp = current->next;
		[current->base release];
		free(current);
		current = tmp;
	}
	[sprite release];
	[onBoard release];
	[partsLeft release];
	[super dealloc];
}

@end
