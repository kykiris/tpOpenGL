#version 330 core            // Minimal GL version support expected from the GPU

layout(location=0) in vec3 vPosition;
layout(location=1) in vec3 vNormal;

uniform mat4 modelMat;
uniform mat4 viewMat, projMat;
layout(location=2) in vec2 vTexCoord;
out vec2 fTexCoord;

out vec3 fPosition;
out vec3 fNormal;

void main() {
    vec4 worldPosition = modelMat * vec4(vPosition, 1.0);

    gl_Position = projMat * viewMat * worldPosition;

    fPosition = worldPosition.xyz;
    fNormal = normalize(mat3(modelMat) * vNormal);
    fTexCoord = vTexCoord;
}