// Douglas Hill, September 2014
// https://github.com/douglashill/DHDatePicker

#import "DHDatePickerDetailViewController.h"

@interface DHDatePickerDetailViewController ()

@property (nonatomic, weak) IBOutlet NSDatePicker *datePicker;

@end

@implementation DHDatePickerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSLog(@"Incorrect initialiser “%s” sent to %@", __PRETTY_FUNCTION__, [self class]);
	return [self init];
}

- (instancetype)init {
	self = [super initWithNibName:@"DHDatePickerDetail" bundle:[NSBundle bundleForClass:[self class]]];
	return self;
}

- (void)setDate:(NSDate *)date {
	if ([date isEqualToDate:_date]) return;
	
	_date = date;
	[[self datePicker] setDateValue:date];
}

- (IBAction)dateChanged:(id)sender {
	[self setDate:[[self datePicker] dateValue]];
}

- (IBAction)setToNow:(id)sender {
	[self setDate:[NSDate date]];
}

- (IBAction)clearDate:(id)sender {
	[self setDate:nil];
}

@end
