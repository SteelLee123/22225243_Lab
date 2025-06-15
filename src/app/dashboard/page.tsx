'use client';
import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

export default function Dashboard() {
  const router = useRouter();

  useEffect(() => {
    const isLoggedIn = localStorage.getItem('isLoggedIn');
    if (!isLoggedIn) {
      alert('You must be logged in to view this page');
      router.push('/login');
    }
  }, []);

  return (
    <div className="p-4">
      <h1 className="text-xl font-bold">Welcome to the Dashboard</h1>
    </div>
  );
}
