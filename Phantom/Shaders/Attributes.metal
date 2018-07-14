// Copyright © haijian. All rights reserved.

// File for Metal kernel and shader functions
#include <metal_stdlib>
using namespace metal;

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "Phantom/BridgingHeaders/Uniform.h"

typedef struct
{
	float3 position [[attribute(VertexAttributePosition)]];
	float2 texCoord [[attribute(VertexAttributeTexcoord)]];
} Vertex;