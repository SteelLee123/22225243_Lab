import { PrismaClient } from '@prisma/client';
import { NextResponse } from 'next/server';

const prisma = new PrismaClient();

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { name, email, password } = body;

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return NextResponse.json({ error: 'Email already exists' }, { status: 400 });
    }

    const user = await prisma.user.create({
      data: { name, email, password },
    });

    return NextResponse.json(user);
  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}
