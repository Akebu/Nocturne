#import "../Headers.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (invertColors)

- (UIImage *)invertColors;
{
	/* http://stackoverflow.com/a/22669888 */
	CIImage *coreImage = [CIImage imageWithCGImage:self.CGImage];
	CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
	[filter setValue:coreImage forKey:kCIInputImageKey];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	return [UIImage imageWithCIImage:result scale:self.scale orientation:self.imageOrientation];	
}
@end