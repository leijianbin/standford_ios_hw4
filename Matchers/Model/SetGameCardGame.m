//
//  SetGameCardGame.m
//  Matchers
//
//  Created by Jianbin Lei on 5/4/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "SetGameCardGame.h"

@interface SetGameCardGame()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards;
@property (nonatomic,strong) NSMutableArray *choseCards; //of Cards
@property (nonatomic) NSString *currentResult;

@end

@implementation SetGameCardGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)choseCards
{
    if(!_choseCards) _choseCards = [[NSMutableArray alloc] init];
    return _choseCards;
}

- (instancetype)initWithCardCount: (NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    if(self)
    {
        //implemenet your own init
        for (int i = 0;  i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            //cards[i] = card;
            //[self.cards insertObject:card atIndex:i];
        }
    }
    return self;
}

- (SetGameCard *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? self.cards[index]:nil; //better
}

- (NSString *)chooseCardAtIndex:(NSUInteger)index
{
    self.currentResult = @"";
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.choseCards removeObject:card];
        } else {
            card.chosen = YES;
            if([self.choseCards count] == 2)
            {
                int matchScore = [card match:self.choseCards];
                Card* element_0 = self.choseCards[0];
                Card* element_1 = self.choseCards[1];
                
                if (matchScore) {
                    //if match ...
                    card.chosen = YES;
                    
                    card.matched = YES;
                    element_0.matched = YES;
                    element_1.matched = YES;
                    [self.choseCards removeAllObjects];
                    
                } else {
                    //if not match ...
                    card.chosen = NO;
                    element_0.chosen = NO;
                    element_1.chosen = NO;
                    [self.choseCards removeAllObjects];
                    
                }
                // match
            } else {
                [self.choseCards addObject:card];
            }
        }
    }
    return self.currentResult;
}




@end
