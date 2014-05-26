//
//  PlayingMatchCardViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 5/2/14.
//  Copyright (c) 2014 ;;. All rights reserved.
//

#import "PlayingMatchCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingMatchingCardGame.h"
#import "PlayingCardView.h"
#import "MatchGameBoundView.h"

@interface PlayingMatchCardViewController()

@property (strong, nonatomic) PlayingMatchingCardGame *game;
@property (nonatomic,strong) PlayingCardView *card;
@property (nonatomic,strong) NSMutableArray *superCards;  //of Playing Card View
@property (weak, nonatomic) IBOutlet MatchGameBoundView *playingCardBoundView;
@end


@implementation PlayingMatchCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self upDateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self upDateUI];
}

- (void)upDateUI //??????
{
    if(self.game)
    {
        for(PlayingCardView *card in self.superCards)
        {
            [self.playingCardBoundView addSubview:card];
        }
    }
}


int cardNumber = 20;

- (NSMutableArray *)superCards
{
    if (!_superCards) {
        _superCards = [[NSMutableArray alloc] init];
    }
    return _superCards;
}


- (PlayingMatchingCardGame *)game
{
    if (!_game) {
        _game = [[PlayingMatchingCardGame alloc] initWithCardCount:cardNumber
                                                 usingDeck:[self createDeck]];
        [self initSuperCards];
    }
    return _game;
}

static CGFloat recWidth = 50;
static CGFloat recHeight = 64;
static int rowNumber = 5;
static CGFloat widthOffset = 5;
static CGFloat heightOffset = 5;


- (void)initSuperCards
{
    for (int i = 0; i < cardNumber; i++ ) {
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i];
        CGFloat x = (i%rowNumber) * recWidth + ((i%rowNumber) + 1) * widthOffset;
        CGFloat y = (i/rowNumber) * recHeight + ((i/rowNumber) + 1) * heightOffset;
        CGRect frame = CGRectMake(x, y, recWidth, recHeight);
        PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:frame];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.faceUp = YES;
        [self.superCards addObject:cardView];
        [self upDateUI];
    }
}

- (Deck*)createDeck
{
    return [[PlayingCardDeck alloc]init];
}

@end

