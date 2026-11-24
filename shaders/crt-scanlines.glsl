#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // Subtle 2px-period horizontal CRT scanlines (~6% modulation so text stays crisp)
    float scanline = 0.97 + 0.03 * sin(gl_FragCoord.y * 3.14159265);
    color.rgb *= scanline;

    // Very subtle edge vignette
    vec2 uv = v_texcoord * (1.0 - v_texcoord.yx);
    float vignette = clamp(pow(uv.x * uv.y * 16.0, 0.08), 0.92, 1.0);
    color.rgb *= vignette;

    fragColor = color;
}
