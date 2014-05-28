//
//  CardMatchingGame.h
//  Matchers
//
//  Created by Jianbin Lei on 4/23/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"


@interface CardMatchingGame : NSObject
//public

- (instancetype)initWithCardCount: (NSUInteger)count
                        usingDeck:(Deck *)deck;
- (NSString *)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)number0fCards;

@property (nonatomic,readonly) NSInteger score;

@end
