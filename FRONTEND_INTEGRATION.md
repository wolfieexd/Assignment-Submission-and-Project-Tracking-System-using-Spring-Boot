# 🔗 Frontend-Backend Integration Guide

## Connecting React Frontend to Spring Boot Backend

### Current Setup Status

✅ **Frontend**: React + TypeScript + Vite (Port 8080)  
✅ **Backend**: Spring Boot User Service (Port 8081)  
✅ **Security**: JWT Token Authentication  
✅ **CORS**: Enabled for http://localhost:8080  

---

## 🔧 Integration Steps

### Step 1: Update Frontend Storage Helper

The storage helper (`src/lib/storage.ts`) is already configured! It will store:
- `app:token` - JWT token from backend
- `app:userRole` - User role (STUDENT/FACULTY)
- `app:userEmail` - User email
- `app:userName` - User name

### Step 2: Update Login Page

Modify `src/pages/Login.tsx` to call the backend API:

```typescript
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { GraduationCap } from "lucide-react";
import { setItem } from "@/lib/storage";
import { toast } from "sonner";

const API_URL = "http://localhost:8081/api/auth";

const Login = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch(`${API_URL}/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Login failed");
      }

      // Store auth data
      setItem("token", data.token);
      setItem("userRole", data.role);
      setItem("userEmail", data.email);
      setItem("userName", data.name);

      toast.success("Login successful!");

      // Navigate based on role
      if (data.role === "STUDENT") {
        navigate("/student/dashboard");
      } else if (data.role === "FACULTY") {
        navigate("/faculty/dashboard");
      }
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Login failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md shadow-elevated">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-4">
            <div className="p-3 rounded-xl bg-gradient-to-br from-primary to-accent">
              <GraduationCap className="w-8 h-8 text-primary-foreground" />
            </div>
          </div>
          <CardTitle className="text-2xl font-bold">Welcome Back</CardTitle>
          <CardDescription>Sign in to your account to continue</CardDescription>
        </CardHeader>
        <form onSubmit={handleLogin}>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="student@university.edu"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
            </div>
          </CardContent>
          <CardFooter className="flex flex-col space-y-4">
            <Button 
              type="submit" 
              className="w-full bg-gradient-to-r from-primary to-accent hover:opacity-90 transition-opacity"
              disabled={loading}
            >
              {loading ? "Signing in..." : "Sign In"}
            </Button>
            <p className="text-sm text-muted-foreground text-center">
              Don't have an account?{" "}
              <a href="/register" className="text-primary hover:underline font-medium">
                Register
              </a>
            </p>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
};

export default Login;
```

### Step 3: Update Register Page

Modify `src/pages/Register.tsx`:

```typescript
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { GraduationCap } from "lucide-react";
import { toast } from "sonner";

const API_URL = "http://localhost:8081/api/auth";

const Register = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    department: "",
    role: "student" as "student" | "faculty"
  });
  const [loading, setLoading] = useState(false);

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await fetch(`${API_URL}/register`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Registration failed");
      }

      toast.success("Registration successful! Please login.");
      navigate("/login");
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Registration failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md shadow-elevated">
        <CardHeader className="space-y-1 text-center">
          <div className="flex justify-center mb-4">
            <div className="p-3 rounded-xl bg-gradient-to-br from-primary to-accent">
              <GraduationCap className="w-8 h-8 text-primary-foreground" />
            </div>
          </div>
          <CardTitle className="text-2xl font-bold">Create Account</CardTitle>
          <CardDescription>Register to get started</CardDescription>
        </CardHeader>
        <form onSubmit={handleRegister}>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Full Name</Label>
              <Input
                id="name"
                placeholder="John Doe"
                value={formData.name}
                onChange={(e) => setFormData({...formData, name: e.target.value})}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="student@university.edu"
                value={formData.email}
                onChange={(e) => setFormData({...formData, email: e.target.value})}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({...formData, password: e.target.value})}
                required
                minLength={6}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="department">Department</Label>
              <Select 
                value={formData.department} 
                onValueChange={(value) => setFormData({...formData, department: value})}
                required
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select department" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Computer Science">Computer Science</SelectItem>
                  <SelectItem value="Electrical Engineering">Electrical Engineering</SelectItem>
                  <SelectItem value="Mechanical Engineering">Mechanical Engineering</SelectItem>
                  <SelectItem value="Civil Engineering">Civil Engineering</SelectItem>
                  <SelectItem value="Mathematics">Mathematics</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>I am a</Label>
              <RadioGroup 
                value={formData.role} 
                onValueChange={(value) => setFormData({...formData, role: value as "student" | "faculty"})}
              >
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="student" id="student" />
                  <Label htmlFor="student" className="cursor-pointer">Student</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="faculty" id="faculty" />
                  <Label htmlFor="faculty" className="cursor-pointer">Faculty</Label>
                </div>
              </RadioGroup>
            </div>
          </CardContent>
          <CardFooter className="flex flex-col space-y-4">
            <Button 
              type="submit" 
              className="w-full bg-gradient-to-r from-primary to-accent hover:opacity-90 transition-opacity"
              disabled={loading}
            >
              {loading ? "Creating Account..." : "Create Account"}
            </Button>
            <p className="text-sm text-muted-foreground text-center">
              Already have an account?{" "}
              <a href="/login" className="text-primary hover:underline font-medium">
                Sign In
              </a>
            </p>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
};

export default Register;
```

### Step 4: Create API Service Helper

Create `src/lib/api.ts`:

```typescript
import { getItem } from './storage';

const API_BASE_URL = 'http://localhost:8081/api';

export const apiClient = {
  async request(endpoint: string, options: RequestInit = {}) {
    const token = getItem('token');
    
    const headers = {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options.headers,
    };

    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Request failed');
    }

    return response.json();
  },

  get(endpoint: string) {
    return this.request(endpoint, { method: 'GET' });
  },

  post(endpoint: string, data: unknown) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  put(endpoint: string, data: unknown) {
    return this.request(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  delete(endpoint: string) {
    return this.request(endpoint, { method: 'DELETE' });
  },
};
```

---

## 🧪 Testing the Integration

### 1. Start Both Services

**Terminal 1 - Backend:**
```powershell
cd backend/user-service
mvn spring-boot:run
```

**Terminal 2 - Frontend:**
```powershell
pnpm run dev
```

### 2. Test Registration Flow

1. Go to http://localhost:8080
2. Click "Register"
3. Fill in the form:
   - Name: Test Student
   - Email: test@student.com
   - Password: password123
   - Department: Computer Science
   - Role: Student
4. Click "Create Account"
5. You should see "Registration successful! Please login"

### 3. Test Login Flow

1. On login page, enter:
   - Email: test@student.com
   - Password: password123
2. Click "Sign In"
3. You should be redirected to `/student/dashboard`

### 4. Verify in H2 Console

1. Go to http://localhost:8081/h2-console
2. JDBC URL: `jdbc:h2:mem:userdb`
3. Username: `sa`
4. Password: (leave empty)
5. Click "Connect"
6. Run query: `SELECT * FROM STUDENTS;`
7. You should see your registered user!

---

## 🔐 Authentication Flow

```
1. User enters credentials in React form
   ↓
2. Frontend sends POST to /api/auth/login
   ↓
3. Backend validates credentials
   ↓
4. Backend generates JWT token
   ↓
5. Frontend receives { token, email, name, role }
   ↓
6. Frontend stores in localStorage with namespace
   ↓
7. Future requests include: Authorization: Bearer <token>
```

---

## 🛠 Troubleshooting

### CORS Error
```
Access to fetch at 'http://localhost:8081/api/auth/login' from origin 
'http://localhost:8080' has been blocked by CORS policy
```

**Solution:** Backend is already configured! Make sure User Service is running.

### 401 Unauthorized
- Check that token is being sent in Authorization header
- Verify token hasn't expired (24-hour validity)
- Check token is stored correctly in localStorage

### Network Error
- Ensure backend is running on port 8081
- Check `API_URL` matches backend port
- Verify no firewall blocking localhost connections

---

## 📦 Dependencies to Add

Add to `package.json`:

```json
{
  "dependencies": {
    "sonner": "^1.7.4"
  }
}
```

Then run:
```powershell
pnpm install
```

---

## ✅ Integration Checklist

- [ ] Backend running on port 8081
- [ ] Frontend running on port 8080
- [ ] Updated Login.tsx with API calls
- [ ] Updated Register.tsx with API calls
- [ ] Created src/lib/api.ts helper
- [ ] Tested registration flow
- [ ] Tested login flow
- [ ] Verified token storage
- [ ] Checked H2 database
- [ ] Tested logout (clears localStorage)

---

## 🎉 Success Indicators

When everything works:
1. ✅ Registration creates user in database
2. ✅ Login returns JWT token
3. ✅ Token stored in localStorage with 'app:' prefix
4. ✅ User redirected to correct dashboard (student/faculty)
5. ✅ Logout clears app-specific keys only

---

**Your full-stack application is now connected!** 🚀
