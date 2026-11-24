package g1.emsi.customerservice;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "spring.cloud.config.enabled=false",
        "eureka.client.enabled=false",
        "global.params.p1=456",
        "global.params.p2=224",
        "customer.params.x=11",
        "customer.params.y=22"
})
@AutoConfigureMockMvc
class CustomerServiceApplicationTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void returnsSharedConfig() throws Exception {
        mockMvc.perform(get("/testConfig1"))
                .andExpect(status().isOk())
                .andExpect(content().json("""
                        {"p1":"456","p2":"224"}
                        """));
    }

    @Test
    void returnsCustomerConfig() throws Exception {
        mockMvc.perform(get("/testConfig2"))
                .andExpect(status().isOk())
                .andExpect(content().json("""
                        {"x":11,"y":22}
                        """));
    }
}
