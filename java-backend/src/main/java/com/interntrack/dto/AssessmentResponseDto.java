package com.interntrack.dto;

import java.util.ArrayList;
import java.util.List;

public class AssessmentResponseDto {

    private int score;
    private List<String> missingDetails = new ArrayList<>();
    private List<String> warnings = new ArrayList<>();
    private List<String> suggestions = new ArrayList<>();
    private String recommendation;
    private String status = "SUCCESS";

    public AssessmentResponseDto() {
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public List<String> getMissingDetails() {
        return missingDetails;
    }

    public void setMissingDetails(List<String> missingDetails) {
        this.missingDetails = missingDetails;
    }

    public List<String> getWarnings() {
        return warnings;
    }

    public void setWarnings(List<String> warnings) {
        this.warnings = warnings;
    }

    public List<String> getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(List<String> suggestions) {
        this.suggestions = suggestions;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
