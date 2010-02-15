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
#import "Card.h"
#import "GGBTextLayer.h"
#import "QuartzUtils.h"


@implementation Card


static CGSize sCardSize = {100,150};

static CATransform3D kFaceUpTransform, kFaceDownTransform;

+ (void) initialize
{
    if( self==[Card class] ) {
        kFaceUpTransform = kFaceDownTransform = CATransform3DIdentity;
        // Construct a 180-degree rotation matrix:
        kFaceDownTransform.m11 = kFaceDownTransform.m33 = -1;
        // The more obvious way to create kFaceDownTransform would be to call
        // CATransform3DMakeRotation(pi,0,1,0), but due to round-off errors, that transform
        // will have non-zero values in some other places, making it appear to CA as a true
        // 3D transform; this will then cause unexpected clipping behaviors when used.
    }
}


+ (NSRange) serialNumberRange;
{
    NSAssert1(NO,@"%@ forgot to override +serialNumberRange",self);
    return NSMakeRange(0,0);
}


+ (CGSize) cardSize                 {return sCardSize;}
+ (void) setCardSize: (CGSize)size  {sCardSize = size;}


- (id) initWithSerialNumber: (int)serial position: (CGPoint)pos
{
    self = [super init];
    if (self != nil) {
        _serialNumber = serial;
        self.bounds = CGRectMake(0,0,sCardSize.width,sCardSize.height);
        self.position = pos;
        self.edgeAntialiasingMask = 0;
        _back = [self createBack];
        [self addSublayer: _back];
        _front = [self createFront];
        _front.transform = kFaceDownTransform;
        [self addSublayer: _front];
    }
    return self;
}


- (id) copyWithZone: (NSZone*)zone
{
    Card *clone = [super copyWithZone: zone];
    clone->_serialNumber = _serialNumber;
    return clone;
}


- (NSString*) description
{
    return [NSString stringWithFormat: @"%@[#%i]",self.class,_serialNumber];
}


@synthesize serialNumber=_serialNumber;


- (BOOL) faceUp
{
    return _faceUp;
}

- (void) setFaceUp: (BOOL)up
{
    if( up != _faceUp ) {
        // The Card has separate sub-layers for its front and back. At any time, one of them
        // is hidden, by having a 180 degree rotation about the Y axis.
        // To flip the card, both front and back layers are flipped over.
        CATransform3D xform;
        xform = up ?kFaceUpTransform :kFaceDownTransform;
        _front.transform = xform;
        
        xform = up ?kFaceDownTransform :kFaceUpTransform;
        _back.transform = xform;
        _faceUp = up;
    }
}


- (GGBLayer*) createFront
{
    GGBLayer *front = [[GGBLayer alloc] init];
    front.bounds = CGRectMake(0,0,sCardSize.width,sCardSize.height);
    front.position = CGPointMake(sCardSize.width/2,sCardSize.height/2);
    front.edgeAntialiasingMask = 0;
    front.backgroundColor = kWhiteColor;
    front.cornerRadius = 8 * (sCardSize.height/150);
    front.borderWidth = 1;
    front.borderColor = CreateGray(0.7, 1.0);
    front.doubleSided = NO;         // this makes the layer invisible when it's flipped
    return [front autorelease];
}


- (GGBLayer*) createBack
{
    CGSize size = self.bounds.size;
    GGBLayer *back = [[GGBLayer alloc] init];
    back.bounds = CGRectMake(0,0,size.width,size.height);
    back.position = CGPointMake(sCardSize.width/2,sCardSize.height/2);
#if TARGET_OS_IPHONE
    back.backgroundColor = CreateRGB(0.0,0.5,0.5, 1.0);
#else
    back.contents = (id) GetCGImageNamed(@"/Library/Desktop Pictures/Classic Aqua Blue.jpg");
#endif
    back.contentsGravity = kCAGravityResize;
    back.masksToBounds = YES;
    back.borderWidth = 4 * (sCardSize.height/150);
    back.borderColor = kWhiteColor;
    back.cornerRadius = 8 * (sCardSize.height/150);
    back.edgeAntialiasingMask = 0;
    back.doubleSided = NO;          // this makes the layer invisible when it's flipped
    
#if TARGET_OS_IPHONE
    // On iPhone, only Hiragana Kaku includes the coveted snowman glyph... who knows why?
    UIFont *font = [UIFont fontWithName: @"HiraKakuProN-W3" size: 1*size.width];
#else
    NSFont *font = [NSFont systemFontOfSize: 1*size.width];
#endif
    GGBTextLayer *label = [GGBTextLayer textLayerInSuperlayer: back
                                                     withText: @"\u2603"          // Unicode snowman character
                                                         font: font
                                                    alignment: kCALayerWidthSizable|kCALayerHeightSizable];
    label.foregroundColor = CreateGray(1.0,0.5);
    return [back autorelease];
}    


#pragma mark -
#pragma mark DRAG-AND-DROP:


#if ! TARGET_OS_IPHONE

// An image from another app can be dragged onto a Card to change its background. */


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pb = [sender draggingPasteboard];
    if( [NSImage canInitWithPasteboard: pb] )
        return NSDragOperationCopy;
    else
        return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    CGImageRef image = GetCGImageFromPasteboard([sender draggingPasteboard],sender);
    if( image ) {
        GGBLayer *face = _faceUp ?_front :_back;
        face.contents = (id) image;
        face.contentsGravity = kCAGravityResizeAspectFill;
        face.masksToBounds = YES;
        return YES;
    } else
        return NO;
}

#endif

@end
