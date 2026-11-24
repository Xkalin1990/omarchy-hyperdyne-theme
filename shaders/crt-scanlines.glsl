#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    vec2 texel = 1.0 / vec2(textureSize(tex, 0));

    // Two-ring 16-tap phosphor bloom for visible old-CRT text/UI glow
    vec3 innerBloom = vec3(0.0);
    vec2 innerOffsets[8] = vec2[8](
        vec2(-2.0,  0.0), vec2( 2.0,  0.0),
        vec2( 0.0, -2.0), vec2( 0.0,  2.0),
        vec2(-3.0, -3.0), vec2( 3.0, -3.0),
        vec2(-3.0,  3.0), vec2( 3.0,  3.0)
    );

    vec3 outerBloom = vec3(0.0);
    vec2 outerOffsets[8] = vec2[8](
        vec2(-5.5,  0.0), vec2( 5.5,  0.0),
        vec2( 0.0, -5.5), vec2( 0.0,  5.5),
        vec2(-7.0, -7.0), vec2( 7.0, -7.0),
        vec2(-7.0,  7.0), vec2( 7.0,  7.0)
    );

    for (int i = 0; i < 8; i++) {
        vec3 s1 = texture(tex, v_texcoord + innerOffsets[i] * texel).rgb;
        float e1 = max(dot(s1, vec3(0.299, 0.587, 0.114)), s1.r * 0.7);
        innerBloom += s1 * smoothstep(0.05, 0.42, e1);

        vec3 s2 = texture(tex, v_texcoord + outerOffsets[i] * texel).rgb;
        float e2 = max(dot(s2, vec3(0.299, 0.587, 0.114)), s2.r * 0.7);
        outerBloom += s2 * smoothstep(0.05, 0.42, e2);
    }
    vec3 bloom = (innerBloom / 8.0) * 0.65 + (outerBloom / 8.0) * 0.35;

    // Tint the halo toward warm CRT phosphor amber (#f0a850)
    vec3 amberTint = vec3(1.10, 0.74, 0.30);
    color.rgb += bloom * amberTint * 0.72;

    // Horizontal CRT scanlines (~12% modulation)
    float scanline = 0.94 + 0.06 * sin(gl_FragCoord.y * 3.14159265);
    color.rgb *= scanline;

    // Subtle CRT edge vignette
    vec2 uv = v_texcoord * (1.0 - v_texcoord.yx);
    float vignette = clamp(pow(uv.x * uv.y * 16.0, 0.10), 0.88, 1.0);
    color.rgb *= vignette;

    fragColor = color;
}
