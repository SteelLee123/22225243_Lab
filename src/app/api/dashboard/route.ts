import { PrismaClient } from '@prisma/client';
import { NextResponse } from 'next/server';

const prisma = new PrismaClient();

export async function GET(req: Request) {
  try {
    const url = new URL(req.url);
    const userId = url.searchParams.get('userId') || '1';

    const user = await prisma.user.findUnique({
      where: { id: parseInt(userId) },
    });

    if (!user) {
      return NextResponse.json({ error: 'User not found' }, { status: 404 });
    }

    const dashboardData = {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
      enrolledCourses: [
        { id: 1, name: 'Data Structures', code: 'CPEN201', credits: 3, grade: 'A-', lecturer: 'Dr. John Assiamah' },
        { id: 2, name: 'Software Engineering', code: 'CPEN208', credits: 3, grade: 'B+', lecturer: 'Dr. John Assiamah' },
        { id: 3, name: 'Algorithms', code: 'CPEN204', credits: 3, grade: 'A', lecturer: 'Dr. Sarah Mensah' },
        { id: 4, name: 'Database Systems', code: 'CPEN302', credits: 3, grade: 'B', lecturer: 'Dr. Michael Addo' },
      ],
      feePayment: {
        totalFees: 2000,
        paidAmount: 1500,
        remainingAmount: 500,
        dueDate: '2025-01-25',
        status: 'Partial Payment',
      },
      advisor: {
        name: 'Dr. John Assiamah',
        email: 'john.assiamah@university.edu',
        department: 'Computer Engineering',
      },
    };

    return NextResponse.json(dashboardData);
  } catch (error) {
    console.error('Dashboard data fetch error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}