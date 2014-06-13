//
//  BasePNJAction.h
//  RescueLander
//
//  Created by stant on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef __BASEPNJACTION_H
#define __BASEPNJACTION_H

#import "Actioner.h"

@class Bipede;
@class Map;
@class Game;

@interface BaseBipedeAction : NSObject<Action> {

	Bipede *bipede;
	NSObject<Action> *next;
	
	Game *game;

}

-(id)initWithBipede:(Bipede *)bipedeArg game:(Game *)_game;
-(void)onTurn;

@end

#endif