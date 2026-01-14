package chatappjn.Controllers;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

import chatappjn.Common.Endpoints;
import chatappjn.Config.JwtValidator;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(
    controllers = PingController.class,
    excludeAutoConfiguration = {
        org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class
    }
)
@Import(Endpoints.class)
class PingControllerTest {
  @Autowired
  private MockMvc mockMvc;

  @Test
  void ping_shouldReturnPong() throws Exception {
      mockMvc.perform(get("/api/ping"))
              .andExpect(status().isOk())
              .andExpect(jsonPath("$.response").value("pong"));
  }
}
