'use client';

export default function DashboardPage() {
  return (
    <div className="min-h-screen bg-gray-50 p-6 flex flex-col items-center justify-center">
      <div className="w-full max-w-3xl bg-white p-8 shadow-md rounded-xl border border-gray-200">
        <h1 className="text-3xl font-bold text-[#002147] text-center mb-2">
          Welcome to Your Dashboard
        </h1>
        <p className="text-center text-gray-600 mb-6">
          School of Software Engineering
        </p>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="bg-[#f1f5f9] p-4 rounded-lg">
            <h2 className="font-semibold text-lg mb-1">Enrolled Courses</h2>
            <p className="text-sm text-gray-700">Data Structures, Software Engineering, Algorithms</p>
          </div>
          <div className="bg-[#f1f5f9] p-4 rounded-lg">
            <h2 className="font-semibold text-lg mb-1">Fee Payment Status</h2>
            <p className="text-sm text-gray-700">GH₵1500 Paid</p>
          </div>
          <div className="bg-[#f1f5f9] p-4 rounded-lg">
            <h2 className="font-semibold text-lg mb-1">Advisor</h2>
            <p className="text-sm text-gray-700">Dr. John Kutor</p>
          </div>
          <div className="bg-[#f1f5f9] p-4 rounded-lg">
            <h2 className="font-semibold text-lg mb-1">Upcoming Events</h2>
            <p className="text-sm text-gray-700">Project demo due next week.</p>
          </div>
        </div>

        <div className="mt-6 text-center">
          <button
            className="bg-[#002147] text-white px-6 py-2 rounded-lg hover:bg-[#001030] transition"
            onClick={() => alert('You are now logged out (mock).')}
          >
            Logout
          </button>
        </div>
      </div>
    </div>
  );
}

