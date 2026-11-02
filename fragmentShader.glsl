#version 330 core

in vec3 fPosition;
in vec3 fNormal;
in vec2 fTexCoord;

uniform sampler2D albedoTex;
uniform int useTexture;
uniform vec3 objectColor;
uniform vec3 camPos;
uniform vec3 lightPos;
uniform int isSun;

out vec4 color;

void main() {
    vec3 n = normalize(fNormal);

    // 빛을 향하는 방향
    vec3 l = normalize(lightPos - fPosition);

    // 표면에서 카메라를 향하는 방향
    vec3 v = normalize(camPos - fPosition);

    // 빛이 표면에서 반사되는 방향
    vec3 r = reflect(-l, n);

    // vec3 objectColor = vec3(0.8, 0.6, 0.3);
    vec3 lightColor = vec3(1.0);
	vec3 baseColor = objectColor;

	if (isSun == 1) {
		color = vec4(baseColor, 1.0);
		return;
	}
	if (useTexture == 1) {
		baseColor = texture(albedoTex, fTexCoord).rgb;
	}

    // 주변광: 빛이 직접 닿지 않는 곳도 조금 보이게 함
	vec3 ambient = 0.1 * baseColor;
	
    // 난반사광: 빛을 정면으로 받는 면일수록 밝아짐
    float diffuseStrength = max(dot(n, l), 0.0);
    vec3 diffuse = diffuseStrength * lightColor * baseColor;

    // 반사광: 반사 방향과 카메라 방향이 가까울수록 반짝임
    float specularStrength = pow(max(dot(v, r), 0.0), 32.0);
    vec3 specular = 0.4 * specularStrength * lightColor;

    color = vec4(ambient + diffuse + specular, 1.0);
}