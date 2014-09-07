// Douglas Hill, September 2014
// https://github.com/douglashill/DHDatePicker

#import <Cocoa/Cocoa.h>

@interface DHDatePickerDetailViewController : NSViewController

/// Designated initialiser
- (instancetype)init __attribute((objc_designated_initializer));

@property (nonatomic, copy) NSDate *date;

@end
