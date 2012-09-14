/*
 * Copyright (c) 2012 Adobe Systems Incorporated. All rights reserved.
 * Copyright (c) 2012 Branislav Ulicny
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

precision mediump float;

attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform mat4 u_projectionMatrix;

// This uniform values are passed in using CSS.
uniform float apex;
uniform float theta;
uniform float pageRotation;
uniform vec3 pointLightPosition;

varying vec2 v_texCoord;

const float PI = 3.14159;
const float degToRad = PI / 180.0;

varying float pointLightIntensity;

// This page curl algorithm is from the publication "Deforming Pages of 3D Electronic Books"
// by Lichan Hong, Stuart K. Card, and Jindong (JD) Chen.
// Implemented with help from Chris Luke's article, "The anatomy of a page curl"

vec4 getTransformedCenterPt(vec4 pt)
{
    pt.x += 0.5;
    pt.y = (-pt.y + 0.5);
    pt.z += 0.5;
    
    // Radius of the circle circumscribed by vertex (vi.x, vi.y) around apex on the x-y plane
    float r = sqrt((pt.x * pt.x) + pow((pt.y - apex), 2.0));
  
    // Return S, the point on the circle that intersects the Y axis.
    // This point will make it easy to calculate transformed surface 
    // normals since the normal will point from the transformed pt to S.
    return vec4(0.0, r-apex, 0.0, 1.0);
}

vec4 deform(vec4 pt)
{
    pt.x += 0.5;
    pt.y = (-pt.y + 0.5);
    pt.z += 0.5;
    
    float thetaRad = theta * degToRad;
    float pageRotationRad = pageRotation * degToRad;

	float cosTheta = cos(thetaRad);
	float sinTheta = sin(thetaRad);

	float cosPageRotation = cos(pageRotationRad);
	float sinPageRotation = sin(pageRotationRad);

    // Radius of the circle circumscribed by vertex (vi.x, vi.y) around apex on the x-y plane
    float r = sqrt((pt.x * pt.x) + pow((pt.y - apex), 2.0));

    // Now get the radius of the cone cross section intersected by our vertex in 3D space.
    float coneRad = r * sinTheta;

    // Angle subtended by arc |ST| on the cone cross section.
    float beta  = asin(pt.x / r) / sinTheta;

    vec3 vec = vec3(
        coneRad * sin(beta), 
        r + apex - coneRad * (1.0 - cos(beta)) * sinTheta,
        coneRad * (1.0 - cos(beta)) * cosTheta);

    // Apply a basic rotation transform around the y axis to rotate the curled page.
    // These two steps could be combined through simple substitution, but are left
    // separate to keep the math simple for debugging and illustrative purposes.
    vec4 newpos = vec4(
        (vec.x * cosPageRotation) - (vec.z * sinPageRotation),
        vec.y,
        (vec.x * sinPageRotation) + vec.z * cosPageRotation, 1.0);

    newpos.x -= 0.5;
    newpos.y = -(newpos.y - 0.5);
    newpos.z -= 0.5;

    return newpos;
}

void main()
{
    v_texCoord = a_texCoord;
    
    vec4 newpos = deform(a_position);
  
    vec4 centerPt = getTransformedCenterPt(a_position);
    vec3 normal = normalize((centerPt - newpos).xyz);

    vec3 lightVector = normalize(pointLightPosition - a_position.xyz);
  
    // Bump up the lighting a bit so it doesn't get too dark too quickly
    pointLightIntensity = min(1.0, dot(normal, lightVector)+0.4);


    gl_Position = u_projectionMatrix * newpos;
}
