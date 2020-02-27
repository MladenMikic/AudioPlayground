//
//  AudioPlaygroundTests.m
//  AudioPlaygroundTests
//
//  Created by Mladen Mikic on 27/02/2020.
//  Copyright © 2020 excellence. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Cocoa/Cocoa.h>

#import <AudioToolbox/AudioToolbox.h>

@interface AudioPlaygroundTests : XCTestCase

@end

@implementation AudioPlaygroundTests

- (void)testAudioConverterConvertComplexBufferDocumentation
{
    // 1)
    
    /*
     OSStatus AudioConverterNew(
        const AudioStreamBasicDescription *inSourceFormat,
        const AudioStreamBasicDescription *inDestinationFormat,
        AudioConverterRef  _Nullable *outAudioConverter
        );
     */
    // AudioConverterSetProperty
    // What is it? A setup method.
    // What is it for? Sets the value of an audio converter object property.
    // Documentation: https://developer.apple.com/documentation/audiotoolbox/1502936-audioconverternew
    
    // 2)
    
    /*
    OSStatus AudioConverterSetProperty(
     AudioConverterRef inAudioConverter,
     AudioConverterPropertyID inPropertyID,
     UInt32 inPropertyDataSize,
     const void *inPropertyData);
    */
    // AudioConverterSetProperty
    // What is it? A method.
    // What is it for? Sets the value of an audio converter object property.
    // Documentation: https://developer.apple.com/documentation/audiotoolbox/1501675-audioconvertersetproperty?language=objc
    
    // 3)
    
    /*
    OSStatus AudioConverterConvertComplexBuffer(
        AudioConverterRef inAudioConverter,
        UInt32 inNumberPCMFrames,
        const AudioBufferList *inInputData,
        AudioBufferList *outOutputData);
    */
    // AudioConverterConvertComplexBuffer
    // What is it? A method.
    // What is it for? Converts audio data from one linear PCM format to another, where both use the same sample rate.
    // Documentation: https://developer.apple.com/documentation/audiotoolbox/1502473-audioconverterconvertcomplexbuff?language=objc
    
    // 4)
    /*
    int memcmp(
        const void* lhs,
        const void* rhs,
        size_t count );
    */
    // memcmp
    // What is it? A method.
    // What is it for? Compares the first count characters of the objects pointed to by lhs and rhs.
    // Documentation: http://www.enseignement.polytechnique.fr/informatique/INF478/docs/Cpp/en/c/string/byte/memcmp.html
}

- (void)testChannelMapCh4ToCh2_32_Float
{
    AudioStreamBasicDescription inASBD = { 0 };
    inASBD.mSampleRate = 44100.0;
    inASBD.mFormatID = kAudioFormatLinearPCM;
    inASBD.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
    
    inASBD.mBytesPerPacket = 16;
    inASBD.mFramesPerPacket = 1;
    inASBD.mBytesPerFrame = 16;
    
    inASBD.mChannelsPerFrame = 4;
    inASBD.mBitsPerChannel = 32;
    
    AudioStreamBasicDescription outASBD = { 0 };
    outASBD.mSampleRate = 44100.0;
    outASBD.mFormatID = kAudioFormatLinearPCM;
    outASBD.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
    
    outASBD.mBytesPerPacket = 8;
    outASBD.mFramesPerPacket = 1;
    outASBD.mBytesPerFrame = 8;
    
    outASBD.mChannelsPerFrame = 2;
    outASBD.mBitsPerChannel = 32;
    
    AudioConverterRef audioConverter = NULL;
    OSStatus status = AudioConverterNew(&inASBD, &outASBD, &audioConverter);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Float::1) %i\n", status);
    XCTAssert(status == noErr);
    
    SInt32 channelMap[2] = { 1, 3 };
    status = AudioConverterSetProperty(audioConverter, kAudioConverterChannelMap, sizeof(channelMap), &channelMap);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Float::2) %i\n", status);
    XCTAssert(status == noErr);

    Float32 inData[16] = { 0.0, 1.0, 2.0, 3.0, 0.0, 1.0, 2.0, 3.0, 0.0, 1.0, 2.0, 3.0, 0.0, 1.0, 2.0, 3.0 };
    Float32 convertedData[8] = {};
    Float32 outData[8] = { 1.0, 3.0, 1.0, 3.0, 1.0, 3.0, 1.0, 3.0 };
    
    AudioBufferList inBufferList = { 0 };
    inBufferList.mNumberBuffers = 1;
    inBufferList.mBuffers[0].mData = inData;
    inBufferList.mBuffers[0].mDataByteSize = sizeof(inData);
    inBufferList.mBuffers[0].mNumberChannels = 4;
    
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mData = convertedData;
    outBufferList.mBuffers[0].mDataByteSize = sizeof(convertedData);
    outBufferList.mBuffers[0].mNumberChannels = 2;
    
    status = AudioConverterConvertComplexBuffer(audioConverter, 4, &inBufferList, &outBufferList);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Float::3) %i\n", status);
    XCTAssert(status == noErr);

    status = memcmp(convertedData, outData, sizeof(convertedData));
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Float::4) %i\n", status);
    XCTAssert(status == 0);
    
    AudioConverterDispose(audioConverter);
}

- (void)testChannelMapCh4ToCh2_32_Integer
{
    AudioStreamBasicDescription inASBD = { 0 };
    inASBD.mSampleRate = 44100.0;
    inASBD.mFormatID = kAudioFormatLinearPCM;
    inASBD.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    
    inASBD.mBytesPerPacket = 16;
    inASBD.mFramesPerPacket = 1;
    inASBD.mBytesPerFrame = 16;
    
    inASBD.mChannelsPerFrame = 4;
    inASBD.mBitsPerChannel = 32;
    
    AudioStreamBasicDescription outASBD = { 0 };
    outASBD.mSampleRate = 44100.0;
    outASBD.mFormatID = kAudioFormatLinearPCM;
    outASBD.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    
    outASBD.mBytesPerPacket = 8;
    outASBD.mFramesPerPacket = 1;
    outASBD.mBytesPerFrame = 8;
    
    outASBD.mChannelsPerFrame = 2;
    outASBD.mBitsPerChannel = 32;
    
    AudioConverterRef audioConverter = NULL;
    
    OSStatus status = AudioConverterNew(&inASBD, &outASBD, &audioConverter);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Integer::1) %i\n", status);
    XCTAssert(status == noErr);
    
    Float32 inData[16] = { 1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0, 4.0 };
    Float32 convertedData[8] = {};
//    float outData[4] = { 2.0, 4.0, 2.0, 4.0 };
    Float32 outData[8] = { 1.0, 3.0, 1.0, 3.0, 1.0, 3.0, 1.0, 3.0 };
//    SInt32 channelMap[2] = { 1, 3 };
    SInt32 channelMap[2] = { 0, 2 };
    status = AudioConverterSetProperty(audioConverter, kAudioConverterChannelMap, sizeof(channelMap), &channelMap);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Integer::2) %i\n", status);
    XCTAssert(status == noErr);
    
    AudioBufferList inBufferList = { 0 };
    inBufferList.mNumberBuffers = 1;
    inBufferList.mBuffers[0].mData = inData;
    inBufferList.mBuffers[0].mDataByteSize = sizeof(inData);
    inBufferList.mBuffers[0].mNumberChannels = 4;
    
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mData = convertedData;
    outBufferList.mBuffers[0].mDataByteSize = sizeof(convertedData);
    outBufferList.mBuffers[0].mNumberChannels = 2;
    
    status = AudioConverterConvertComplexBuffer(audioConverter, 4, &inBufferList, &outBufferList);
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Integer::3) %i\n", status);
    XCTAssert(status == noErr);
    
    status = memcmp(convertedData, outData, sizeof(convertedData));
    NSLog(@"\n\ntestChannelMapCh4ToCh2_32_Integer::4) %i\n", status);
    XCTAssert(status == 0);
    
    AudioConverterDispose(audioConverter);
}

- (void)testChannelMapStereo_To_Mono
{
    // From a broadcast extension (mic)
    AudioStreamBasicDescription inASBD = { 0 };
    inASBD.mSampleRate = 44100.0;
    
    inASBD.mFormatID = 1819304813;
    inASBD.mFormatFlags = 12;
    
    inASBD.mBytesPerPacket = 2;
    inASBD.mFramesPerPacket = 1;
    inASBD.mBytesPerFrame = 2;
    
    inASBD.mChannelsPerFrame = 1;
    inASBD.mBitsPerChannel = 16;
    
    // From a broadcast extension (app audio)
    AudioStreamBasicDescription outASBD = { 0 };
    outASBD.mSampleRate = 44100.0;
    outASBD.mFormatID = 1819304813;
    outASBD.mFormatFlags = 12;
    
    outASBD.mBytesPerPacket = 4;
    outASBD.mFramesPerPacket = 1;
    outASBD.mBytesPerFrame = 4;
    
    outASBD.mChannelsPerFrame = 2;
    outASBD.mBitsPerChannel = 16;
    
    AudioConverterRef audioConverter = NULL;
    OSStatus status = AudioConverterNew(&inASBD, &outASBD, &audioConverter);
    NSLog(@"\n\ntestChannelMapStereo_To_Mono::1) %i\n", status);
    XCTAssert(status == noErr);
    
    UInt16 inData[3] = { 1, 2, 3 };
    UInt16 convertedData[6] = {};
    UInt16 outData[6] = { 1, 1, 2, 2 , 3 , 3 };
    
    SInt32 channelMap[2] = { 0, 0 };
    status = AudioConverterSetProperty(audioConverter, kAudioConverterChannelMap, sizeof(channelMap), &channelMap);
    NSLog(@"\n\ntestChannelMapStereo_To_Mono::2) %i\n", status);
    XCTAssert(status == noErr);
    
    AudioBufferList inBufferList = { 0 };
    inBufferList.mNumberBuffers = 1;
    inBufferList.mBuffers[0].mData = inData;
    inBufferList.mBuffers[0].mDataByteSize = sizeof(inData);
    inBufferList.mBuffers[0].mNumberChannels = 1;
    
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mData = convertedData;
    outBufferList.mBuffers[0].mDataByteSize = sizeof(convertedData);
    outBufferList.mBuffers[0].mNumberChannels = 2;
    // The mDataByteSize sizes must be equal
    status = AudioConverterConvertComplexBuffer(audioConverter, 3, &inBufferList, &outBufferList);
    NSLog(@"\n\ntestChannelMapStereo_To_Mono::3) %i\n", status);
     XCTAssert(status == noErr);

    status = memcmp(convertedData, outData, sizeof(convertedData));
    NSLog(@"\n\ntestChannelMapStereo_To_Mono::4) %i\n", status);
    XCTAssert(status == noErr);
    
    AudioConverterDispose(audioConverter);
}


@end

