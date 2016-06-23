import Foundation
import UIKit


internal struct Environment {

	internal static let appVersion: String? = {
		return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
	}()


	internal static let deviceModelString: String = {
		let device = UIDevice.currentDevice()
		if device.isSimulator {
			return "\(operatingSystemName) Simulator"
		}
		else {
			return device.modelIdentifier
		}
	}()


	internal static let operatingSystemName: String = {
		#if os(iOS)
			return "iOS"
		#elseif os(watchOS)
			return "watchOS"
		#elseif os(tvOS)
			return "tvOS"
		#elseif os(OSX)
			return "macOS"
		#endif
	}()


	internal static let operatingSystemVersionString: String = {
		let version = NSProcessInfo().operatingSystemVersion
		if version.patchVersion == 0 {
			return "\(version.majorVersion).\(version.minorVersion)"
		}
		else {
			return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
		}
	}()
}
