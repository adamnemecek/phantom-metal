// Copyright © haijian. All rights reserved.

import MetalKit

// MARK: - Primitive extension for creating various primitive gameobjects by using the GameObject.create... functions.
extension GameObject {

	/// Create a basic mesh type gameobject by all default settings.
	///
	/// - Returns: GameObject
	private static func createBase() -> GameObject? {
		// GameObject
		guard let gameObject = GameObject() else { return nil }
		// MeshRenderer
		guard let meshRenderer: MeshRenderer = gameObject.addComponent() else { return nil }
		// Attach material
		let material = Material()
		guard let shader = Shader() else { return nil }
		// TODO: None texture.
		guard let texture = Texture(name: "UV_Grid_Sm") else { return nil }
		material.texture = texture
		material.shader = shader
		meshRenderer.material = material
		return gameObject
	}
	
	/// Create a cube primitive.

	public static func createCube(withDimensions dimensions: Vector3 = Vector3(1, 1, 1), segments: Uint3 = Uint3(1, 1, 1), geometryType: MDLGeometryType = .triangles, inwardNormals: Bool = false) -> GameObject? {
		guard let gameObject = GameObject.createBase() else { return nil }
		guard let meshRenderer: MeshRenderer = gameObject.getComponent() else { return nil }
		guard let vertexDescriptor = meshRenderer.material?.shader?.vertexDescriptor else { return nil }

		// TODO: refactor!
		guard let device = View.main.device else { return nil }
		let metalAllocator = MTKMeshBufferAllocator(device: device)
		let mdlMesh = MDLMesh.newBox(withDimensions: dimensions, segments: segments, geometryType: geometryType, inwardNormals: inwardNormals, allocator: metalAllocator)
		let mdlVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
		guard let attributes = mdlVertexDescriptor.attributes as? [MDLVertexAttribute] else { return nil }
		attributes[VertexAttribute.position.rawValue].name = MDLVertexAttributePosition
		attributes[VertexAttribute.texcoord.rawValue].name = MDLVertexAttributeTextureCoordinate
		mdlMesh.vertexDescriptor = mdlVertexDescriptor
		let mtkMesh: MTKMesh
		do {
			mtkMesh = try MTKMesh(mesh: mdlMesh, device: device)
		} catch {
			print("Unable to build MetalKit Mesh. Error info: \(error)")
			return nil
		}
		
		meshRenderer.mesh = Mesh(with: mtkMesh)

		return gameObject
	}
}