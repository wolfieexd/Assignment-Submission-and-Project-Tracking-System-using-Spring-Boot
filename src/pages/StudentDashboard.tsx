import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Calendar, Clock, FileText, CheckCircle, AlertCircle, TrendingUp, Upload } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { getItem, clearAppStorage } from "@/lib/storage";

// Mock data
const mockAssignments = [
  { id: 1, title: "Database Design Project", course: "CS 301", dueDate: "2025-11-05", status: "pending", description: "Design and implement a relational database" },
  { id: 2, title: "Spring Boot REST API", course: "CS 401", dueDate: "2025-10-28", status: "overdue", description: "Create RESTful web services" },
  { id: 3, title: "Data Structures Lab", course: "CS 201", dueDate: "2025-11-10", status: "submitted", description: "Implement binary search trees" },
  { id: 4, title: "Software Testing Assignment", course: "CS 302", dueDate: "2025-11-15", status: "pending", description: "Write unit tests using JUnit" },
];

const mockProjects = [
  { id: 1, title: "E-Commerce Platform", progress: 65, status: "In Progress", deadline: "2025-12-15", milestones: 4, completed: 3 },
  { id: 2, title: "Mobile Banking App", progress: 30, status: "In Progress", deadline: "2026-01-20", milestones: 5, completed: 1 },
];

const StudentDashboard = () => {
  const navigate = useNavigate();
  const userName = getItem("userName") || "Student";

  const getStatusBadge = (status: string) => {
    const variants: Record<string, { className: string; icon: React.ReactNode }> = {
      pending: { className: "bg-warning text-warning-foreground", icon: <Clock className="w-3 h-3 mr-1" /> },
      overdue: { className: "bg-destructive text-destructive-foreground", icon: <AlertCircle className="w-3 h-3 mr-1" /> },
      submitted: { className: "bg-success text-success-foreground", icon: <CheckCircle className="w-3 h-3 mr-1" /> },
    };
    
    const variant = variants[status] || variants.pending;
    return (
      <Badge className={variant.className}>
        {variant.icon}
        {status.charAt(0).toUpperCase() + status.slice(1)}
      </Badge>
    );
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-primary/5">
      {/* Header */}
      <header className="border-b bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
              Student Portal
            </h1>
            <p className="text-sm text-muted-foreground">Welcome back, {userName}</p>
          </div>
          <Button variant="outline" onClick={() => {
            // remove only our app's storage keys
            clearAppStorage();
            navigate("/login");
          }}>
            Logout
          </Button>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Total Assignments</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold">{mockAssignments.length}</div>
            </CardContent>
          </Card>
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Pending</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-warning">{mockAssignments.filter(a => a.status === "pending").length}</div>
            </CardContent>
          </Card>
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Submitted</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-success">{mockAssignments.filter(a => a.status === "submitted").length}</div>
            </CardContent>
          </Card>
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Active Projects</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-accent">{mockProjects.length}</div>
            </CardContent>
          </Card>
        </div>

        {/* Main Content */}
        <Tabs defaultValue="assignments" className="space-y-6">
          <TabsList className="grid w-full max-w-md grid-cols-2">
            <TabsTrigger value="assignments">Assignments</TabsTrigger>
            <TabsTrigger value="projects">Projects</TabsTrigger>
          </TabsList>

          <TabsContent value="assignments" className="space-y-4">
            {mockAssignments.map((assignment) => (
              <Card key={assignment.id} className="shadow-card hover:shadow-elevated transition-all">
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div className="space-y-1">
                      <CardTitle className="text-xl">{assignment.title}</CardTitle>
                      <CardDescription className="flex items-center gap-2">
                        <FileText className="w-4 h-4" />
                        {assignment.course}
                      </CardDescription>
                    </div>
                    {getStatusBadge(assignment.status)}
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <p className="text-muted-foreground">{assignment.description}</p>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                      <Calendar className="w-4 h-4" />
                      Due: {new Date(assignment.dueDate).toLocaleDateString()}
                    </div>
                    <Button 
                      onClick={() => navigate(`/student/assignment/${assignment.id}`)}
                      className="bg-gradient-to-r from-primary to-accent hover:opacity-90"
                    >
                      <Upload className="w-4 h-4 mr-2" />
                      {assignment.status === "submitted" ? "View Submission" : "Submit"}
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </TabsContent>

          <TabsContent value="projects" className="space-y-4">
            {mockProjects.map((project) => (
              <Card key={project.id} className="shadow-card hover:shadow-elevated transition-all">
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div>
                      <CardTitle className="text-xl">{project.title}</CardTitle>
                      <CardDescription className="flex items-center gap-2 mt-1">
                        <TrendingUp className="w-4 h-4" />
                        {project.status}
                      </CardDescription>
                    </div>
                    <Badge variant="outline" className="text-sm">
                      {project.completed}/{project.milestones} Milestones
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">Progress</span>
                      <span className="font-medium">{project.progress}%</span>
                    </div>
                    <Progress value={project.progress} className="h-2" />
                  </div>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                      <Calendar className="w-4 h-4" />
                      Deadline: {new Date(project.deadline).toLocaleDateString()}
                    </div>
                    <Button 
                      variant="outline"
                      onClick={() => {
                        // TODO: Create project details page
                        alert(`Project details for "${project.title}" - This feature will be implemented soon!`);
                      }}
                    >
                      View Details
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
};

export default StudentDashboard;
