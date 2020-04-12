//
//  ViewController.h
//  knight-move
//
//  Created by Thomas Ntais on 8/4/20.
//  Copyright © 2020 Thomas Ntais. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "chessBoardView.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray * moveSolutions;
    NSArray *sizes;
    BOOL startSelected;
    BOOL endSelected;
}

@property NSArray *movesAllowed;

@property chessBoardView *chessBoardImageView;
@property (weak, nonatomic) IBOutlet UIPickerView *selSizePicker;
@property (weak, nonatomic) IBOutlet UILabel *labelSizesText;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

- (IBAction)startMoving:(id)sender;
- (IBAction)clearSelections:(id)sender;



- (void)initializeMovesAllowed;
- (BOOL)checkDistance:(Point)start withEnd:(Point)end;
- (void)noSolutionFoundMessage;
- (BOOL)isFarAwayFromStart:(Point)start withEnd:(Point)end;
- (BOOL)cannotMoveFrom:(Point)start withMovesAllowedIndex:(int)index;
- (Point)move:(Point)start withMovesAllowedIndex:(int)index;
- (NSArray *)addPointToArray:(Point)point;
@end

