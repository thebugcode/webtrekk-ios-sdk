import Foundation


public struct MediaProperties {

	public var bandwidth: Double?    // bit/s
	public var duration: NSTimeInterval?
	public var groups: Set<IndexedProperty>?
	public var name: String
	public var position: NSTimeInterval?
	public var soundIsMuted: Bool?
	public var soundVolume: Double?  // 0 ... 1


	public init(
		name: String,
		bandwidth: Double? = nil,
		duration: NSTimeInterval? = nil,
		groups: Set<IndexedProperty>? = nil,
		position: NSTimeInterval? = nil,
		soundIsMuted: Bool? = nil,
		soundVolume: Double? = nil
	) {
		self.bandwidth = bandwidth
		self.duration = duration
		self.groups = groups
		self.name = name
		self.position = position
		self.soundIsMuted = soundIsMuted
		self.soundVolume = soundVolume
	}

	
	@warn_unused_result
	internal func merged(with other: MediaProperties) -> MediaProperties {
		return MediaProperties(
			name:         name,
			bandwidth:    bandwidth ?? other.bandwidth,
			duration:     duration ?? other.duration,
			groups:       groups ?? other.groups,
			position:     position ?? other.position,
			soundIsMuted: soundIsMuted ?? other.soundIsMuted,
			soundVolume:  soundVolume ?? other.soundVolume
		)
	}
}