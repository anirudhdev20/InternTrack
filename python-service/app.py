"""
InternTrack - Internship Completeness Assessment Flask Microservice
Runs on port 5000 and exposes REST API endpoints for the Java Spring Boot backend.
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from assessor import InternshipAssessor

app = Flask(__name__)
CORS(app)


@app.route("/api/health", methods=["GET"])
def health_check():
    """Health check endpoint to verify microservice availability."""
    return jsonify({
        "status": "UP",
        "service": "InternTrack Internship Quality Assessment Service",
        "version": "1.0.0"
    }), 200


@app.route("/api/assess", methods=["POST"])
def assess_internship():
    """
    POST /api/assess
    Receives JSON payload of an internship listing and returns
    its completeness score (0-100), missing details, warnings,
    and faculty recommendation.
    """
    try:
        if not request.is_json:
            return jsonify({
                "error": "Bad Request",
                "message": "Content-Type must be application/json"
            }), 400

        data = request.get_json()
        if not data:
            return jsonify({
                "error": "Bad Request",
                "message": "JSON body is empty"
            }), 400

        result = InternshipAssessor.assess(data)
        return jsonify(result), 200

    except Exception as e:
        return jsonify({
            "error": "Internal Server Error",
            "message": str(e)
        }), 500


if __name__ == "__main__":
    print("Starting InternTrack Python Assessment Microservice on port 5000...")
    app.run(host="0.0.0.0", port=5000, debug=False)
