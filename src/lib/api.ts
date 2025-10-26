// API Configuration and Helper Functions
// Support for production deployment with environment variables
const getApiBaseUrl = () => {
  // Check if running in production (Vercel)
  if (import.meta.env.VITE_API_URL) {
    return import.meta.env.VITE_API_URL;
  }
  
  // Local development
  if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    return 'http://localhost:8081/api';
  }
  
  // Network access (same machine different device)
  return `http://${window.location.hostname}:8081/api`;
};

const API_BASE_URL = getApiBaseUrl();

// Submission service URL
const getSubmissionApiUrl = () => {
  if (import.meta.env.VITE_SUBMISSION_API_URL) {
    return import.meta.env.VITE_SUBMISSION_API_URL;
  }
  
  if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
    return 'http://localhost:8082/api';
  }
  
  return `http://${window.location.hostname}:8082/api`;
};

const SUBMISSION_API_URL = getSubmissionApiUrl();

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
  department: string;
  role: 'student' | 'faculty';
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  email: string;
  name: string;
  role: string;
  message: string;
}

export interface ApiError {
  message: string;
  status?: number;
}

/**
 * Register a new user (student or faculty)
 */
export async function registerUser(data: RegisterRequest): Promise<AuthResponse> {
  const response = await fetch(`${API_BASE_URL}/auth/register`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(error || 'Registration failed');
  }

  return response.json();
}

/**
 * Login with email and password
 */
export async function loginUser(data: LoginRequest): Promise<AuthResponse> {
  const response = await fetch(`${API_BASE_URL}/auth/login`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(error || 'Login failed');
  }

  return response.json();
}

/**
 * Check backend health
 */
export async function checkHealth(): Promise<string> {
  const response = await fetch(`${API_BASE_URL}/auth/health`);
  
  if (!response.ok) {
    throw new Error('Backend service is not available');
  }

  return response.text();
}

/**
 * Get authorization header with JWT token
 */
export function getAuthHeader(): { Authorization: string } | {} {
  const token = localStorage.getItem('app:token');
  return token ? { Authorization: `Bearer ${token}` } : {};
}
