// Copyright © haijian. All rights reserved.

import PhantomKit

class SampleBehaviour: Component, Updatable {
	func update() {
		let rotationAxis = Vector3(1, 1, 0)
		gameObject.transform.rotate(angle: 0.01, axis: rotationAxis)
	}
}