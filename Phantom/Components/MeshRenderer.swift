// Copyright © haijian. All rights reserved.

import MetalKit

public class MeshRenderer: Renderer, Drawable {
	
	public var mesh: Mesh?
	
	// Allow cpu to go 2 steps ahead GPU, before GPU finishes its current command.
	private let semaphore = DispatchSemaphore(value: 3)

	// TODO: can this skip some encoding phases?
	func draw(in view: MTKView) {
		// Check all the resources available.
		guard
			let mesh = self.mesh,
			let material = self.material,
			let renderPass = View.sharedInstance.renderPass,
			let commandBuffer = View.sharedInstance.commandQueue?.makeCommandBuffer(),
			let renderEncoder = renderPass.makeRenderCommandEncoder(commandBuffer: commandBuffer)
		else { return }
		
		_ = semaphore.wait(timeout: .distantFuture)
		commandBuffer.addCompletedHandler() { _ in self.semaphore.signal() } // TODO: capture
		
		// Start encoding and setup debug infomation
		// TODO: setup with object names
		renderEncoder.label = "Primary Render Encoder"
		renderEncoder.pushDebugGroup("Draw Box")
		// Render pass encoding.
		renderPass.encode(to: renderEncoder)
		// Material encoding: including shader and texture encoding.
		material.encode(to: renderEncoder)
		// Game object encoding: update triple buffer.
		gameObject.encode(to: renderEncoder)
		// Mesh encoding: contents draw call encoding, which must be encoded at last (just before end encoding).
		mesh.encode(to: renderEncoder)
		// End encoding.
		renderEncoder.popDebugGroup()
		renderEncoder.endEncoding()
		
		// If rendering to core animation layer.
		// TODO: in render pass
		if let drawable = view.currentDrawable { commandBuffer.present(drawable) }
	
		commandBuffer.commit()
	}
}
