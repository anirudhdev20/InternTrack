package com.interntrack.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.interntrack.dto.AssessmentResponseDto;
import com.interntrack.model.Internship;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.*;

@Service
public class AssessmentService {

    private static final Logger log = LoggerFactory.getLogger(AssessmentService.class);

    @Value("${interntrack.python.service.url:http://127.0.0.1:5000}")
    private String pythonServiceUrl;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(4))
            .build();

    public AssessmentResponseDto assessInternship(Internship internship) {
        AssessmentResponseDto dto = new AssessmentResponseDto();

        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("title", internship.getTitle() != null ? internship.getTitle() : "");
            payload.put("description", internship.getDescription() != null ? internship.getDescription() : "");
            payload.put("skills", internship.getRequiredSkills() != null ? internship.getRequiredSkills() : "");
            payload.put("eligibility", internship.getEligibility() != null ? internship.getEligibility() : "");
            payload.put("duration", internship.getDuration() != null ? internship.getDuration() : "");
            payload.put("stipend", internship.getStipend() != null ? internship.getStipend() : "");
            payload.put("mentorship", internship.getMentorshipDetails() != null ? internship.getMentorshipDetails() : "");
            payload.put("location", internship.getLocation() != null ? internship.getLocation() : "");
            payload.put("work_mode", internship.getWorkMode() != null ? internship.getWorkMode().name() : "ON_SITE");

            String requestBody = objectMapper.writeValueAsString(payload);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(pythonServiceUrl + "/api/assess"))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(6))
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonNode root = objectMapper.readTree(response.body());
                dto.setScore(root.path("score").asInt(0));
                dto.setRecommendation(root.path("recommendation").asText("Ready for faculty review"));
                dto.setStatus("SUCCESS");

                List<String> missing = new ArrayList<>();
                root.path("missing_details").forEach(node -> missing.add(node.asText()));
                dto.setMissingDetails(missing);

                List<String> warnings = new ArrayList<>();
                root.path("warnings").forEach(node -> warnings.add(node.asText()));
                dto.setWarnings(warnings);

                List<String> suggestions = new ArrayList<>();
                root.path("suggestions").forEach(node -> suggestions.add(node.asText()));
                dto.setSuggestions(suggestions);

                log.info("Python Assessment successful for internship {}: Score = {}", internship.getId(), dto.getScore());
                return dto;
            } else {
                log.warn("Python assessment service returned status: {}", response.statusCode());
                return createFallbackAssessment("Assessment service returned status " + response.statusCode());
            }

        } catch (Exception e) {
            log.error("Unable to contact Python Assessment microservice: {}", e.getMessage());
            return createFallbackAssessment("Python assessment service unavailable: " + e.getMessage());
        }
    }

    private AssessmentResponseDto createFallbackAssessment(String errorReason) {
        AssessmentResponseDto fallback = new AssessmentResponseDto();
        fallback.setScore(0);
        fallback.setStatus("MANUAL_REVIEW_REQUIRED");
        fallback.setMissingDetails(Collections.singletonList("Automatic assessment temporarily unavailable"));
        fallback.setWarnings(Collections.singletonList("The Python completeness evaluation service could not be contacted. Manual faculty evaluation required."));
        fallback.setRecommendation("Requires direct manual faculty inspection: " + errorReason);
        return fallback;
    }

    public boolean isServiceHealthy() {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(pythonServiceUrl + "/api/health"))
                    .timeout(Duration.ofSeconds(3))
                    .GET()
                    .build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            return response.statusCode() == 200;
        } catch (Exception e) {
            return false;
        }
    }
}
