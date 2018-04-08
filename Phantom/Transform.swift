// Copyright © haijian. All rights reserved.

import MetalKit

// The 256 byte aligned size of our uniform structure
let alignedUniformsSize = (MemoryLayout<Uniforms>.size & ~0xFF) + 0x100
let maxBuffersInFlight = 3

class Transform {
	
	let inFlightSemaphore = DispatchSemaphore(value: maxBuffersInFlight)
	var uniformBufferOffset = 0
	var uniformBufferIndex = 0
	var uniforms: UnsafeMutablePointer<Uniforms>
	var projectionMatrix: Matrix4x4 = Matrix4x4()
	var rotation: Float = 0
	
	var dynamicUniformBuffer: MTLBuffer
	
	init?() {
		let uniformBufferSize = alignedUniformsSize * maxBuffersInFlight
		
		guard let buffer = Display.main.device?.makeBuffer(length: uniformBufferSize, options: MTLResourceOptions.storageModeShared) else { return nil }
		dynamicUniformBuffer = buffer
		
		self.dynamicUniformBuffer.label = "UniformBuffer"
		
		uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents()).bindMemory(to: Uniforms.self, capacity: 1)
	}
	
	func updateDynamicBufferState() {
		/// Update the state of our uniform buffers before rendering
		
		uniformBufferIndex = (uniformBufferIndex + 1) % maxBuffersInFlight
		
		uniformBufferOffset = alignedUniformsSize * uniformBufferIndex
		
		uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents() + uniformBufferOffset).bindMemory(to:Uniforms.self, capacity:1)
	}
	
	func updateGameState() {
		// Update any game state before rendering
		
		uniforms[0].projectionMatrix = projectionMatrix
		
		let rotationAxis = float3(1, 1, 0)
		let modelMatrix = Math.rotate(radians: rotation, axis: rotationAxis)
		let viewMatrix = Math.translate(0.0, 0.0, -8.0)
		uniforms[0].modelViewMatrix = viewMatrix * modelMatrix;
		rotation += 0.01
	}

}
