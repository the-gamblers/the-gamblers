import Foundation
import PythonKit

func RunPythonScript() -> PythonObject {
    let sys = Python.import("sys")
    sys.path.append("/Users/roeebelkin/Desktop/School/CSCE 482/the-gamblers/ChessMaster/Client/ChessMaster")
    let file = Python.import("script")

    let response = file.hello_world()
    print(response)
    return response
}