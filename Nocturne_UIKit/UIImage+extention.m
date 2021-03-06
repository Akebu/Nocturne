#import "../Headers.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (extention)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    /* https://stackoverflow.com/a/14525049 */
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)setTintColor:(UIColor *)color
{
	UIImage *tintedImage = [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	[color set];
	[tintedImage drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	tintedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return tintedImage;
}

- (UIImage *)inverseColors;
{
	/* http://stackoverflow.com/a/22669888 */
	CIImage *coreImage = [CIImage imageWithCGImage:self.CGImage];
	CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
	[filter setValue:coreImage forKey:kCIInputImageKey];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	return [UIImage imageWithCIImage:result scale:self.scale orientation:self.imageOrientation];	
}

- (BOOL)isDark
{
    /* Modified version of http://stackoverflow.com/a/30732543 */
    CGImageRef image = self.CGImage;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    GLubyte * imageData = malloc(width * height * 4);
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * width;
    int bitsPerComponent = 8;
    CGContextRef imageContext =
    CGBitmapContextCreate(
                          imageData, width, height, bitsPerComponent, bytesPerRow, CGImageGetColorSpace(image),
                          kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
                          );

    CGContextSetBlendMode(imageContext, kCGBlendModeCopy);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGContextRelease(imageContext);

    int byteIndex = 0;

    BOOL isDark = YES;
    for ( ; byteIndex < width*height*4; byteIndex += 4) {
        CGFloat red = ((GLubyte *)imageData)[byteIndex]/255.0f;
        CGFloat green = ((GLubyte *)imageData)[byteIndex + 1]/255.0f;
        CGFloat blue = ((GLubyte *)imageData)[byteIndex + 2]/255.0f;

        if( red > 0.5 || green > 0.5 || blue > 0.5){
            isDark = NO;
            break;
        }
    }
    return isDark;
}

@end
