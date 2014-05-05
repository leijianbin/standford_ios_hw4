//
//  MatchCardViewController.h
//  Matchers
//
//  Created by Jianbin Lei on 4/20/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
@interface MatchCardViewController : UIViewController

//protected, abstract, need implement in subclass

- (Deck*)createDeck;

@end
