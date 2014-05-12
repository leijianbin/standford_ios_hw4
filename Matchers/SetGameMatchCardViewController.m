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

@interface SetGameMatchCardViewController()

@property (nonatomic,strong)SetGameCard *card;

@property (strong, nonatomic) SetGameCardGame *game;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *setGameScore;

@end

@implementation SetGameMatchCardViewController

- (SetGameCardGame *)game
{
    if (!_game) {
        _game = [[SetGameCardGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    return _game;
}

- (Deck*)createDeck
{
    return [[SetGameCardDeck alloc]init];
}


- (SetGameCard *)card
{
    if (!_card) {
        _card = [[SetGameCard alloc]init];
    }
    return _card;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self upDateUI];
}

- (void)upDateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetGameCard *card = [self.game cardAtIndex:cardButtonIndex];
        NSLog(@"Bool value: %d",card.isChosen);
        [cardButton setAttributedTitle:[card getSetCardContent] forState:UIControlStateNormal];
        if(card.isChosen)
        {
            [cardButton.layer setBorderWidth:3.0];
            [cardButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        } else
        {
            [cardButton.layer setBorderWidth:0];
        }
        cardButton.enabled = !card.isMatched;
    }
    self.setGameScore.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}
- (IBAction)refreshCard {
    self.game = nil;
    [self upDateUI];
}

- (IBAction)touchCard:(UIButton *)sender {

    //[sender setAttributedTitle:[self.card getSetCardContent] forState:UIControlStateNormal];
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self upDateUI];
}

@end
