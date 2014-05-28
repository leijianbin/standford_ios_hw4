//
//  SetCardView.m
//  Card4
//
//  Created by Harteg Wariyar on 4/13/14.
//  Copyright (c) 2014 Harteg Wariyar. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setup];
    return self;
}

- (void) setShade:(NSInteger)shade
{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void) setSymbol:(NSInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void) setColor:(NSInteger)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void) setNumber:(NSInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

static float PCT_INSET = 0.1;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Set Card Drawing code
    
    CGContextRef ref0 = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref0);
    
    // set a nice background
    UIBezierPath *cardPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) cornerRadius:20.0];
    
    UIColor *shapeColor = [UIColor whiteColor];
    [shapeColor setFill];
    [cardPath fill];
    [cardPath addClip];
    
    // let's see what kind of card we have...
    //NSLog(@"color=%d,symbol=%d,shade=%d,number=%d",self.color,self.symbol,self.shade,self.number);
    if(self.color == 0)
        shapeColor = [UIColor redColor];
    else if(self.color == 1)
        shapeColor = [UIColor greenColor];
    else
        shapeColor = [UIColor blueColor];
    
    NSInteger numberOfCards = self.number+1;
    
    CGFloat cardWidth = (1 - PCT_INSET*2) * self.bounds.size.width;
    CGFloat cardHeight = (1 - PCT_INSET*2)* self.bounds.size.height;
    
    // regardless of number of shapes, height is same
    CGFloat shapeWindowHeight = cardHeight / 3;
    
    // to keep shape centered within view, regardless of number - so offset within view, based on
    // number of shapes present.
    CGFloat subDivHeight = cardHeight / numberOfCards;
    
    // draw shape "number of cards" times
    for(int i = 1; i <= numberOfCards; i++) {
        //NSLog(@"i=%d",i);
        CGContextRef ref = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ref);
        
        CGFloat topLeftX = PCT_INSET*self.bounds.size.width;
        CGFloat topLeftY = (PCT_INSET*self.bounds.size.height)+
            subDivHeight*(i - 1) + subDivHeight/2 + ((-1)*shapeWindowHeight/2);
        
        CGRect shapeRect = CGRectMake(topLeftX, topLeftY, cardWidth, shapeWindowHeight);
        //NSLog(@"topleftX=%f, topleftY=%f, cardWidth=%f, shapeWindowHeight=%f",
         //     topLeftX,topLeftY,cardWidth,shapeWindowHeight);
        
        UIBezierPath *path;
        switch (self.symbol) {
            case 0: {
               // NSLog(@"squiggle");
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(topLeftX, topLeftY + shapeRect.size.height*0.9)];
                [path addQuadCurveToPoint:CGPointMake(topLeftX+shapeRect.size.width/2, topLeftY)
                             controlPoint:CGPointMake(0, topLeftY)];
                [path addQuadCurveToPoint:CGPointMake(topLeftX + shapeRect.size.width,
                                                      topLeftY + shapeRect.size.height*0.1)
                             controlPoint:CGPointMake(topLeftX + shapeRect.size.width/2,
                                                      topLeftY + shapeRect.size.height*0.65)];
                [path addQuadCurveToPoint:CGPointMake(topLeftX + shapeRect.size.width/2,
                                                      topLeftY + shapeRect.size.height)
                             controlPoint:CGPointMake(topLeftX + shapeRect.size.width,
                                                      topLeftY + shapeRect.size.height)];
                [path addQuadCurveToPoint:CGPointMake(topLeftX, topLeftY + shapeRect.size.height*0.9)
                             controlPoint:CGPointMake(topLeftX + shapeRect.size.width/2,
                                                      topLeftY + shapeRect.size.height*0.35)];
                [path closePath];
                
                break;
            }
            case 1: {
               // NSLog(@"diamond");
                path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(topLeftX, topLeftY + shapeRect.size.height/2)];
                [path addLineToPoint:CGPointMake(topLeftX + shapeRect.size.width/2, topLeftY)];
                [path addLineToPoint:CGPointMake(topLeftX + shapeRect.size.width, topLeftY + shapeRect.size.height/2)];
                [path addLineToPoint:CGPointMake(topLeftX + shapeRect.size.width/2,
                                                 topLeftY + shapeRect.size.height)];
                [path closePath];
                break;
            }
            case 2: {
               // NSLog(@"oval");
                path = [UIBezierPath bezierPathWithOvalInRect:shapeRect];
                break;
            }
            default:
                break;
        }
        
        [shapeColor setStroke];
        [path stroke];
        [path addClip];
        
        // shading
        // 0 empty, 1 solid, 2 striped
        if (self.shade == 1) {   // solid
            [shapeColor setFill];
            [path fill];
        }
        else if (self.shade == 2) {  // striped
            int numStripes = 10;
            CGFloat botLeftY = (PCT_INSET * self.bounds.size.height)+subDivHeight*(i - 1) + subDivHeight; ///2 + shapeWindowHeight / 2;
            CGFloat stripeWidth = cardWidth / numStripes;
            for (int j = 0; j < numStripes; j++) {
                [path moveToPoint:CGPointMake(topLeftX + j*stripeWidth, botLeftY)];
                [path addLineToPoint:CGPointMake(topLeftX + (j+1)*stripeWidth, topLeftY)];
            }
            [shapeColor setStroke];
            [path stroke];
        }
        
        
        CGContextRestoreGState(ref);
    }  // end for - draw next one...

    // are we highlighted
    CGContextRestoreGState(ref0);

    if(self.selected) {
        UIBezierPath *selPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
        UIColor *selColor = [UIColor yellowColor];
        [selColor setStroke];
        selPath.lineWidth = PCT_INSET * MIN(self.bounds.size.width, self.bounds.size.height);
        [selPath stroke];
    }
    
    if(self.hinted) {
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:
                                CGRectMake(self.bounds.size.width - 10, 0, 10, 10)];
        UIColor *selColor = [UIColor redColor];
        [selColor setFill];
        [circle fill];
    }
    
}

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}


- (void)awakeFromNib //view cycle
{
    [self setup];
}


@end
