# 🎯 QUICK START - Production Deployment

## ✅ Current Status
- ✅ Backend services running on ports 8081, 8082
- ✅ Connected to Neon PostgreSQL (production database)
- ✅ Code pushed to GitHub
- ✅ Ready for deployment!

---

## 📋 Next Steps (Choose Your Path)

### 🔥 FASTEST PATH (5 minutes - Recommended!)

**1. Install ngrok** (2 minutes)
```
Download: https://ngrok.com/download
Extract to: C:\ngrok\
```

**2. Setup ngrok** (1 minute)
```powershell
# Sign up FREE (no credit card): https://dashboard.ngrok.com/signup
# Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken

ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
```

**3. Start ngrok tunnels** (1 minute)
```powershell
# Window 1 - User Service
ngrok http 8081

# Window 2 - Submission Service  
ngrok http 8082
```

**SAVE THESE URLS!** You'll see something like:
- `https://abc123.ngrok-free.app` → User Service
- `https://xyz789.ngrok-free.app` → Submission Service

**4. Deploy to Vercel** (2 minutes)
- Go to: https://vercel.com/signup
- Click "Continue with GitHub"
- Click "Add New Project"
- Select your repository
- Set environment variables:
  - `VITE_API_URL` = `https://YOUR-USER-SERVICE-URL.ngrok-free.app/api`
  - `VITE_SUBMISSION_API_URL` = `https://YOUR-SUBMISSION-SERVICE-URL.ngrok-free.app/api`
- Click "Deploy"!

**DONE!** 🎉 Your app is live!

---

### 🌐 ALTERNATIVE PATH (If ngrok doesn't work)

Use **Cloudflare Tunnel** instead (also free):
```powershell
# Install
winget install --id Cloudflare.cloudflared

# Login
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create assignment-backend

# Run tunnels
cloudflared tunnel run assignment-backend --url http://localhost:8081
cloudflared tunnel run assignment-backend --url http://localhost:8082
```

Then follow same Vercel steps above!

---

## 🔗 Important Links

| What | URL |
|------|-----|
| **ngrok Download** | https://ngrok.com/download |
| **ngrok Dashboard** | https://dashboard.ngrok.com |
| **Vercel Signup** | https://vercel.com/signup |
| **Neon Console** | https://console.neon.tech |
| **GitHub Repo** | https://github.com/wolfieexd/Assignment-Submission-and-Project-Tracking-System-using-Spring-Boot |

---

## 📖 Full Documentation

Read **DEPLOYMENT.md** for complete step-by-step guide with troubleshooting!

---

## ⚡ Quick Commands Reference

```powershell
# Start backend services
.\start-user-service-neon.ps1
.\start-submission-service-neon.ps1

# Start ngrok tunnels
ngrok http 8081
ngrok http 8082

# Check service status
Get-Process -Name java | Select-Object Id, ProcessName
```

---

## 🎯 What You'll Get

✅ **Frontend**: https://your-project.vercel.app (auto-deploys from GitHub)
✅ **User API**: https://abc123.ngrok-free.app (public tunnel)
✅ **Submission API**: https://xyz789.ngrok-free.app (public tunnel)
✅ **Database**: Neon PostgreSQL (always online)
✅ **Total Cost**: $0/month (100% FREE!)

---

## 💡 Pro Tips

1. **Keep ngrok windows open** while app is deployed
2. **Free ngrok URLs change** when you restart (upgrade for static URLs)
3. **Vercel auto-deploys** when you push to GitHub
4. **Backend must be running** on your machine for ngrok to work

---

## 🐛 Need Help?

1. Backend not responding? → Check if services are running
2. CORS errors? → Update application-neon.properties with Vercel URL
3. ngrok tunnel closed? → Restart ngrok and update Vercel env vars
4. Database errors? → Check Neon console (console.neon.tech)

---

**Ready to deploy? Let's go! 🚀**
