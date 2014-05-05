//
//  PlayingMatchCardViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 5/2/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "PlayingMatchCardViewController.h"
#import "PlayingCardDeck.h"

@implementation PlayingMatchCardViewController

- (Deck*)createDeck
{
    return [[PlayingCardDeck alloc]init];
}

@end

