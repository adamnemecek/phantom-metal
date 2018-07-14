// Copyright © haijian. All rights reserved.

enum ShaderType {
	
	case primitive
	
	var vertex: String {
		switch self {
		case .primitive:
			return "vertexShader"
		}
	}
	
	var fragment: String {
		switch self {
		case .primitive:
			return "fragmentShader"
		}
	}
}
