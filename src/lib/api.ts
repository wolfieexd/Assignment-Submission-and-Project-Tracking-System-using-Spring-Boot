// API Configuration and Helper Functions
// Use the current hostname to support both localhost and network access
const API_BASE_URL = window.location.hostname === 'localhost' 
  ? 'http://localhost:8081/api'
  : `http://${window.location.hostname}:8081/api`;

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
