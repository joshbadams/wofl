//
//  iOSFile.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_iOSFile_h
#define Wofl_iOSFile_h

#include "WoflFile.h"

class iOSFile : public WoflFile
{
public:
	
	iOSFile()
		: WoflFile()
	{
		MainBundle = [NSBundle mainBundle];
		WoflBundle = [NSBundle bundleForClass:NSClassFromString(@"WoflViewController")];
	}
	
	virtual string GetResourcePath(const char* Filename) override
	{
		NSString* FilenameStr = [NSString stringWithCString:Filename encoding:NSUTF8StringEncoding];
		NSString* Path = [MainBundle
						  pathForResource:[FilenameStr stringByDeletingPathExtension]
						  ofType:[FilenameStr pathExtension]];
		
		if (Path == nil)
		{
			Path = [WoflBundle
					pathForResource:[FilenameStr stringByDeletingPathExtension]
					ofType:[FilenameStr pathExtension]];
		}
		
		
		return [Path UTF8String];
	}
	
	virtual string GetSavePath(const char* Filename) override
	{
		// get doc dir location
		NSArray* DocumentsDirs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
		NSURL* DocDir = [DocumentsDirs objectAtIndex:0];
		
		// append filename to it
		return [[DocDir URLByAppendingPathComponent:[NSString stringWithUTF8String:Filename]] fileSystemRepresentation];
	}
	
	virtual string LoadFileToString(const char* Path) override
	{
		NSString* PathStr =[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSString* Contents = [NSString stringWithContentsOfFile:PathStr encoding:NSUTF8StringEncoding error:nil];
		if (Contents && [Contents length] > 0)
		{
			return [Contents UTF8String];
		}

		NSLog(@"Failed to load %@", PathStr);
		return "";
	}

	virtual vector<unsigned char> LoadFileToArray(const char* Path) override
	{
		NSString* PathStr =[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSMutableData* Contents = [NSMutableData dataWithContentsOfFile:PathStr];

		if (Contents && Contents.length > 0)
		{
			// make a vector with the contents
			vector<unsigned char> Array;
			Array.resize(Contents.length);
			
			// empty now to free memory before the return copy of the vector
			[Contents setLength:0];
			return Array;
		}
		
		NSLog(@"Failed to load %@", PathStr);
		return vector<unsigned char>();
	}

	
	virtual void* LoadPNGToAllocatedBuffer(const char* ImageName, unsigned int& Width, unsigned int& Height) override
	{
		// load PNG
		NSString* ImageNameStr = [NSString stringWithCString:ImageName encoding:NSUTF8StringEncoding];
		NSString* ImagePath = [MainBundle pathForResource:ImageNameStr ofType:@"png"];
		if (ImagePath == nil)
		{
			ImagePath = [WoflBundle pathForResource:ImageNameStr ofType:@"png"];
		}
#if TARGET_OS_MAC
		NSImage* Image = [[NSImage alloc] initWithContentsOfFile:ImagePath];
#else
		UIImage* Image = [UIImage imageWithContentsOfFile:ImagePath];
#endif
		if (Image == nullptr)
		{
			return nullptr;
		}
		
		// pull out info
		Width = [Image size].width;
		Height = [Image size].height;
		
		// allocate all the memory
		void* ImageData = malloc(Width * Height * 4);
		memset(ImageData, 0, Width * Height * 4);
		
#if TARGET_OS_MAC
		NSRect ImageRect = NSMakeRect(0, 0, Width, Height);
		CGImageRef CGImage = [Image CGImageForProposedRect:&ImageRect context:NULL hints:nil];
#else
		CGImageRef CGImage = Image.CGImage;
#endif

		// draw the UIImage into the memory block
		CGContextRef SpriteContext = CGBitmapContextCreate(ImageData, Width, Height, 8, Width * 4,
														   CGImageGetColorSpace(CGImage),
														   kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(SpriteContext, CGRectMake(0.0, 0.0, (CGFloat)Width, (CGFloat)Height), CGImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(SpriteContext);

		return ImageData;
	}
	
	virtual bool SaveStringToFile(const string& String, const char* Path) override
	{
		NSString* PathStr =[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSString* Contents = [NSString stringWithCString:String.c_str() encoding:NSUTF8StringEncoding];

		NSError* Error;
		[Contents writeToFile:PathStr atomically:YES encoding:NSUTF8StringEncoding error:&Error];

		if (Error)
		{
			NSLog(@"Failed to save %@, error = %@", PathStr, [Error localizedDescription]);
			return false;
		}
		
		return true;
	}
	
	virtual bool SaveArrayToFile(const vector<unsigned char>& Array, const char* Path) override
	{
		NSString* PathStr =[NSString stringWithCString:Path encoding:NSUTF8StringEncoding];
		NSData* Contents = [NSData dataWithBytes:Array.data() length:Array.size()];

		NSError* Error;
		[Contents writeToFile:PathStr options:NSDataWritingAtomic error:&Error];
		
		if (Error)
		{
			NSLog(@"Failed to save %@, error = %@", PathStr, [Error localizedDescription]);
			return false;
		}
		
		return true;
	}

protected:
	NSBundle* WoflBundle;
	NSBundle* MainBundle;

};

#endif
