package chatappjn.Controllers;

import chatappjn.Common.Endpoints;
import chatappjn.Models.HealthCheck;
import chatappjn.Repositories.HealthCheckRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
    controllers = PingDbController.class,  // controller class
    excludeAutoConfiguration = {
        org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class
    }
)
@Import(Endpoints.class)  
class PingDbControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private HealthCheckRepository healthCheckRepository;

    @Test
    void pingDb_shouldReturnPingMessage_whenDbHasRow() throws Exception {
        HealthCheck mockRow = new HealthCheck("Hello world from Dev MongoDB!");
        when(healthCheckRepository.findTopByOrderByIdAsc())
                .thenReturn(Optional.of(mockRow));

        mockMvc.perform(get("/api/pingdb"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.response").value("Hello world from Dev MongoDB!"));
    }

    @Test
    void pingDb_shouldReturnNoContent_whenDbIsEmpty() throws Exception {
        when(healthCheckRepository.findTopByOrderByIdAsc())
                .thenReturn(Optional.empty());

        mockMvc.perform(get("/api/pingdb"))
                .andExpect(status().isNoContent());
    }

    @Test
    void pingDb_shouldReturnServiceUnavailable_whenRepositoryThrows() throws Exception {
        when(healthCheckRepository.findTopByOrderByIdAsc())
                .thenThrow(new RuntimeException("MongoDB down"));

        mockMvc.perform(get("/api/pingdb"))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.error").value("Database connection failed"));
    }
}
