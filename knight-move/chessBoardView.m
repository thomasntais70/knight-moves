//
//  chessBoardView.m
//  knight-move
//
//  Created by Thomas Ntais on 8/4/20.
//  Copyright © 2020 Thomas Ntais. All rights reserved.
//

#import "chessBoardView.h"
#include "ViewController.h"

@implementation chessBoardView

@synthesize boardSize;
@synthesize startPoint;
@synthesize endPoint;

@synthesize rectWidth;

@synthesize drawStart;
@synthesize drawEnd;
@synthesize drawanim;

@synthesize movesStartPoint;
@synthesize movesEndPoint;

@synthesize animationCounter;

@synthesize movesAllowed;

@synthesize moveSolutions;

@synthesize knight;

- (void)drawRect:(CGRect)rect {
    // Drawing code

    totalWidth = CGRectGetWidth(rect);
    
    numOfLines = 2; // the count of lines for borders (x and y
    lineWidth = 4.0;
    rectWidth = totalWidth / boardSize;
    
    // Get context and clear it
    ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    // Fill with color
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillRect(ctx, rect);
    
    // draw board
    [self drawChessBoardWithBoardWidth:totalWidth lineWidth:lineWidth rectWidth:rectWidth];
    
    if(drawStart || drawEnd) {
        [self drawStartRect:startPoint];
 
    }
    if(drawEnd) {
        [self drawEndRect:endPoint];
    }
    if(drawanim) {
        knight = [[UIImageView alloc] init];
        knight.image = [UIImage imageNamed:@"knight.png"];
        [self addSubview:knight];
        animationCounter = 0;
        
        [self drawAnimations];
        drawanim = NO;
        drawStart = NO;
        drawEnd = NO;
    }
}

- (void)drawStartRect:(CGPoint)point {
    short x = point.x/rectWidth;
    short y = point.y/rectWidth;
    movesStartPoint.h = x;
    movesStartPoint.v = y;
    
    CGRect newRect;
    newRect.origin.x = x * rectWidth;
    newRect.origin.y = y * rectWidth;
    newRect.size.height = rectWidth;
    newRect.size.width = rectWidth;
    
    [self drawRect:newRect withRed:0.0 andGreen:1.0 andBlue:0.0];
}

- (void)drawEndRect:(CGPoint)point {
    short x = point.x/rectWidth;
    short y = point.y/rectWidth;
    movesEndPoint.h = x;
    movesEndPoint.v = y;
    
    CGRect newRect;
    newRect.origin.x = x * rectWidth;
    newRect.origin.y = y * rectWidth;
    newRect.size.height = rectWidth;
    newRect.size.width = rectWidth;
    
    [self drawRect:newRect withRed:1.0 andGreen:0.0 andBlue:0.0];
}

- (void)drawChessBoardWithBoardWidth:(CGFloat)totalWidth lineWidth:(CGFloat)lineWidth rectWidth:(CGFloat)rectWidth{
    
    [self drawBoardRectswithRectWidth:rectWidth andlineWidth:lineWidth];
    [self drawBordersWithBoardWidth:totalWidth andLineWidth:lineWidth];
    
}

- (void)drawBoardRectswithRectWidth:(CGFloat)rectWidth andlineWidth:(CGFloat)lineWidth {
    
    BOOL isWhite = YES;
    for (int i=0; i<boardSize; i++) {
        for(int j=0; j<boardSize; j++) {
            CGRect newRect;
            newRect.origin.x = 0 + j * rectWidth;
            newRect.origin.y = 0 + i * rectWidth;
            newRect.size.height = rectWidth;
            newRect.size.width = rectWidth;
            
            if(isWhite) {
                [self drawRect:newRect withRed:1.0 andGreen:1.0 andBlue:1.0];
                isWhite = NO;
            }
            else {
                [self drawRect:newRect withRed:0.0 andGreen:0.0 andBlue:0.0];
                isWhite = YES;
            }
        }
        if((boardSize % 2) == 0) {
            isWhite = !isWhite;
        }
    }
}

- (void)drawBordersWithBoardWidth:(CGFloat)totalWidth andLineWidth:(CGFloat)lineWidth {

    [self drawLinefromPoint:CGPointMake(1.0, 1.0) toPoint:CGPointMake(totalWidth, 1.0) withColor:[UIColor blackColor] andWidth:lineWidth];
    [self drawLinefromPoint:CGPointMake(totalWidth, 1.0) toPoint:CGPointMake(totalWidth, totalWidth) withColor:[UIColor blackColor] andWidth:lineWidth];
    [self drawLinefromPoint:CGPointMake(totalWidth, totalWidth) toPoint:CGPointMake(1.0, totalWidth) withColor:[UIColor blackColor] andWidth:lineWidth];
    [self drawLinefromPoint:CGPointMake(1.0, totalWidth) toPoint:CGPointMake(1.0, 1.0) withColor:[UIColor blackColor] andWidth:lineWidth];
}

- (void)drawLinefromPoint:(CGPoint)start toPoint:(CGPoint)end withColor:(UIColor *)color andWidth:(CGFloat)width {

    CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
    CGContextSetLineWidth(ctx, width);
    CGContextMoveToPoint(ctx, start.x, start.y);
    CGContextAddLineToPoint(ctx, end.x, end.y);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)drawRect:(CGRect)rect withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {

    CGContextSetRGBFillColor(ctx, red, green, blue, 1.0);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0);
    CGContextFillRect(ctx, rect);
}

- (void)drawAnimations {
    NSMutableArray * move = [moveSolutions objectAtIndex:animationCounter];
    Point firstPoint = [self getPointFromNSArray:(NSArray *)[move objectAtIndex:0]];
    Point secondPoint = [self getPointFromNSArray:(NSArray *)[move objectAtIndex:1]];

    CGRect board = knight.frame;
    board.size.width = rectWidth;
    board.size.height = rectWidth;
    board.origin.x = movesStartPoint.h * rectWidth;
    board.origin.y = movesStartPoint.v * rectWidth;
    knight.frame = board;

    [UIView animateWithDuration:2.0 animations:^{
        self.knight.frame = CGRectMake(self.rectWidth * firstPoint.h, self.rectWidth * firstPoint.v, self.rectWidth, self.rectWidth);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            self.knight.frame = CGRectMake(self.rectWidth * secondPoint.h, self.rectWidth * secondPoint.v, self.rectWidth, self.rectWidth);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:2.0 animations:^{
                self.knight.frame = CGRectMake(self.rectWidth * self.movesEndPoint.h, self.rectWidth * self.movesEndPoint.v, self.rectWidth, self.rectWidth);
            } completion:^(BOOL finished){
                UIViewKeyframeAnimationOptions anOptions = UIViewKeyframeAnimationOptionCalculationModeLinear;
                [UIView animateKeyframesWithDuration:0.0 delay:0.0 options:anOptions animations:^(void){
                    self.knight.frame = CGRectMake(self.rectWidth * self.movesStartPoint.h, self.rectWidth * self.movesStartPoint.v, self.rectWidth, self.rectWidth);
                } completion:^(BOOL finished) {
                    [self repeatWithNextAnimation];
                }];
            }];
        }];
    }];
}

- (void)repeatWithNextAnimation {
    animationCounter++;
    
    if(animationCounter <moveSolutions.count) {
        [self drawAnimations];
    } else {
        [knight removeFromSuperview];
        ViewController *sV = (ViewController *)[self viewController];
        sV.textLabel.text = @"Press Clear button to start";
        [sV.clearButton setUserInteractionEnabled:YES];
    }
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

- (Point)getPointFromNSArray:(NSArray *)array {
    Point point;
    point.h = 0;
    point.v = 0;
    if(array.count == 2) {
        point.h = [[array objectAtIndex:0] intValue];
        point.v = [[array objectAtIndex:1] intValue];
    }

    return point;
}


@end
