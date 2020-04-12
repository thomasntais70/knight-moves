//
//  chessBoardView.h
//  knight-move
//
//  Created by Thomas Ntais on 8/4/20.
//  Copyright © 2020 Thomas Ntais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface chessBoardView : UIView
{
    CGContextRef ctx;
    int8_t numOfLines;
    CGFloat lineWidth;
    CGFloat totalWidth;
}

@property int boardSize;
@property CGPoint startPoint;
@property CGPoint endPoint;

@property CGFloat rectWidth;

@property BOOL drawBoard;
@property BOOL drawStart;
@property BOOL drawEnd;
@property BOOL drawanim;

@property Point movesStartPoint;
@property Point movesEndPoint;

@property int animationCounter;

@property NSArray *movesAllowed;

@property NSMutableArray * moveSolutions;

@property UIImageView *knight;

- (void)drawStartRect:(CGPoint)point;
- (void)drawEndRect:(CGPoint)point;
- (void)drawChessBoardWithBoardWidth:(CGFloat)totalWidth lineWidth:(CGFloat)lineWidth rectWidth:(CGFloat)rectWidth;
- (void)drawBoardRectswithRectWidth:(CGFloat)rectWidth andlineWidth:(CGFloat)lineWidth;
- (void)drawBordersWithBoardWidth:(CGFloat)totalWidth andLineWidth:(CGFloat)lineWidth;
- (void)drawLinefromPoint:(CGPoint)start toPoint:(CGPoint)end withColor:(UIColor *)color andWidth:(CGFloat)width;
- (void)drawRect:(CGRect)rect withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
- (void)drawAnimations;
- (Point)getPointFromNSArray:(NSArray *)array ;

@end

NS_ASSUME_NONNULL_END
