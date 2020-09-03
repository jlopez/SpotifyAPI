import Foundation
import SpotifyWebAPI

public protocol SpotifyURIConvertibleEnum:
    SpotifyURIConvertible,
    CaseIterable,
    RawRepresentable where RawValue == String {
    
}

public extension SpotifyURIConvertibleEnum {
    
    @inlinable
    var uri: String { self.rawValue }
    
    @inlinable
    static func array(_ items: Self...) -> [SpotifyURIConvertible] {
        return items
    }
    
}

/// A namespace of Spotify content identifiers (mostly URIs).
///
/// This enum is only meant for testing purposes and has no stable API.
public enum URIs {
    
    /// A namespace of Spotify users.
    public enum Users: String, SpotifyURIConvertibleEnum {
        case peter = "spotify:user:petervschorn"
        case april = "spotify:user:p8gjjfbirm8ucyt82ycfi9zuu"
    }
    
    /// A namespace of Spotify Device Ids.
    public enum Devices {
        public static let petersiPhone = "476da515c6109d1351359b4c2ad313161f79b173"
        public static let petersComputer = "ced8d42d0a3830065dfbf4800352d23a96b76fd4"
    }
    
    /// A namespace of playlists.
    public enum Playlists: String, SpotifyURIConvertibleEnum {
        case test = "spotify:playlist:0ijeB2eFmJL1euREk6Wu6C"
        case new = "spotify:playlist:5MlKAGFZNoN2d0Up8sQc0N"
        case crumb = "spotify:playlist:33yLOStnp2emkEA76ew1Dz"
        case all = "spotify:playlist:01KRdno32jt1vmG7s5pVFg"
        case index = "spotify:playlist:17gneMykp6L6O5R70wm0gE"
        case thisIsMacDeMarco = "spotify:playlist:37i9dQZF1DXe8E8oqpmTDI"
        case thisIsSpoon = "spotify:playlist:37i9dQZF1DX3zc219hYxy3"
        case bluesClassics = "spotify:playlist:37i9dQZF1DXd9rSDyQguIk"
        case thisIsPinkFloyd = "spotify:playlist:37i9dQZF1DXaQ34lqGBfrU"
    }

    /// A namespace of artists.
    public enum Artists: String, SpotifyURIConvertibleEnum {
        case crumb = "spotify:artist:4kSGbjWGxTchKpIxXPJv0B"
        case levitationRoom = "spotify:artist:0SVxQVCnJn1BNUMY9ZcRO4"
        case radiohead = "spotify:artist:4Z8W4fKeB5YxbusRsdQVPb"
        case skinshape = "spotify:artist:1itM5tXaK5THggpXA7ovAe"
        case mildHighClub = "spotify:artist:5J81VungUjSVHxlPpTI9KG"
        case pinkFloyd = "spotify:artist:0k17h0D3J5VfsdmQ1iZtE9"
    }
    
    /// A namespace of albums.
    public enum Albums: String, SpotifyURIConvertibleEnum {
        case jinx = "spotify:album:3vukTUpiENDHDoYTVrwqtz"
        case locket = "spotify:album:2Q61Zm3rOli876QegmVY50"
        case skiptracing = "spotify:album:1qMDN9zRQreK81cJ9G1hed"
        case tiger = "spotify:album:4OPBRShV2OxYoT4hAenDPl"
        case saladDays = "spotify:album:7xPhDaYZ2ejV04aNtdBdvj"
        case meddle = "spotify:album:468ZwCchVtzEbt9BHmXopb"
        case longestAlbum = "spotify:album:1Hnvk7i2oLf4ZQnOB8kYqt"
    }

    /// A namespace of tracks.
    public enum Tracks: String, SpotifyURIConvertibleEnum {
        case locket = "spotify:track:0bxcUgWlOURkU6lZt4zog0"
        case jinx = "spotify:track:7qAy6TR1MrSeUV8OpMlNS1"
        case plants = "spotify:track:2cOzI3LOIkRIKEidcGZ1Bc"
        case faces = "spotify:track:1u7LOyLuApChbPeqMfXFKC"
        case friends = "spotify:track:43NI5sAcvDLG7QQAmUc7UU"
        case illWind = "spotify:track:7vuVUQV0dDnjXUyLPzJLPi"
        case theBay = "spotify:track:4x0QYD0DhErAC1sPvvPmq9"
        case wadingOut = "spotify:track:3e7WFkI9OBb9ANwqJroJwZ"
        case partIII = "spotify:track:4HDLmWf73mge8isanCASnU"
        case nuclearFusion = "spotify:track:1pmImsdC9t35L3TkD26ax8"
        case honey = "spotify:track:01IuTsgAlgKlgrvPhZ2c95"
        case anyColourYouLike = "spotify:track:6FBPOJLxUZEair6x4kLDhf"
        case fearless = "spotify:track:7AalBKBoLDR4UmRYRJpdbj"
    }
    
    /// A namespace of episodes.
    public enum Episodes: String, SpotifyURIConvertibleEnum {
        case samHarris215 = "spotify:episode:1Vrpa83y0vBdWZqeEbkKk3"
        case samHarris214 = "spotify:episode:3d1cFPfj3kZB27D4b8ZJm2"
        case samHarris213 = "spotify:episode:7jrEoNMrNicZSxIuKhATHN"
        case samHarris212 = "spotify:episode:3OEdPEYB69pfXoBrhvQYeC"
        
        case seanCarroll112 = "spotify:episode:5LEFdZ9pYh99wSz7Go2D0g"
        case seanCarroll111 = "spotify:episode:0Bbtb2VFGYAl54Enix23Qd"
        
        /// Miley Cyrus
        case joeRogan1531 = "spotify:episode:0ZEDvQuPtAEBnXE37slSoX"
    }
    
    /// A namespace of shows.
    public enum Shows: String, SpotifyURIConvertibleEnum {
        case samHarris = "spotify:show:5rgumWEx4FsqIY8e1wJNAk"
        case joeRogan = "spotify:show:4rOoJ6Egrf8K2IrywzwOMk"
        case seanCarroll = "spotify:show:622lvLwp8CVu6dvCsYAJhN"
    }

}
