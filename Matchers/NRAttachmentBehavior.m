//
//  NRAttachmentBehavior.m
//  CGPlay1
//
//  Created by Harteg Wariyar on 4/6/14.
//  Copyright (c) 2014 Harteg Wariyar. All rights reserved.
//

#import "NRAttachmentBehavior.h"

@interface NRAttachmentBehavior()
@property UIDynamicItemBehavior *d;

@end


@implementation NRAttachmentBehavior

- (instancetype) init
{
    self = [super init];
    
    UIDynamicItemBehavior *d = [[UIDynamicItemBehavior alloc] init];
    d.allowsRotation = NO;
    
    [self addChildBehavior:d];
    
    return self;
}


// only for dynamic item behavior.  hmm.. not sure why uiattachmentbehavior
// doesn't have addItem, maybe to enforce 1 item setup at initialization
- (void) addItem:(id<UIDynamicItem>) item
{
    [self.d addItem:item];
}

- (void) setAtt:(UIAttachmentBehavior *)att
{
    _att = att;
    [self addChildBehavior:att];
}

@end
