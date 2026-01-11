package chatappjn.Config;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;
import java.util.List;

public class JwtBuilder {
  private static final long EXPIRATION_TIME_MS = 60*60*1000; // 1 hour

  private static final String SECRET =
            System.getenv("JWT_SECRET");  //  env var

  private static final Key SECRET_KEY;

  static { // Static initialization block 
    if (SECRET == null || SECRET.length() < 32) {
        throw new IllegalStateException(
            "JWT_SECRET env variable is missing or too short (min 32 chars)"
        );
    }
    SECRET_KEY = Keys.hmacShaKeyFor(SECRET.getBytes());
  }


  public static Key getSecretKey() {
      return SECRET_KEY;
  }

  public static String generateToken(String userId, String username,
      List<String> roles, List<String> claims) { // Add for RBAC 
    return Jwts.builder()
      .setSubject(username)
      .claim("userId", userId)
      .claim("roles", roles) // Add for RBAC
      .claim("claims", claims) // Add for RBAC
      .setIssuedAt(new Date())
      .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME_MS))
      .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
      .compact();
  }
}
