//
//  CardMatchingGame.m
//  Matchers
//
//  Created by Jianbin Lei on 4/23/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
//private
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
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

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? self.cards[index]:nil; //better
}

static const int MISMATCH_PENATY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
              threeCardOn:(BOOL)onff
{
    Card *card = [self cardAtIndex:index];
    if (!onff) {
    // 2 cards model logic
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
            } else {
                //match other cards
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENATY;
                            otherCard.chosen = NO;
                        }
                        break; // can only choose 2 cars for now
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    }
    else {
    // 3 cards model logic
        if (!card.isMatched) {
            if (card.isChosen) {
                card.chosen = NO;
            } else {
                //match other two cards ???? 
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENATY;
                            otherCard.chosen = NO;
                        }
                        break; // can only choose 2 cars for now
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
            }
        }
    }
   
}


@end
