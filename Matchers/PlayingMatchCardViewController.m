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
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;

@property (nonatomic) BOOL startNewGame; //if we start a new game;

@end


@implementation PlayingMatchCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startNewGame = YES;
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
        if (self.startNewGame) {
            
            for(PlayingCardView *card in self.superCards)
            {
                card.center = CGPointMake(500.0, -1000.0);
                [self.playingCardBoundView addSubview:card];
            }
            
            for(int i = 0; i < cardNumber; i++)
            {
                PlayingCardView *u = self.superCards[i];
                
                CGFloat x = (i%rowNumber) * recWidth + ((i%rowNumber) + 1) * widthOffset;
                CGFloat y = (i/rowNumber) * recHeight + ((i/rowNumber) + 1) * heightOffset;
                CGRect frame = CGRectMake(x, y, recWidth, recHeight);
                
                [UIView animateWithDuration:1.0
                                      delay:0.1 * i
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     
                                     u.frame = frame;
                                     u.transform = CGAffineTransformIdentity;
                                 }
                                 completion:^(BOOL finished){
                                     [u setNeedsDisplay];
                                 }];
            }
            self.startNewGame = NO;
        }
        else {
            for(int i = 0; i < cardNumber; i++)
            {
                PlayingCardView *u = self.superCards[i];
                Card * card = [self.game cardAtIndex:i];
                if(card.matched)  // not visible
                {
                    [UIView animateWithDuration:1.0
                                          delay:1.0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         u.center = CGPointMake(500.0, -1000.0);
                                     }
                                     completion:^(BOOL finished){
                                         u.hidden = TRUE;
                                     }];
                } else
                {
                    if(card.isChosen)
                    {
                        u.faceUp = YES;
                    }
                    else
                    {
                        u.faceUp = NO;
                    }
                    CGFloat x = (i%rowNumber) * recWidth + ((i%rowNumber) + 1) * widthOffset;
                    CGFloat y = (i/rowNumber) * recHeight + ((i/rowNumber) + 1) * heightOffset;
                    CGRect frame = CGRectMake(x, y, recWidth, recHeight);
                    u.frame = frame;
                    [self.playingCardBoundView addSubview:u];
                }
            }
            self.scoreLable.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
            
        }
    }
    
}

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
        cardView.faceUp = NO;
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipe:)]];
        [self.superCards addObject:cardView];
    }
    [self upDateUI];
}

// gestures ------

- (IBAction)swipe:(UITapGestureRecognizer *)sender
{
    PlayingCardView *pc = (PlayingCardView *)sender.view;
    
    //__weak ViewController *weakSelf = self;
    [UIView transitionWithView:pc
                      duration:0.25
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        pc.faceUp = !pc.faceUp;
                    }
                    completion:nil];
    
    [self selectCard:pc];
    //self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

- (void) selectCard:(UIView *)view
{
    NSUInteger index = [self.superCards indexOfObject:view];
    NSLog(@"selectCard: index=%tu",index);
    PlayingCardView * pcv = (PlayingCardView *) view;
    NSLog(@"selectCard: suit=%@, rank =%d",pcv.suit, pcv.rank);
    PlayingCard * card = (PlayingCard *)[self.game cardAtIndex:index];
    NSLog(@"Real Card: suit=%@, rank =%d",card.suit, card.rank);
    
    // if we're not dynamic-animating, then let's play the game
    
    [self.game chooseCardAtIndex:index];
    //self.panPhase = FALSE; self.pinchPhase = FALSE; self.tapPhase = FALSE;
    [self upDateUI];
}


- (Deck*)createDeck
{
    return [[PlayingCardDeck alloc]init];
}

- (IBAction)reDeal:(UIButton *)sender {
    // clear up old deck
    NSUInteger max = [self.superCards count];
    for(int i = 0; i < max; i++) {
        UIView *u = self.superCards[0];
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             u.center = CGPointMake(-500.0, -1000.0);
                         }
                         completion:^(BOOL finished){
                             [u removeFromSuperview];
                         }];
        [self.superCards removeObjectAtIndex:0];
    }
    
    NSLog(@"Start New Game...");
    self.superCards = nil;
    self.game = nil;
    self.startNewGame = YES;
    
    [self upDateUI];
}

- (NSInteger) initialNumCards
{
    return 20;
}

int cardNumber = 20;
int verRowNumber = 5;
int horiRowNumber = 10;

CGFloat recWidth = 55; //default is the vertical model;
CGFloat recHeight = 64;
int rowNumber = 5;
CGFloat widthOffset = 5;
CGFloat heightOffset = 5;
CGFloat VerViewWidth = (55 + 5) * 5 + 10;

// View functions -------
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //
    int refViewWidth = self.playingCardBoundView.bounds.size.width;
    
    if (refViewWidth > VerViewWidth) {
        rowNumber = 10;
        recWidth = ((self.playingCardBoundView.bounds.size.width - widthOffset) / rowNumber) - widthOffset;
    }
    else
    {
        rowNumber = 5;
        recWidth = 55;
    }
    
    [self upDateUI];
}

@end

