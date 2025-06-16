'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
  const router = useRouter();
  const [form, setForm] = useState({ email: '', password: '' });

  async function handleSubmit(e: any) {
    e.preventDefault();
    const res = await fetch('/api/login', {
      method: 'POST',
      body: JSON.stringify(form),
      headers: { 'Content-Type': 'application/json' },
    });

    if (res.ok) {
      alert('Login successful!');
      router.push('/dashboard');
    } else {
      alert('Login failed. Please check your credentials.');
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 p-6">
      <div className="w-full max-w-md bg-white shadow-md rounded-xl p-8 border border-gray-200">
        <h1 className="text-2xl font-bold text-center text-[#002147] mb-1">
          School of Software Engineering
        </h1>
        <p className="text-sm text-gray-600 text-center mb-6">
          Student Login Portal
        </p>

        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <input
            type="email"
            placeholder="Email"
            onChange={(e) => setForm({ ...form, email: e.target.value })}
            required
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#002147]"
          />
          <input
            type="password"
            placeholder="Password"
            onChange={(e) => setForm({ ...form, password: e.target.value })}
            required
            className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#002147]"
          />
          <button
            type="submit"
            className="bg-[#002147] text-white py-2 rounded-lg hover:bg-[#001030] transition"
          >
            Login
          </button>
        </form>
      </div>
    </div>
  );
}
