//
//  GameResultViewController.m
//  Matchismo3
//
//  Created by Tatiana Kornilova on 11/14/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()

@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortSelector;

@end

@implementation GameResultViewController

- (void)updateUI
{
    NSMutableAttributedString *displayAttributed = [[NSMutableAttributedString alloc] initWithString:@""];;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //---- search max score and min duration ----
    NSArray *resultOrdered = [[GameResult allGameResults] sortedArrayUsingSelector:@selector(compareScoreToGameResult:)];
    GameResult *resultMax =[resultOrdered firstObject];
    int maxScore = resultMax.score;
    resultOrdered = [[GameResult allGameResults] sortedArrayUsingSelector:@selector(compareDurationToGameResult:)];
    resultMax =[resultOrdered firstObject];
    int minDuration = (int)roundf(resultMax.duration);
    //--------------------------------------------
    
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) {
        NSString *displayString = [NSString stringWithFormat:@"%@ Score: %d (%@, %0g)\n", result.gameName, result.score,
                                   [formatter stringFromDate:result.end], round(result.duration)];
        NSMutableAttributedString *scoreAttributed =[[NSMutableAttributedString alloc] initWithString:displayString];
        
        //--- hightlight max score and min duration -----
        if (result.score == maxScore) {
            NSRange rangeBegin = [displayString rangeOfString:@":"];
            NSRange rangeEnd = [displayString rangeOfString:@"("];
            NSRange rangeScoreNumber = NSMakeRange(rangeBegin.location+1, rangeEnd.location-rangeBegin.location-1);
            [scoreAttributed setAttributes: @{NSForegroundColorAttributeName: [UIColor redColor]} range:rangeScoreNumber];
        }
        if ((int)roundf(result.duration) == minDuration) {
            NSRange rangeBegin = [displayString rangeOfString:@"," options:NSBackwardsSearch];
            NSRange rangeEnd = [displayString rangeOfString:@")"];
            NSRange rangeScoreNumber = NSMakeRange(rangeBegin.location+1, rangeEnd.location-rangeBegin.location-1);
            [scoreAttributed setAttributes: @{NSForegroundColorAttributeName: [UIColor redColor]} range:rangeScoreNumber];
        }
        [displayAttributed appendAttributedString:scoreAttributed];
        //----------------------------------------------------
    }
    self.display.attributedText = displayAttributed;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}
#pragma mark - Sorting

@synthesize sortSelector = _sortSelector;  // because we implement BOTH setter and getter

// return default sort selector if none set (by score)

- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareScoreToGameResult:);
    return _sortSelector;
}

// update the UI when changing the sort selector

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}
- (IBAction)sortByDate
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDuration
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

#pragma mark - (Unused) Initialization before viewDidLoad

- (void) setup
{
    //initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

@end
