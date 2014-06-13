//
//  ShopItemMenuController.h
//  RescueJumper
//
//  Created by Constantin on 8/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

typedef struct s_shopItemDescr {
    
    NSString *pic;
    NSString *descr;
    NSUInteger price;
    NSString *name;
    void(^buy)();
    BOOL enabled;
	NSUInteger itemType;
	NSUInteger left;
    
} shopItemDescr;

@interface ShopItemMenuController : UIViewController {
    
    IBOutlet UIImageView *pic;
    IBOutlet UILabel *descr;
    IBOutlet UILabel *price;
    IBOutlet UILabel *name;
	IBOutlet UILabel *leftLabel;
    IBOutlet UIButton *buyButt;
    
    IBOutletCollection(UILabel)NSArray *labels;
    
    shopItemDescr itemDescr;
    
    void(^buy)();
    
}

@property(nonatomic, readonly)UIButton *buyButt;
@property(nonatomic, readonly)shopItemDescr itemDescr;

- (id)initWithShopItemDescr:(shopItemDescr)_itemDescr;
- (void)setLeft:(NSUInteger)_left;

@end
