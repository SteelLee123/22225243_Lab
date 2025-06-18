'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';

interface Course {
  id: number;
  name: string;
  code: string;
  credits: number;
  grade: string;
  lecturer: string;
}

interface FeePayment {
  totalFees: number;
  paidAmount: number;
  remainingAmount: number;
  dueDate: string;
  status: string;
}

interface Advisor {
  name: string;
  email: string;
  department: string;
}

interface DashboardData {
  user: {
    id: number;
    name: string;
    email: string;
  };
  enrolledCourses: Course[];
  feePayment: FeePayment;
  advisor: Advisor;
}

export default function DashboardPage() {
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [logoutLoading, setLogoutLoading] = useState(false);
  const router = useRouter();

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Get logged-in user from localStorage
      const userData = localStorage.getItem('user');
      if (!userData) {
        router.push('/login');
        return;
      }
      
      const user = JSON.parse(userData);
      const response = await fetch(`/api/dashboard?userId=${user.id}`);
      
      if (!response.ok) {
        throw new Error('Failed to fetch dashboard data');
      }
      
      const data = await response.json();
      setDashboardData(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    try {
      setLogoutLoading(true);
      
      const response = await fetch('/api/logout', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        // Clear user data from localStorage
        localStorage.removeItem('user');
        router.push('/login');
      } else {
        throw new Error('Logout failed');
      }
    } catch (err) {
      console.error('Logout error:', err);
      alert('Logout failed. Please try again.');
    } finally {
      setLogoutLoading(false);
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#002147] mx-auto mb-3"></div>
          <p className="text-gray-600 text-sm">Loading...</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-lg font-medium text-gray-800 mb-2">Error Loading Dashboard</h2>
          <p className="text-gray-600 mb-4 text-sm">{error}</p>
          <button
            onClick={fetchDashboardData}
            className="bg-[#002147] text-white px-4 py-2 rounded text-sm hover:bg-[#001030] transition"
          >
            Try Again
          </button>
        </div>
      </div>
    );
  }

  if (!dashboardData) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200 mb-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-2xl font-bold text-[#002147]">
                Welcome, {dashboardData.user.name}
              </h1>
              <p className="text-gray-600 text-sm mt-1">
                School of Software Engineering
              </p>
            </div>
            <button
              onClick={handleLogout}
              disabled={logoutLoading}
              className="bg-red-600 text-white px-4 py-2 rounded text-sm hover:bg-red-700 transition disabled:opacity-50"
            >
              {logoutLoading ? 'Logging out...' : 'Logout'}
            </button>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Enrolled Courses */}
          <div className="lg:col-span-2">
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-lg font-semibold text-[#002147] mb-4">
                Enrolled Courses
              </h2>
              <div className="space-y-3">
                {dashboardData.enrolledCourses.map((course) => (
                  <div key={course.id} className="flex justify-between items-center p-3 bg-gray-50 rounded">
                    <div>
                      <p className="font-medium text-gray-800">{course.name}</p>
                      <p className="text-sm text-gray-600">{course.code} • {course.credits} credits</p>
                      <p className="text-xs text-gray-500">Lecturer: {course.lecturer}</p>
                    </div>
                    <span className="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-medium">
                      {course.grade}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Fee Payment Status */}
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-lg font-semibold text-[#002147] mb-4">
                Fee Payment Status
              </h2>
              <div className="space-y-3">
                <div className="flex justify-between">
                  <span className="text-gray-600 text-sm">Total Fees:</span>
                  <span className="font-medium">GH₵{dashboardData.feePayment.totalFees}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600 text-sm">Paid:</span>
                  <span className="font-medium text-green-600">GH₵{dashboardData.feePayment.paidAmount}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-600 text-sm">Remaining:</span>
                  <span className="font-medium text-red-600">GH₵{dashboardData.feePayment.remainingAmount}</span>
                </div>
                <div className="pt-2 border-t">
                  <p className="text-sm text-gray-600">Due: {formatDate(dashboardData.feePayment.dueDate)}</p>
                  <span className="inline-block mt-1 px-2 py-1 bg-yellow-100 text-yellow-800 rounded text-xs">
                    {dashboardData.feePayment.status}
                  </span>
                </div>
              </div>
            </div>

            {/* Advisor */}
            <div className="bg-white p-6 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-lg font-semibold text-[#002147] mb-4">
                Academic Advisor
              </h2>
              <div className="space-y-2">
                <p className="font-medium">{dashboardData.advisor.name}</p>
                <p className="text-sm text-gray-600">{dashboardData.advisor.department}</p>
                <p className="text-sm text-blue-600">{dashboardData.advisor.email}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

