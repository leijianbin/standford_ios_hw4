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
@property (nonatomic,strong) NSMutableArray *choseCards; //of Cards
@property (nonatomic) NSString *currentResult;

@end

@implementation CardMatchingGame

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

- (NSUInteger)number0fCards
{
    return [self.cards count];
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

- (NSString *)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    self.currentResult = @"";
    
    // 2 cards model logic
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.currentResult = [NSString stringWithFormat:@"%@ is not Chosen",card.contents];
        } else {
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                        self.currentResult = [NSString stringWithFormat:@"Matched %@ %@ for %d Points",card.contents, otherCard.contents,matchScore];
                    } else {
                        self.score -= MISMATCH_PENATY;
                        card.chosen = NO;
                        otherCard.chosen = NO;
                        self.currentResult = [NSString stringWithFormat:@"%@ %@ don't matched!%d Points penalty",card.contents, otherCard.contents, MISMATCH_PENATY];
                    }
                    break; // can only choose 2 cars for now
                }
            }
            self.score -= COST_TO_CHOOSE;
            if (![self.currentResult length]) {
                self.currentResult = [NSString stringWithFormat:@"%@ is chosen",card.contents];
            }
            card.chosen = YES;//
        }
    }
    
    return self.currentResult; //return the result of the current touch.
}


@end
