//
//  SetCardView.h
//  Card4
//
//  Created by Harteg Wariyar on 4/13/14.
//  Copyright (c) 2014 Harteg Wariyar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView


@property (nonatomic) NSInteger symbol;
@property (nonatomic) NSInteger number;
@property (nonatomic) NSInteger shade;
@property (nonatomic) NSInteger color;

@property (nonatomic) NSInteger selected;
@property (nonatomic) BOOL hinted;
@property (nonatomic) BOOL faceUp;

@end
