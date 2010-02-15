/*  This code is based on Apple's "GeekGameBoard" sample code, version 1.0.
    http://developer.apple.com/samplecode/GeekGameBoard/
    Copyright © 2007 Apple Inc. Copyright © 2008 Jens Alfke. All Rights Reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted
    provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions
      and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials provided
      with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
    FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRI-
    BUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
#import "Piece.h"
#import "QuartzUtils.h"


@implementation Piece


- (id) init
{
    self = [super init];
    if (self != nil) {
        self.zPosition = kPieceZ;
    }
    return self;
}



- (id) initWithImageNamed: (NSString*)imageName
                    scale: (CGFloat)scale
{
    self = [self init];
    if (self != nil) {
        [self setImageNamed: imageName scale: scale];
    }
    return self;
}


- (id) copyWithZone: (NSZone*)zone
{
    Piece *clone = [super copyWithZone: zone];
    clone.imageName = self.imageName;
    return clone;
}


- (void) dealloc
{
    [_imageName release];
    [super dealloc];
}


- (NSString*) description
{
    return [NSString stringWithFormat: @"%@[%@]", 
            [self class],
            _imageName.lastPathComponent.stringByDeletingPathExtension];
}


@synthesize imageName=_imageName;


- (void) _setImage: (CGImageRef)image
{
    self.contents = (id) image;
    self.bounds = CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image));
    self.contentsGravity = kCAGravityResizeAspect;
    self.minificationFilter = kCAFilterLinear;
    self.imageName = nil;
}


- (void) setImage: (CGImageRef)image scale: (CGFloat)scale
{
    [self _setImage: CreateScaledImage(image,scale)];
}

- (void) setImageNamed: (NSString*)imageName scale: (CGFloat)scale
{
    [self _setImage: GetScaledImageNamed(imageName,scale)];
    self.imageName = imageName;
}

- (void) setImage: (CGImageRef)image
{
    CGSize size = self.bounds.size;
    [self setImage: image scale: MAX(size.width,size.height)];
}

- (void) setImageNamed: (NSString*)name
{
    [self setImage: GetCGImageNamed(name)];
    self.imageName = name;
}


- (BOOL)containsPoint:(CGPoint)p
{
    // Overrides CGLayer's implementation,
    // returning YES only for pixels at which this layer's alpha is at least 0.5.
    // This takes into account the opacity, bg color, and background image's alpha channel.
    if( ! [super containsPoint: p] )
        return NO;
    float opacity = self.opacity;
    if( opacity < 0.5 )
        return NO;
    float thresholdAlpha = 0.5 / self.opacity;
    
    CGColorRef bg = self.backgroundColor;
    float alpha = bg ?CGColorGetAlpha(bg) :0.0;
    if( alpha < thresholdAlpha ) {
        CGImageRef image = (CGImageRef)self.contents;
        if( image ) {
            // Note: This makes the convenient assumption that the image entirely fills the bounds.
            alpha = MAX(alpha, GetPixelAlpha(image, self.bounds.size, p));
        }
    }
    return alpha >= thresholdAlpha;
}


#if ! TARGET_OS_IPHONE

// An image from another app can be dragged onto a Piece to change its background pattern.

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if( CanGetCGImageFromPasteboard([sender draggingPasteboard]) )
        return NSDragOperationCopy;
    else
        return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    CGImageRef image = GetCGImageFromPasteboard([sender draggingPasteboard],sender);
    if( image ) {
        [self setValue: (id)image ofStyleProperty: @"contents"];
        return YES;
    } else
        return NO;
}

#endif


@end
