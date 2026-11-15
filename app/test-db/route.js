import pool from "@/lib/db";

export async function GET() {
    try {
        const result = await pool.query(
            "SELECT current_database()"
        );

        return Response.json({
            success: true,
            message: "Database berhasil terhubung!",
            database: result.rows[0].current_database,
        });
    } catch (error) {
        return Response.json({
            success: false,
            message: error.message,
        }, { status: 500 });
    }
}