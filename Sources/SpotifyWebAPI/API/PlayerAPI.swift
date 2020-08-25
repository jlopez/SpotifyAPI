import Foundation
import Combine

// MARK: - Player -

public extension SpotifyAPI {
    
    // MARK: - GET -
    
    /**
     Get the user's available devices.
     
     This endpoint requires the `userReadPlaybackState` scope.
     
     Read more at the [Spotify web API reference][1].
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/player/get-a-users-available-devices/
     */
    func availableDevices() -> AnyPublisher<[Device], Error> {
        
        return self.getRequest(
            path: "/me/player/devices",
            queryItems: [:],
            requiredScopes: [.userReadPlaybackState]
        )
        .spotifyDecode([String: [Device]].self)
        .tryMap { dict -> [Device] in
            if let devices = dict["devices"] {
                return devices
            }
            throw SpotifyLocalError.topLevelKeyNotFound(
                key: "devices", dict: dict
            )
        }
        .eraseToAnyPublisher()
        
    }
    
    /**
     Get information about the user's current playback, including
     the currently playing track or episode, progress, and active device.
     
     This endpoint requires the `userReadPlaybackState` scope.

     The notable details that are returned are:
     
     * The user's currently active device
     * The track or episode that is currently playing
     * The context, such as a playlist, that it is playing in
     * The progress into the currently playing track/episode
     * The current shuffle and repeat state
     
     Read more at the [Spotify web API reference][1].
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/player/get-information-about-the-users-current-playback/
     */
    func currentPlayback() -> AnyPublisher<CurrentlyPlayingContext, Error> {
        
        return self.getRequest(
            path: "/me/player",
            queryItems: [:],
            requiredScopes: [.userReadPlaybackState]
        )
        .spotifyDecode(CurrentlyPlayingContext.self)
        
    }
 
    // MARK: - POST -
    
    /**
     Add a track or episode to the user's playback queue.
     
     This endpoint requires the `userModifyPlaybackState` scope.
     
     See also [player error reasons][1].
     
     Read more at the [Spotify web API reference][2].
     
     - Parameters:
       - uri: The uri for either a track or an episode.
       - deviceId: The id of the device to target. It is highly
             reccomended that you leave this as `nil` (default) to target
             the active device. If you provide the id of a device that
             is not currently playing content, you may get a 403
             "Player command failed: Restriction violated" error.
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/object-model/#player-error-reasons
     [2]: https://developer.spotify.com/documentation/web-api/reference/player/add-to-queue/
     */
    func addToQueue(
        _ uri: SpotifyURIConvertible,
        deviceId: String? = nil
    ) -> AnyPublisher<Void, Error> {
        
        return self.apiRequest(
            path: "/me/player/queue",
            queryItems: [
                "uri": uri.uri,
                "device_id": deviceId
            ],
            httpMethod: "POST",
            makeHeaders: Headers.bearerAuthorization(_:),
            bodyData: nil,
            requiredScopes: [.userModifyPlaybackState]
        )
        .decodeSpotifyErrors()
        .map { _, _ in }
        .eraseToAnyPublisher()
        
    }
    
    // MARK: - PUT -
    
    /**
     Pause the user's current playback
     
     This endpoint requires the `userModifyPlaybackState` scope.
     
     Due to the asynchronous nature of the issuance of the command,
     you should use the Get Information About The User’s Current Playback
     endpoint (`currentPlayback()`) to check that your issued command was
     handled correctly by the player.
     
     When performing an action that is restricted,
     404 NOT FOUND or 403 FORBIDDEN will be returned together with
     a [player error message][1]. For example, if there are no active devices found,
     the request will return 404 NOT FOUND response code and the reason
     NO_ACTIVE_DEVICE, or, if the user making the request is non-premium,
     a 403 FORBIDDEN response code will be returned together with
     the PREMIUM_REQUIRED reason.
     
     Read more at the [Spotify web API reference][2].
     
     - Parameter deviceId: The id of a device to target. It is highly
           reccomended that you leave this as `nil` (default) to target
           the active device. If you provide the id of a device that
           is not currently playing content, you may get a 403
           "Player command failed: Restriction violated" error.
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/object-model/#player-error-reasons
     [2]: https://developer.spotify.com/documentation/web-api/reference/player/pause-a-users-playback/
     */
    func pausePlayback(
        deviceId: String? = nil
    ) -> AnyPublisher<Void, Error> {
        
        return self.apiRequest(
            path: "/me/player/pause",
            queryItems: ["device_id": deviceId],
            httpMethod: "PUT",
            makeHeaders: Headers.bearerAuthorization(_:),
            bodyData: nil,
            requiredScopes: [.userModifyPlaybackState]
        )
        .decodeSpotifyErrors()
        .map { _, _ in }
        .eraseToAnyPublisher()
        
    }
    
    /**
     Start a new context or resume current playback on
     the user’s active device.
     
     This endpoint requires the `userModifyPlaybackState` scope.
     
     The `playbackRequest` has the following parameters:
     
     # context:
     The context in which to play the content.
     One of the following:
     * `contextURI(String)`: A URI for the context in which to play the content.
         Must correspond to one of the following:
         * Album
         * Artist
         * Playlist
     
     * `uris([String])`: An array of track/episode uris.
     
     # offset:
     Indicates where in the context playback should start.
     Only available when `contextURI` is an album or playlist (not an artist)
     or when `uris([String])` is used for the context. One of the following:
     
     * `position(Int)`: The index of the item in the context at which to
       start playback.
     *  `uri(String)`: The URI of the item to start playback at.
     
     If `nil`, then either the first item or a random item in the context
     will be played, depending on whether the user has shuffle on.
       
     # positionMS:
     Indicates from what position to start playback.
     Must be a positive number. If `nil`, then the track/episode
     will start from the beginning. Passing in a position that is
     greater than the length of the track will cause the player
     to start playing the next song.
     
     When performing an action that is restricted,
     404 NOT FOUND or 403 FORBIDDEN will be returned together with
     a [player error message][1]. For example, if there are no active devices found,
     the request will return 404 NOT FOUND response code and the reason
     NO_ACTIVE_DEVICE, or, if the user making the request is non-premium,
     a 403 FORBIDDEN response code will be returned together with
     the PREMIUM_REQUIRED reason.
     
     Read more at the [Spotify web API reference][2].
     
     - Parameters:
       - deviceId: The id of a device to target. It is highly
             reccomended that you leave this as `nil` (default) to target
             the active device. If you provide the id of a device that
             is not currently playing content, you may get a 403
             "Player command failed: Restriction violated" error.
       - playbackRequest: A request to play content for the user. See above.
             **Provide nil to resume playback of the current track/episode.**
     
     [1]: https://developer.spotify.com/documentation/web-api/reference/object-model/#player-error-reasons
     [2]: https://developer.spotify.com/documentation/web-api/reference/player/start-a-users-playback/
     */
    func resumePlayback(
        _ playbackRequest: PlaybackRequest?,
        deviceId: String? = nil
    ) -> AnyPublisher<Void, Error> {
        
        return self.apiRequest(
            path: "/me/player/play",
            queryItems: ["device_id": deviceId],
            httpMethod: "PUT",
            makeHeaders: Headers.bearerAuthorization(_:),
            body: playbackRequest,
            requiredScopes: [.userModifyPlaybackState]
        )
        .decodeSpotifyErrors()
        .map { _, _ in }
        .eraseToAnyPublisher()

    }
    
    
}