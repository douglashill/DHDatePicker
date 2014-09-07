// Douglas Hill, September 2014
// https://github.com/douglashill/DHDatePicker

#import "DHDatePicker.h"

#import "DHDatePickerDetailViewController.h"

static void *const detailDateObservationContext = (void *)&detailDateObservationContext;

@interface DHDatePicker ()

@property (nonatomic, getter = isPopoverPresentationInProgress) BOOL popoverPresentationInProgress;
@property (nonatomic, strong, readonly) DHDatePickerDetailViewController *detail;
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) NSPopover *popover;

@end

@implementation DHDatePicker {
	DHDatePickerDetailViewController *_detail;
	NSDateFormatter *_dateFormatter;
	NSPopover *_popover;
}

- (void)dealloc {
    [_detail removeObserver:self forKeyPath:NSStringFromSelector(@selector(date)) context:detailDateObservationContext];
}

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
	if (self == nil) return nil;
	
	[self shared_initialisation];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self == nil) return nil;
	
	[self shared_initialisation];
	
	return self;
}

- (void)shared_initialisation {
	[self setFormatter:[self dateFormatter]];
}

- (void)setObjectValue:(id<NSCopying, NSObject>)obj {
	if ([obj isEqual:[self objectValue]]) return;
	
	if (obj == nil) {
		[[self popover] close];
		[self setFormatter:nil];
	}
	else {
		[self setFormatter:[self dateFormatter]];
	}
	
	[super setObjectValue:obj];
}

- (BOOL)becomeFirstResponder {
	// Calling super causes all kinds of chaos.
	
	NSLog(@"%s START", __PRETTY_FUNCTION__);
	
	[self showDetail];
	
	NSLog(@"%s END", __PRETTY_FUNCTION__);
	return NO;
}

- (BOOL)resignFirstResponder {
	NSLog(@"%s START", __PRETTY_FUNCTION__);
	
	if ([self isPopoverPresentationInProgress]) {
		return NO;
	}
	
	[[self popover] close];
	
	NSLog(@"%s END", __PRETTY_FUNCTION__);
	return [super resignFirstResponder];
}

- (void)showDetail {
	[self setPopoverPresentationInProgress:YES];
	
	id const value = [self objectValue];
	[[self detail] setDate:[value isKindOfClass:[NSDate class]] ? value : [NSDate date]];
	[[self popover] showRelativeToRect:[self bounds] ofView:self preferredEdge:NSMaxXEdge];
	
	[self setPopoverPresentationInProgress:NO];
}

#pragma mark - Lazy loading

- (DHDatePickerDetailViewController *)detail {
	if (_detail) return _detail;
	
	_detail = [[DHDatePickerDetailViewController alloc] init];
	[_detail addObserver:self forKeyPath:NSStringFromSelector(@selector(date)) options:NSKeyValueObservingOptionNew context:detailDateObservationContext];
	
	return _detail;
}

- (NSDateFormatter *)dateFormatter {
	if (_dateFormatter) return _dateFormatter;
	
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	return _dateFormatter;
}

- (NSPopover *)popover {
	if (_popover) return _popover;
	
	_popover = [[NSPopover alloc] init];
	[_popover setBehavior:NSPopoverBehaviorTransient];
	[_popover setContentViewController:[self detail]];
	
	return _popover;
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == detailDateObservationContext) {
		[self setObjectValue:[[self detail] date]];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
