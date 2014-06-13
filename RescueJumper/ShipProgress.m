//
//  ShipProgress.m
//  RescueJumper
//
//  Created by Constantin on 10/8/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShipProgress.h"

@implementation ShipProgress

@synthesize progress;

- (id)init {
    
    if (self = [super init]) {
        blowParticles = NO;
        
        bg = [CCSprite spriteWithFile:@"topbar_ns-track.png"];
        bg.anchorPoint = ccp(0, 0.5);
        bg.position = ccp(0, 0);
        [self addChild:bg];

        bar = [CCSprite spriteWithFile:@"topbar_ns-bar.png"];
        bar.anchorPoint = ccp(0, 0.5);
        bar.position = ccp(bg.contentSize.width, 0);
        [bar.texture setTexParameters:&(ccTexParams){ GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT }];
        [self addChild:bar];

        ship = [CCSprite spriteWithFile:@"topbar_ns.png"];
        ship.anchorPoint = ccp(0.5, 0.5);
        ship.position = ccp(bg.contentSize.width, 0);
        [self addChild:ship];
    }
    return self;
    
}

- (void)update:(ccTime)dt {
    CGFloat newWidth = progress * bg.contentSize.width;
    static NSDictionary *persoinshipDict = nil;
    if (progress == 1 && bar.textureRect.size.width >= bg.contentSize.width - 2) {
        if (blowParticles) {
            if (!persoinshipDict)
                persoinshipDict = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"persoinship" ofType:@"plist"]] retain];
            CCParticleSystemQuad *particles = [[CCParticleSystemQuad alloc] initWithDictionary:persoinshipDict];
            particles.position = ship.position;
            particles.autoRemoveOnFinish = YES;
            [self addChild:particles];
            [particles release];
            blowParticles = NO;
        }
        bar.visible = (int)(time * 3.0f) % 2;
    } else
        bar.visible = YES;
    bar.textureRect = CGRectMake(time * 60.0f, 0, bar.textureRect.size.width + (newWidth - bar.textureRect.size.width) * dt * 4.0f, bar.textureRect.size.height);
    bar.position = ccp(bg.contentSize.width - bar.textureRect.size.width, 0);
    ship.position = bar.position;

    time += dt;
}

- (void)setProgress:(CGFloat)_progress {
    if (_progress == 1 && progress != _progress)
        blowParticles = YES;
    progress = _progress;
}

@end
