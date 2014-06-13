//
//  ShopItemMenuController.m
//  RescueJumper
//
//  Created by Constantin on 8/10/12.
//  Copyright (c) 2012 {EPITECH.}. All rights reserved.
//

#import "ShopItemMenuController.h"

@interface ShopItemMenuController ()

@end

@implementation ShopItemMenuController

@synthesize buyButt;
@synthesize itemDescr;

- (id)initWithShopItemDescr:(shopItemDescr)_itemDescr
{
    self = [super initWithNibName:@"ShopItemMenuController" bundle:nil];
    if (self) {
        itemDescr = _itemDescr;
        buy = [itemDescr.buy copy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pic.image = [UIImage imageNamed:itemDescr.pic];
    
    name.text = itemDescr.name;
	
	leftLabel.text = [NSString stringWithFormat:@"Item left : %d", itemDescr.left];
    
    descr.text = itemDescr.descr;
    
    price.text = [NSString stringWithFormat:@"%d", itemDescr.price];
    
    buyButt.enabled = itemDescr.enabled;
    
    for (UILabel *label in labels) {
		label.font = [UIFont fontWithName:@"AvantGarde" size:label.font.pointSize];
	}
}

- (void)setLeft:(NSUInteger)_left {
	leftLabel.text = [NSString stringWithFormat:@"Item left : %d", _left];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buy:(id)sender {
    buy();
}

- (void)dealloc {
    [pic release];
    [name release];
	[leftLabel release];
    [descr release];
    [price release];
    [buy release];
    [labels release];
    [super dealloc];
}

@end
