precision mediump float;

attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform mat4 u_projectionMatrix;

// This uniform values are passed in using CSS.
uniform float apex;
uniform float theta;
uniform float rho;

varying vec2 v_texCoord;

const float PI = 3.14159;
const float degToRad = PI / 180.0;

vec4 deform(vec4 pt)
{
    pt.x += 0.5;
    pt.y = (-pt.y + 0.5);
    pt.z += 0.5;
    
    float thetaRad = theta * degToRad;
    float rhoRad = rho * degToRad;

    // Radius of the circle circumscribed by vertex (vi.x, vi.y) around apex on the x-y plane
    float r = sqrt((pt.x * pt.x) + pow((pt.y - apex), 2.0));

    // Now get the radius of the cone cross section intersected by our vertex in 3D space.
    float coneRad = r * sin(thetaRad);                       

    // Angle subtended by arc |ST| on the cone cross section.
    float beta  = asin(pt.x / r) / sin(thetaRad);       

    vec3 vec = vec3(
        coneRad * sin(beta), 
        r + apex - coneRad * (1.0 - cos(beta)) * sin(thetaRad), 
        coneRad * (1.0 - cos(beta)) * cos(thetaRad));

    // Apply a basic rotation transform around the y axis to rotate the curled page.
    // These two steps could be combined through simple substitution, but are left
    // separate to keep the math simple for debugging and illustrative purposes.
    vec4 newpos = vec4(
        (vec.x * cos(rhoRad)) - (vec.z * sin(rhoRad)),
        vec.y,
        (vec.x * sin(rhoRad)) + vec.z * cos(rhoRad), 1.0);

    newpos.x -= 0.5;
    newpos.y = -(newpos.y - 0.5);
    newpos.z -= 0.5;

    return newpos;
}

void main()
{
    v_texCoord = a_texCoord;
    
    gl_Position = u_projectionMatrix * deform(a_position);
}
