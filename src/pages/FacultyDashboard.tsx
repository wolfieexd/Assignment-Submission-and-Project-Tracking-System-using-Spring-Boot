import { useState } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { PlusCircle, FileText, Users, CheckCircle, Clock, FolderKanban } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { getItem, clearAppStorage } from "@/lib/storage";

// Mock data
const mockAssignments = [
  { id: 1, title: "Database Design Project", course: "CS 301", submissions: 45, total: 50, dueDate: "2025-11-05" },
  { id: 2, title: "Spring Boot REST API", course: "CS 401", submissions: 38, total: 42, dueDate: "2025-10-28" },
  { id: 3, title: "Data Structures Lab", course: "CS 201", submissions: 60, total: 60, dueDate: "2025-11-10" },
];

const mockProjects = [
  { id: 1, title: "E-Commerce Platform", teams: 3, status: "active", progress: 65 },
  { id: 2, title: "Mobile Banking App", teams: 2, status: "active", progress: 30 },
  { id: 3, title: "Social Media Dashboard", teams: 4, status: "completed", progress: 100 },
];

const FacultyDashboard = () => {
  const navigate = useNavigate();
  const userName = getItem("userName") || "Faculty";

  const getSubmissionRate = (submitted: number, total: number) => {
    const rate = (submitted / total) * 100;
    if (rate === 100) return { color: "bg-success", text: "Complete" };
    if (rate >= 80) return { color: "bg-warning", text: "Good" };
    return { color: "bg-destructive", text: "Pending" };
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-accent/5">
      {/* Header */}
      <header className="border-b bg-card/50 backdrop-blur-sm sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
              Faculty Portal
            </h1>
            <p className="text-sm text-muted-foreground">Welcome, Prof. {userName}</p>
          </div>
          <div className="flex gap-2">
            <Button onClick={() => navigate("/faculty/create-assignment")} className="bg-gradient-to-r from-primary to-accent hover:opacity-90">
              <PlusCircle className="w-4 h-4 mr-2" />
              New Assignment
            </Button>
            <Button variant="outline" onClick={() => {
              clearAppStorage();
              navigate("/login");
            }}>
              Logout
            </Button>
          </div>
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
              <CardTitle className="text-sm font-medium text-muted-foreground">Total Students</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-primary">152</div>
            </CardContent>
          </Card>
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Active Projects</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-accent">{mockProjects.filter(p => p.status === "active").length}</div>
            </CardContent>
          </Card>
          <Card className="shadow-card hover:shadow-elevated transition-shadow">
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-medium text-muted-foreground">Pending Reviews</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-warning">23</div>
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
            {mockAssignments.map((assignment) => {
              const submissionStatus = getSubmissionRate(assignment.submissions, assignment.total);
              return (
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
                      <Badge className={`${submissionStatus.color} text-white`}>
                        {submissionStatus.text}
                      </Badge>
                    </div>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <div className="flex items-center gap-2 text-sm">
                          <Users className="w-4 h-4 text-muted-foreground" />
                          <span className="font-medium">{assignment.submissions}/{assignment.total}</span>
                          <span className="text-muted-foreground">submissions</span>
                        </div>
                        <div className="flex items-center gap-2 text-sm text-muted-foreground">
                          <Clock className="w-4 h-4" />
                          Due: {new Date(assignment.dueDate).toLocaleDateString()}
                        </div>
                      </div>
                      <div className="flex gap-2">
                        <Button 
                          variant="outline"
                          onClick={() => navigate(`/faculty/assignment/${assignment.id}/submissions`)}
                        >
                          <CheckCircle className="w-4 h-4 mr-2" />
                          Review
                        </Button>
                        <Button 
                          variant="outline"
                          onClick={() => navigate(`/faculty/assignment/${assignment.id}/edit`)}
                        >
                          Edit
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })}
          </TabsContent>

          <TabsContent value="projects" className="space-y-4">
            {mockProjects.map((project) => (
              <Card key={project.id} className="shadow-card hover:shadow-elevated transition-all">
                <CardHeader>
                  <div className="flex justify-between items-start">
                    <div>
                      <CardTitle className="text-xl">{project.title}</CardTitle>
                      <CardDescription className="flex items-center gap-2 mt-1">
                        <FolderKanban className="w-4 h-4" />
                        {project.teams} Teams
                      </CardDescription>
                    </div>
                    <Badge variant={project.status === "completed" ? "default" : "outline"}>
                      {project.status === "completed" ? "Completed" : "Active"}
                    </Badge>
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2 text-sm">
                      <span className="text-muted-foreground">Average Progress:</span>
                      <span className="font-medium">{project.progress}%</span>
                    </div>
                    <Button 
                      variant="outline"
                      onClick={() => navigate(`/faculty/project/${project.id}`)}
                    >
                      Manage
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

export default FacultyDashboard;
