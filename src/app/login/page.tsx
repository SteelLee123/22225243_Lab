'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';

export default function LoginPage() {
  const router = useRouter();
  const [form, setForm] = useState({ email: '', password: '' });
  const [showForgotPassword, setShowForgotPassword] = useState(false);
  const [forgotEmail, setForgotEmail] = useState('');

  async function handleSubmit(e: any) {
    e.preventDefault();
    const res = await fetch('/api/login', {
      method: 'POST',
      body: JSON.stringify(form),
      headers: { 'Content-Type': 'application/json' },
    });

    if (res.ok) {
      const data = await res.json();
      // Store user information in localStorage
      localStorage.setItem('user', JSON.stringify(data.user));
      alert('Login successful!');
      router.push('/dashboard');
    } else {
      alert('Login failed. Please check your credentials.');
    }
  }

  async function handleForgotPassword(e: any) {
    e.preventDefault();
    if (!forgotEmail) {
      alert('Please enter your email address');
      return;
    }
    
    // In a real app, you would send a password reset email
    alert(`Password reset link sent to ${forgotEmail}`);
    setShowForgotPassword(false);
    setForgotEmail('');
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

        {!showForgotPassword ? (
          <>
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

            <div className="mt-4 text-center">
              <button
                onClick={() => setShowForgotPassword(true)}
                className="text-sm text-[#002147] hover:underline"
              >
                Forgot Password?
              </button>
            </div>

            <div className="mt-6 text-center">
              <p className="text-sm text-gray-600">
                Don't have an account?{' '}
                <Link href="/register" className="text-[#002147] hover:underline font-medium">
                  Register here
                </Link>
              </p>
            </div>
          </>
        ) : (
          <>
            <form onSubmit={handleForgotPassword} className="flex flex-col gap-4">
              <h2 className="text-lg font-semibold text-center text-[#002147] mb-4">
                Reset Password
              </h2>
              <p className="text-sm text-gray-600 text-center mb-4">
                Enter your email address and we'll send you a link to reset your password.
              </p>
              <input
                type="email"
                placeholder="Enter your email"
                value={forgotEmail}
                onChange={(e) => setForgotEmail(e.target.value)}
                required
                className="p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#002147]"
              />
              <button
                type="submit"
                className="bg-[#002147] text-white py-2 rounded-lg hover:bg-[#001030] transition"
              >
                Send Reset Link
              </button>
            </form>

            <div className="mt-4 text-center">
              <button
                onClick={() => setShowForgotPassword(false)}
                className="text-sm text-gray-600 hover:underline"
              >
                Back to Login
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
