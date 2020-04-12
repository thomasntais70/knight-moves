//
//  ViewController.m
//  knight-move
//
//  Created by Thomas Ntais on 8/4/20.
//  Copyright © 2020 Thomas Ntais. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize chessBoardImageView;
@synthesize selSizePicker;
@synthesize labelSizesText;
@synthesize textLabel;
@synthesize movesAllowed;
@synthesize clearButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect parentViewBounds = self.view.bounds;

    float viewWidth = parentViewBounds.size.width;
    float viewHeight = parentViewBounds.size.height;
    
    // create chess board
    chessBoardImageView = [[chessBoardView alloc] init];
    
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    [chessBoardImageView addGestureRecognizer:singleFingerTap];
    [self.view addSubview:chessBoardImageView];
    CGRect board = chessBoardImageView.frame;
    board.size.width = viewWidth;
    board.size.height = viewWidth;
    board.origin.x = 0.0;
    board.origin.y =(viewHeight - viewWidth) / 2.0;
    chessBoardImageView.frame = board;
    
    // set size
    chessBoardImageView.boardSize = 6;
    
    startSelected = NO;
    endSelected = NO;
    
    self.selSizePicker.dataSource = self;
    self.selSizePicker.delegate = self;
    
    sizes = @[@"6x6", @"7x7", @"8x8", @"9x9", @"10x10", @"11x11", @"12x12", @"13x13", @"14x14", @"15x15", @"16x16"];

    textLabel.text = @"Select start rectangle";
    
    [self initializeMovesAllowed];
    
    moveSolutions = [[NSMutableArray alloc] init];
}


//The tap event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    if(!startSelected) {
        chessBoardImageView.startPoint = location;
        chessBoardImageView.drawStart = YES;
        [chessBoardImageView setNeedsDisplay];
        startSelected = YES;
        textLabel.text = @"Select end rectangle";
    } else if(!endSelected){
        chessBoardImageView.endPoint = location;
        chessBoardImageView.drawEnd = YES;
        [chessBoardImageView setNeedsDisplay];
        endSelected = YES;
        textLabel.text = @"Press GO! button";
        [[self goButton] setUserInteractionEnabled:YES];
    }
    if(startSelected || endSelected) {
        [selSizePicker setUserInteractionEnabled:NO];
    } else {
        [selSizePicker setUserInteractionEnabled:YES];
    }
}


// Picker datasource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return sizes.count;
}

// delegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return sizes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.labelSizesText.text = sizes[row];
    if(!startSelected && !endSelected) {
        chessBoardImageView.boardSize = (int)row + 6;
        [chessBoardImageView setNeedsDisplay];
    }
}

//
- (void)initializeMovesAllowed {
    movesAllowed = @[@[@1,@2], @[@1,@-2], @[@2,@1], @[@2,@-1], @[@-1,@2], @[@-1,@-2], @[@-2,@1], @[@-2,@-1]];
}

- (IBAction)clearSelections:(id)sender {
    startSelected = NO;
    endSelected = NO;
    [selSizePicker setUserInteractionEnabled:YES];
    [[self goButton] setUserInteractionEnabled:NO];
    chessBoardImageView.drawStart = NO;
    chessBoardImageView.drawEnd = NO;
    chessBoardImageView.drawanim = NO;
    [chessBoardImageView setNeedsDisplay];
    textLabel.text = @"Select start rectangle";
    [moveSolutions removeAllObjects];
}

- (IBAction)startMoving:(id)sender {
    Point start = chessBoardImageView.movesStartPoint;
    Point end = chessBoardImageView.movesEndPoint;
    [moveSolutions removeAllObjects];
    [chessBoardImageView.moveSolutions removeAllObjects];
    
    [[self clearButton] setUserInteractionEnabled:NO];
    [[self goButton] setUserInteractionEnabled:NO];
    if(![self checkDistance:start withEnd:end]) {
        return;
    }

    for(int firstMove=0; firstMove<8; firstMove++) {
        if([self cannotMoveFrom:start withMovesAllowedIndex:firstMove]) {
            continue;
        }
        Point firstPoint = [self move:start withMovesAllowedIndex:firstMove];
    
        for(int secondMove=0; secondMove<8; secondMove++) {
            if([self cannotMoveFrom:firstPoint withMovesAllowedIndex:secondMove]) {
                continue;
            }
            Point secondPoint = [self move:firstPoint withMovesAllowedIndex:secondMove];
            for(int thirdMove=0; thirdMove<8; thirdMove++) {
                if([self cannotMoveFrom:secondPoint withMovesAllowedIndex:thirdMove]) {
                    continue;
                }
                Point thirdPoint = [self move:secondPoint withMovesAllowedIndex:thirdMove];
                if(thirdPoint.h == end.h && thirdPoint.v == end.v) {
                    NSMutableArray *solution = [[NSMutableArray alloc] init];
                    [solution addObject:[self addPointToArray:firstPoint]];
                    [solution addObject:[self addPointToArray:secondPoint]];
                    
                    [moveSolutions addObject:solution];
                }
            }
        }
    }
    if(moveSolutions.count == 0) {
        [self noSolutionFoundMessage];
    } else {
        chessBoardImageView.moveSolutions = moveSolutions;
        chessBoardImageView.drawanim = YES;
        [chessBoardImageView setNeedsDisplay];
    }
}

- (BOOL)checkDistance:(Point)start withEnd:(Point)end {
    
    if(![self isFarAwayFromStart:start withEnd:end]) {
        [self noSolutionFoundMessage];
        return false;
    }
    
    return true;
}

- (void)noSolutionFoundMessage {
    UIAlertController *noSolutionAlertController = [UIAlertController alertControllerWithTitle:@"Knight moves"
                                                              message: @"No solution found"
                                                              preferredStyle:UIAlertControllerStyleAlert                   ];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                [noSolutionAlertController dismissViewControllerAnimated:YES completion:nil];
                                    [[self clearButton] setUserInteractionEnabled:YES];
                                    [[self goButton] setUserInteractionEnabled:YES];
                              }
                               ];
    [noSolutionAlertController addAction: okAction];

    [self presentViewController:noSolutionAlertController animated:YES completion:nil];
}

// Assuming that at start and every move the knight is at the same point in each rectangle e.g. at the center
// then for each move the distance from start to end is the hypotenuse of a triangle with sides 1 and 2.
// This gives a distance of movement for one point to another which is square root of the sum (1^2 + 2^2).
// The result of this is a distance SQRT(5). So the maximum distance for 3 moves is 3*SQRT(5), (when all moves are e.g. 2,1/2,1/2,1;in other cases this is less than this number)
// Assuming this if a distance from start to end point after 3 moves is greater than 3*SQRT(5)+1, then it
// can go there with only 3 moves there is no need to search for paths and we return false.
// If the distance is less than this number we return true in order to serach the paths if the knight can move
// from start to end with 3 moves
- (BOOL)isFarAwayFromStart:(Point)start withEnd:(Point)end {
    int absh = abs(start.h-end.h);
    int absv = abs(start.v-end.v);
    
    float hypotenuse = sqrt(pow(absh,2.0)+pow(absv,2.0));
    if(hypotenuse >= (3*sqrt(5)+1)) {
        return false;
    }
    
    return true;
}

- (BOOL)cannotMoveFrom:(Point)start withMovesAllowedIndex:(int)index {
    Point end;
    if(index < 0 || index > 8) {
        return true;
    }
    NSArray *distances = [movesAllowed objectAtIndex:index];
    
    int v = [[distances objectAtIndex:0] intValue];
    int h = [[distances objectAtIndex:1] intValue];
    
    end.v = start.v + v;
    end.h = start.h + h;
    
    int f = chessBoardImageView.boardSize;
    
    if((end.v < 0) ||
       (end.v > (f - 1)) ||
       (end.h < 0) ||
       (end.h >(f-1))) {
        return true;
    }
    
    return false;
}

- (Point)move:(Point)start withMovesAllowedIndex:(int)index {
    Point end;
    if(index < 0 || index > 8) {
        return start;
    }
    NSArray *distances = [movesAllowed objectAtIndex:index];
    
    int v = [[distances objectAtIndex:0] intValue];
    int h = [[distances objectAtIndex:1] intValue];
    
    end.v = start.v + v;
    end.h = start.h + h;
    
    return end;
}

- (NSArray *)addPointToArray:(Point)point {
    NSArray * arrayWithPoint = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:point.h], [NSNumber numberWithInt:point.v], nil];
    
    return arrayWithPoint;
    
}

@end
