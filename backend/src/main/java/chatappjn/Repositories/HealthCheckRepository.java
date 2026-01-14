package chatappjn.Repositories;

import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;
import chatappjn.Models.HealthCheck;

public interface HealthCheckRepository extends MongoRepository<HealthCheck, String> {
  Optional<HealthCheck> findTopByOrderByIdAsc();
}
