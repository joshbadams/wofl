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
	
	}
	
	virtual string GetResourcePath(const char* Filename) override
	{
		NSString* FilenameStr = [NSString stringWithCString:Filename encoding:NSUTF8StringEncoding];
		NSString* Path = [[NSBundle mainBundle]
						  pathForResource:[FilenameStr stringByDeletingPathExtension]
						  ofType:[FilenameStr pathExtension]
						  ];
		
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
		UIImage* Image = [UIImage imageNamed:[NSString stringWithCString:ImageName encoding:NSUTF8StringEncoding]];
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
		
		// draw the UIImage into the memory block
		CGContextRef SpriteContext = CGBitmapContextCreate(ImageData, Width, Height, 8, Width * 4,
														   CGImageGetColorSpace(Image.CGImage),
														   kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(SpriteContext, CGRectMake(0.0, 0.0, (CGFloat)Width, (CGFloat)Height), Image.CGImage);
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


};

#endif
