//
//  SetGameMatchCardViewController.m
//  Matchers
//
//  Created by Jianbin Lei on 5/2/14.
//  Copyright (c) 2014 oit. All rights reserved.
//

#import "SetGameMatchCardViewController.h"
#import "SetGameCard.h"
#import "SetGameCardDeck.h"
#import "SetGameCardGame.h"
#import "SetCardView.h"

@interface SetGameMatchCardViewController()

@property (weak, nonatomic) IBOutlet UILabel *setGameScore;
@property (strong, nonatomic) SetGameCardGame *game;
@property (nonatomic,strong) SetCardView *card;
@property (nonatomic,strong) NSMutableArray *setCards;  //of Set Card View
@property (weak, nonatomic) IBOutlet UIView *setGameCardBoundView;

@property (nonatomic) BOOL startNewGame; //if we start a new game;

@end

@implementation SetGameMatchCardViewController

- (SetGameCardGame *)game
{
    if (!_game) {
        _game = [[SetGameCardGame alloc] initWithCardCount:[self.setCards count]
                                                  usingDeck:[self createDeck]];
        [self initSetCards]; //
    }
    return _game;
}

- (Deck*)createDeck
{
    return [[SetGameCardDeck alloc]init];
}


- (SetCardView *)card
{
    if (!_card) {
        _card = [[SetCardView alloc]init];
    }
    return _card;
}

- (NSMutableArray *)setCards
{
    if (!_setCards) {
        _setCards = [[NSMutableArray alloc] init];
    }
    return _setCards;
}


CGFloat recSetWidth = 55;
CGFloat recSetHeight = 64;
int rowSetNumber = 4;
CGFloat setWidthOffset = 5;
CGFloat setHeightOffset = 5;

- (void)upDateUI
{
    //main function

    if (self.game) { //make sure the game already instant
        if (self.startNewGame) { //if we start a new game or just regular UI update
            for(SetCardView *card in self.setCards)
            {
                card.center = CGPointMake(500.0, -1000.0);
                [self.setGameCardBoundView addSubview:card];
            }
            
            for(int i = 0; i < [self initialNumCards]; i++)
            {
                SetCardView *u = self.setCards[i];
                CGFloat x = (i%rowSetNumber) * recSetWidth + ((i%rowSetNumber) + 1) * setWidthOffset;
                CGFloat y = (i/rowSetNumber) * recSetHeight + ((i/rowSetNumber) + 1) * setHeightOffset;
                CGRect frame = CGRectMake(x, y, recSetWidth, recSetHeight);
                
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
        else
        {
            // do other things
            
        }
    }
}

/*
Set Card View:
Color: 
    0 - Red
    1 - Green
    2 - Blue
 
Symbol:
    0 - squiggle
    1 - diamond
    2 - oval
 
Shading:
    0 - empty
    1 - solid
    2 - striped
*/

- (void)initSetCards
{
    for (int i = 0; i < [self initialNumCards]; i++ ) {
        SetGameCard *card = (SetGameCard *)[self.game cardAtIndex:i];
        CGRect frame = CGRectMake(-500, -1000, recSetWidth, recSetHeight);
        SetCardView* cardView = [[SetCardView alloc] initWithFrame:frame];
        cardView.number = card.number;
        
        if([card.shade isEqualToString:@"open"])
            cardView.shade = 0;
        else if([card.shade isEqualToString:@"solid"])
            cardView.shade = 1;
        else
            cardView.shade = 2;
        
        if([card.symbol isEqualToString:@"▲"])
            cardView.symbol = 0;
        else if([card.symbol isEqualToString:@"●"])
            cardView.symbol = 1;
        else
            cardView.symbol = 2;
        
        cardView.faceUp = NO;
        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(swipe:)]];
        [self.setCards addObject:cardView];
    }

    //
    [self upDateUI];
}

// gestures ------

- (IBAction)swipe:(UITapGestureRecognizer *)sender
{
    SetCardView *sc = (SetCardView *)sender.view;
    
    //__weak ViewController *weakSelf = self;
    [UIView transitionWithView:sc
                      duration:0.25
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        sc.faceUp = !sc.faceUp;
                    }
                    completion:nil];
    
    [self selectCard:sc];
    //self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

- (void) selectCard:(UIView *)view
{
    NSUInteger index = [self.setCards indexOfObject:view];
    NSLog(@"selectCard: index=%tu",index);
    SetCardView * scv = (SetCardView *) view;
    NSLog(@"selectCard: number=%d, symbol =%d, shade =%d, color =%d,",scv.number, scv.symbol,scv.shade, scv.color);
    //SetGameCard * card = (SetGameCard *)[self.game cardAtIndex:index];
    //NSLog(@"Real Card: suit=%@, rank =%d",card.number, card.rank);
    
    // if we're not dynamic-animating, then let's play the game
    
    [self.game chooseCardAtIndex:index];
    //self.panPhase = FALSE; self.pinchPhase = FALSE; self.tapPhase = FALSE;
    [self upDateUI];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startNewGame = YES;
    [self upDateUI];
}

- (IBAction)refrenshCard:(UIButton *)sender {
    self.setCards = nil;
    self.game = nil;
    self.startNewGame = YES;
    
    [self upDateUI];
}


- (NSInteger) initialNumCards
{
    return 16;
}

// View functions -------
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self upDateUI];
}

@end
