import { SignJWT, jwtVerify } from "jose";

const secretKey = process.env.JWT_SECRET;

const key = new TextEncoder().encode(secretKey);

export async function createToken(user) {
    return await new SignJWT({
        id: user.id,
        username: user.username,
        role: user.role,
    })
        .setProtectedHeader({ alg: "HS256" })
        .setIssuedAt()
        .setExpirationTime("1d")
        .sign(key);
}

export async function verifyToken(token) {
    try {
        const { payload } = await jwtVerify(token, key);
        return payload;
    } catch (error) {
        return null;
    }
}