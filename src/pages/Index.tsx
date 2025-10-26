import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { GraduationCap, BookOpen, Users, TrendingUp } from "lucide-react";

const Index = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-primary/10">
      {/* Hero Section */}
      <div className="container mx-auto px-4 py-20">
        <div className="text-center space-y-8 max-w-4xl mx-auto">
          <div className="flex justify-center mb-6">
            <div className="p-6 rounded-2xl bg-gradient-to-br from-primary to-accent shadow-elevated">
              <GraduationCap className="w-16 h-16 text-primary-foreground" />
            </div>
          </div>
          
          <h1 className="text-5xl md:text-6xl font-bold bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent leading-tight">
            Assignment Submission & Project Tracking System
          </h1>
          
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            A comprehensive platform for managing academic assignments, tracking project progress, 
            and facilitating collaboration between students and faculty.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center pt-4">
            <Button 
              size="lg"
              onClick={() => navigate("/login")}
              className="bg-gradient-to-r from-primary to-accent hover:opacity-90 text-lg px-8"
            >
              Get Started
            </Button>
            <Button 
              size="lg"
              variant="outline"
              onClick={() => navigate("/register")}
              className="text-lg px-8"
            >
              Register
            </Button>
          </div>
        </div>

        {/* Features Grid */}
        <div className="grid md:grid-cols-3 gap-8 mt-24">
          <div className="p-6 rounded-xl bg-card shadow-card hover:shadow-elevated transition-all border">
            <div className="p-3 rounded-lg bg-primary/10 w-fit mb-4">
              <BookOpen className="w-6 h-6 text-primary" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Assignment Management</h3>
            <p className="text-muted-foreground">
              Create, submit, and track assignments with ease. Faculty can upload assignments and students can submit their work seamlessly.
            </p>
          </div>

          <div className="p-6 rounded-xl bg-card shadow-card hover:shadow-elevated transition-all border">
            <div className="p-3 rounded-lg bg-accent/10 w-fit mb-4">
              <TrendingUp className="w-6 h-6 text-accent" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Project Tracking</h3>
            <p className="text-muted-foreground">
              Monitor project progress through different stages with visual indicators and milestone tracking for better oversight.
            </p>
          </div>

          <div className="p-6 rounded-xl bg-card shadow-card hover:shadow-elevated transition-all border">
            <div className="p-3 rounded-lg bg-success/10 w-fit mb-4">
              <Users className="w-6 h-6 text-success" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Collaboration</h3>
            <p className="text-muted-foreground">
              Facilitate communication between students and faculty with organized submission reviews and feedback mechanisms.
            </p>
          </div>
        </div>

        {/* Tech Stack Info */}
        <div className="mt-24 text-center">
          <p className="text-sm text-muted-foreground mb-4">Built with modern technologies</p>
          <div className="flex flex-wrap justify-center gap-4 text-sm font-medium">
            <span className="px-4 py-2 rounded-full bg-primary/10 text-primary">React</span>
            <span className="px-4 py-2 rounded-full bg-primary/10 text-primary">TypeScript</span>
            <span className="px-4 py-2 rounded-full bg-primary/10 text-primary">Spring Boot</span>
            <span className="px-4 py-2 rounded-full bg-primary/10 text-primary">Tailwind CSS</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
