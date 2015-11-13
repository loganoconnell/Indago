#import "Indago.h"

@implementation IndagoWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestResult = [super hitTest:point withEvent:event];

    if ([hitTestResult isKindOfClass:[self class]]) {
    	return nil;
 	}

	else {
		return hitTestResult;
	}
}
@end